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
    String? tag,
  ) {
    return (update(sessions)..where((s) => s.id.equals(sessionId))).write(
      SessionsCompanion(
        endedAt: Value(endedAt),
        durationSeconds: Value(durationSeconds),
        tag: Value(tag),
      ),
    );
  }
}
