import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions, Projects])
class SessionDao extends DatabaseAccessor<PulseDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<Session?> getLiveSession() =>
      (select(sessions)..where((s) => s.endedAt.isNull())).getSingleOrNull();

  Stream<Session?> watchLiveSession() =>
      (select(sessions)..where((s) => s.endedAt.isNull())).watchSingleOrNull();

  // Support both String and SessionsCompanion for backward compatibility
  Future<String> startSession(dynamic projectIdOrCompanion) async {
    if (projectIdOrCompanion is SessionsCompanion) {
      await into(sessions).insert(projectIdOrCompanion);
      return projectIdOrCompanion.id.value;
    } else if (projectIdOrCompanion is String) {
      final id = const Uuid().v4();
      await into(sessions).insert(SessionsCompanion(
        id: Value(id),
        projectId: Value(projectIdOrCompanion),
        startedAt: Value(DateTime.now()),
      ));
      return id;
    }
    throw ArgumentError('Invalid argument to startSession');
  }

  Future<void> endSession(String sessionId, {
    required String? tag,
    required String? stopReason,
    required String? nextStep,
  }) async {
    final now = DateTime.now();
    final s = await (select(sessions)..where((s) => s.id.equals(sessionId))).getSingleOrNull();
    if (s == null) return;
    final duration = now.difference(s.startedAt).inSeconds;
    await (update(sessions)..where((s) => s.id.equals(sessionId)))
        .write(SessionsCompanion(
      endedAt: Value(now),
      durationSeconds: Value(duration),
      tag: Value(tag),
      stopReason: Value(stopReason),
      nextStep: Value(nextStep),
    ));
  }

  Stream<List<Session>> watchForProject(String projectId) =>
      (select(sessions)
            ..where((s) => s.projectId.equals(projectId))
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
          .watch();

  Future<void> updateSession(String id, {
    Value<String?> tag = const Value.absent(),
    Value<String?> stopReason = const Value.absent(),
    Value<String?> nextStep = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
  }) =>
      (update(sessions)..where((s) => s.id.equals(id)))
          .write(SessionsCompanion(
        tag: tag,
        stopReason: stopReason,
        nextStep: nextStep,
        durationSeconds: durationSeconds,
      ));

  Future<void> deleteSession(String id) =>
      (delete(sessions)..where((s) => s.id.equals(id))).go();

  Future<int> totalSecondsForProject(String projectId) async {
    final rows = await (select(sessions)
          ..where((s) => s.projectId.equals(projectId) & s.endedAt.isNotNull()))
        .get();
    return rows.fold<int>(0, (sum, s) => sum + (s.durationSeconds ?? 0));
  }

  Future<List<Session>> getAllCompleted() =>
      (select(sessions)..where((s) => s.endedAt.isNotNull())).get();

  // For report: sessions in date range
  Future<List<Session>> getInRange(DateTime from, DateTime to) =>
      (select(sessions)
            ..where((s) => s.startedAt.isBiggerOrEqualValue(from) &
                s.startedAt.isSmallerThanValue(to)))
          .get();

  // Backward compatibility methods
  Stream<Session?> watchActiveSession() => watchLiveSession();
  Future<Session?> getActiveSession() => getLiveSession();
  Stream<List<Session>> watchSessionsForProject(String projectId) => watchForProject(projectId);
  Future<List<Session>> getSessionsForProject(String projectId) =>
      (select(sessions)
            ..where((s) => s.projectId.equals(projectId))
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)]))
          .get();

  Future<List<Session>> getRecentSessions(String projectId, {int days = 90}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.startedAt.isBiggerThanValue(cutoff))
          ..where((s) => s.endedAt.isNotNull())
          ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
        .get();
  }

  Future<int> getTotalSecondsLastWeek(String projectId) async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final result = await (select(sessions)
          ..where((s) => s.projectId.equals(projectId))
          ..where((s) => s.startedAt.isBiggerThanValue(cutoff))
          ..where((s) => s.endedAt.isNotNull()))
        .get();
    return result.fold<int>(0, (sum, s) => sum + (s.durationSeconds ?? 0));
  }

  Future<int> getTotalSecondsForProject(String projectId) => totalSecondsForProject(projectId);

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
