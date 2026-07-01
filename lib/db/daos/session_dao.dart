import 'package:drift/drift.dart';
import '../database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions, Projects])
class SessionDao extends DatabaseAccessor<PulseDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.db);

  // ── Queries ───────────────────────────────────────────────────────────────

  Stream<List<Session>> watchSessionsForProject(String projectId) {
    return (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .watch();
  }

  Future<List<Session>> getSessionsForProject(String projectId) {
    return (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
        .get();
  }

  /// Returns the currently active (no endedAt) session for any project.
  Future<Session?> getActiveSession() {
    return (select(sessions)
          ..where((s) => s.endedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<Session?> watchActiveSession() {
    return (select(sessions)
          ..where((s) => s.endedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Sessions within the last N days for a project (for decay calculation).
  Future<List<Session>> getRecentSessions(String projectId, {int days = 90}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.startedAt.isBiggerThanValue(cutoff))
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
        .get();
  }

  /// Total hours logged for a project in the last 7 days.
  Future<int> getTotalSecondsLastWeek(String projectId) async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final result = await (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.startedAt.isBiggerThanValue(cutoff))
          ..where((s) => s.endedAt.isNotNull()))
        .get();
    return result.fold<int>(0, (sum, s) => sum + (s.durationSeconds ?? 0));
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<void> startSession(SessionsCompanion companion) {
    return into(sessions).insert(companion);
  }

  Future<void> endSession(
    String sessionId,
    DateTime endedAt,
    int durationSeconds,
    String? tag, {
    String? stopReason,
    String? stopNote,
    String? nextStep,
  }) {
    return (update(sessions)..where((s) => s.id.equals(sessionId))).write(
      SessionsCompanion(
        endedAt: Value(endedAt),
        durationSeconds: Value(durationSeconds),
        tag: Value(tag),
        stopReason: Value(stopReason),
        stopNote: Value(stopNote),
        nextStep: Value(nextStep),
      ),
    );
  }

  /// Total seconds across all completed sessions for a project.
  Future<int> getTotalSecondsForProject(String projectId) async {
    final result = await (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.endedAt.isNotNull()))
        .get();
    return result.fold<int>(0, (sum, s) => sum + (s.durationSeconds ?? 0));
  }

  /// Stop reason counts for a project — returns map of reason → count.
  Future<Map<String, int>> getStopReasonCounts(String projectId) async {
    final result = await (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.endedAt.isNotNull())
          ..where((s) => s.stopReason.isNotNull()))
        .get();
    final counts = <String, int>{};
    for (final s in result) {
      if (s.stopReason != null) {
        counts[s.stopReason!] = (counts[s.stopReason!] ?? 0) + 1;
      }
    }
    return counts;
  }

  /// Longest gap between consecutive sessions (in days).
  Future<({double days, DateTime from, DateTime to})?> getLongestGap(String projectId) async {
    final result = await (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
        .get();
    if (result.length < 2) return null;
    double maxGap = 0;
    DateTime maxFrom = result[0].startedAt;
    DateTime maxTo = result[1].startedAt;
    for (var i = 1; i < result.length; i++) {
      final gap = result[i].startedAt.difference(result[i - 1].endedAt!).inMinutes / 1440.0;
      if (gap > maxGap) {
        maxGap = gap;
        maxFrom = result[i - 1].endedAt!;
        maxTo = result[i].startedAt;
      }
    }
    return (days: maxGap, from: maxFrom, to: maxTo);
  }
}
