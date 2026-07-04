import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../db/database.dart';

/// Data object combining a project with its latest decay score/zone.
class ProjectWithDecay {
  final Project project;
  final double score;
  final String zone;
  const ProjectWithDecay({
    required this.project,
    required this.score,
    required this.zone,
  });
}

/// Provider: all active projects enriched with computed decay score.
/// Sorted Critical → Active, then by weight descending within zone.
final enrichedProjectsProvider =
    StreamProvider<List<ProjectWithDecay>>((ref) {
  return ref.watch(projectDaoProvider).watchHomeProjects().map((projects) {
    final now = DateTime.now();
    final zoneOrder = {'critical': 0, 'cold': 1, 'drifting': 2, 'active': 3};

    final enriched = projects.map((p) {
      final daysSince = p.lastSessionAt != null
          ? now.difference(p.lastSessionAt!).inHours / 24.0
          : now.difference(p.createdAt).inHours / 24.0;
      final score = _computeScore(daysSince, p.avgGapDays, p.weight);
      final zone = _scoreToZone(score);
      return ProjectWithDecay(project: p, score: score, zone: zone);
    }).toList();

    enriched.sort((a, b) {
      final zo = (zoneOrder[a.zone] ?? 9).compareTo(zoneOrder[b.zone] ?? 9);
      if (zo != 0) return zo;
      return b.project.weight.compareTo(a.project.weight);
    });

    return enriched;
  });
});

/// Provider: the currently live (un-ended) session, if any.
final liveSessionProvider = StreamProvider<Session?>((ref) {
  return ref.watch(sessionDaoProvider).watchActiveSession();
});

// ── Decay helpers (thin wrappers — real formula is in decay_calculator.dart) ──

double _computeScore(double daysSinceLast, double avgGapDays, double weight) {
  final recencyFactor = daysSinceLast / 14.0;
  final cadence = daysSinceLast / avgGapDays.clamp(0.1, double.infinity);
  final wf = 0.6 + (weight / 5.0) * 0.9;
  return ((recencyFactor * 35) + (cadence * 45) + (wf * 20)).clamp(0.0, 100.0);
}

String _scoreToZone(double score) {
  if (score < 30) return 'active';
  if (score < 55) return 'drifting';
  if (score < 80) return 'cold';
  return 'critical';
}

// ── Session notifier ──────────────────────────────────────────────────────────

class SessionNotifier extends StateNotifier<AsyncValue<void>> {
  SessionNotifier(this.ref) : super(const AsyncData(null));
  final Ref ref;

  Future<String?> startSession(String projectId) async {
    state = const AsyncLoading();
    try {
      // End any live session first
      final live =
          await ref.read(sessionDaoProvider).getActiveSession();
      if (live != null) {
        await _endLive(live, stopReason: 'external_interrupt');
      }

      final sessionId = await _startNew(projectId);
      state = const AsyncData(null);
      return sessionId;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<void> endSession(
    String sessionId, {
    String? tag,
    String? stopReason,
    String? nextStep,
  }) async {
    final now = DateTime.now();
    final sessionDao = ref.read(sessionDaoProvider);
    final projectDao = ref.read(projectDaoProvider);

    final sessions = await sessionDao.getSessionsForProject(
      await _projectIdFromSession(sessionId),
    );
    final session = sessions.where((s) => s.id == sessionId).firstOrNull;
    if (session == null) return;

    final durationSeconds = now.difference(session.startedAt).inSeconds;
    await sessionDao.endSession(
      sessionId,
      now,
      durationSeconds,
      tag,
      stopReason: stopReason,
      stopNote: nextStep,
      nextStep: nextStep,
    );

    // Update project avgGapDays + lastSessionAt + lastNote
    final project =
        await projectDao.getProjectById(session.projectId);
    if (project != null) {
      final gapDays = project.lastSessionAt != null
          ? session.startedAt
                  .difference(project.lastSessionAt!)
                  .inMinutes /
              1440.0
          : project.avgGapDays;
      final newAvg =
          (project.avgGapDays * 0.7) + (gapDays * 0.3);
      await projectDao.updateAvgGapDays(session.projectId, newAvg);
      await projectDao.updateLastSessionAt(session.projectId, now);
      if (nextStep != null && nextStep.isNotEmpty) {
        await projectDao.updateLastNote(session.projectId, nextStep);
      }
    }
  }

  Future<void> _endLive(
    Session live, {
    required String stopReason,
  }) async {
    final now = DateTime.now();
    final dur = now.difference(live.startedAt).inSeconds;
    await ref.read(sessionDaoProvider).endSession(
      live.id,
      now,
      dur,
      null,
      stopReason: stopReason,
    );
  }

  Future<String> _startNew(String projectId) async {
    final id = 'ses_${DateTime.now().millisecondsSinceEpoch}';
    await ref.read(sessionDaoProvider).startSession(
      SessionsCompanion.insert(
        id: id,
        projectId: projectId,
        startedAt: DateTime.now(),
      ),
    );
    return id;
  }

  Future<String> _projectIdFromSession(String sessionId) async {
    // Efficient: search via active session first
    final live = await ref.read(sessionDaoProvider).getActiveSession();
    if (live?.id == sessionId) return live!.projectId;
    throw Exception('Session $sessionId not found');
  }
}

final sessionNotifierProvider =
    StateNotifierProvider<SessionNotifier, AsyncValue<void>>(
  (ref) => SessionNotifier(ref),
);
