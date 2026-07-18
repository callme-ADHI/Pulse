import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/database.dart';
import '../../db/daos/session_dao.dart';
import '../../engine/notifications/notification_scheduler.dart';

/// Key used to store the last heartbeat epoch-ms in shared_preferences.
const _kHeartbeatKey = 'pulse_session_heartbeat';

/// Key used to store the active session ID across restarts.
const _kActiveSessionKey = 'pulse_active_session_id';

/// Registered in [main] via [WidgetsBinding.addObserver].
///
/// Responsibilities:
/// 1. Every 30 s while the app is in foreground, write a "heartbeat"
///    (current epoch-ms) to shared_preferences.
/// 2. On [AppLifecycleState.paused] / [detached], write a final heartbeat.
/// 3. On cold-start, [recoverOrphanedSession] checks for a session that
///    never got an endedAt and closes it at the last heartbeat timestamp,
///    so the user's time is always saved.
class SessionLifecycleService extends WidgetsBindingObserver {
  SessionLifecycleService(this._db);

  final PulseDatabase _db;
  SessionDao get _dao => SessionDao(_db);

  // 30-second heartbeat ticker.
  final _stopwatch = Stopwatch();
  int _tickCount = 0;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once from [main] before [runApp].
  /// Ends any session that was abandoned when the app was killed.
  static Future<void> recoverOrphanedSession(PulseDatabase db) async {
    final dao = SessionDao(db);
    final live = await dao.getLiveSession();
    if (live == null) return; // nothing to recover

    final prefs = await SharedPreferences.getInstance();
    final heartbeatMs = prefs.getInt(_kHeartbeatKey);

    DateTime endTime;
    if (heartbeatMs != null) {
      endTime = DateTime.fromMillisecondsSinceEpoch(heartbeatMs);
      // Sanity: if heartbeat is somehow in the future or before startedAt, use now.
      if (endTime.isBefore(live.startedAt) || endTime.isAfter(DateTime.now())) {
        endTime = DateTime.now();
      }
    } else {
      // No heartbeat — use startedAt (0-second session) as a safe fallback.
      endTime = DateTime.now();
    }

    final duration = endTime.difference(live.startedAt).inSeconds;
    await (db.update(db.sessions)
          ..where((s) => s.id.equals(live.id)))
        .write(SessionsCompanion(
      endedAt: Value(endTime),
      durationSeconds: Value(duration.clamp(0, 999999)),
      stopReason: const Value('app_closed'),
    ));

    // Clear stale keys.
    await prefs.remove(_kHeartbeatKey);
    await prefs.remove(_kActiveSessionKey);

    // Cancel the dangling notification (if any).
    await cancelActiveSessionNotification();

    debugPrint('[SessionLifecycle] Recovered orphaned session ${live.id} '
        '(${duration}s, ended at $endTime)');
  }

  /// Persist the active session ID so we can redirect to it on resume.
  static Future<void> setActiveSessionId(String? sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    if (sessionId == null) {
      await prefs.remove(_kActiveSessionKey);
    } else {
      await prefs.setString(_kActiveSessionKey, sessionId);
    }
  }

  /// Returns the persisted active session ID (or null).
  static Future<String?> getActiveSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kActiveSessionKey);
  }

  // ── WidgetsBindingObserver ─────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startHeartbeat();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _writeHeartbeat();
        _stopHeartbeat();
        break;
      default:
        break;
    }
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  void _startHeartbeat() {
    _stopwatch.reset();
    _stopwatch.start();
    // Schedule a periodic check via a post-frame callback chain.
    WidgetsBinding.instance.addPostFrameCallback((_) => _tick());
  }

  void _stopHeartbeat() {
    _stopwatch.stop();
  }

  void _tick() async {
    if (!_stopwatch.isRunning) return;

    // Write heartbeat every 30 s.
    _tickCount++;
    if (_tickCount % 30 == 0) {
      await _writeHeartbeat();
    }

    // Check if there's still a live session before scheduling next tick.
    final live = await _dao.getLiveSession();
    if (live != null) {
      await Future.delayed(const Duration(seconds: 1));
      if (_stopwatch.isRunning) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _tick());
      }
    }
  }

  Future<void> _writeHeartbeat() async {
    final live = await _dao.getLiveSession();
    if (live == null) return; // No active session — no heartbeat needed.

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kHeartbeatKey, DateTime.now().millisecondsSinceEpoch);
  }
}
