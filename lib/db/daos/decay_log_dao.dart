import 'package:drift/drift.dart';
import '../database.dart';

part 'decay_log_dao.g.dart';

@DriftAccessor(tables: [DecayLogs])
class DecayLogDao extends DatabaseAccessor<PulseDatabase>
    with _$DecayLogDaoMixin {
  DecayLogDao(super.db);

  /// Last 30 days for the project detail chart.
  Future<List<DecayLog>> getLast30Days(String projectId) {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return (select(decayLogs)
          ..where((d) => d.projectId.equals(projectId))
          ..where((d) => d.date.isBiggerThanValue(cutoff))
          ..orderBy([(d) => OrderingTerm.asc(d.date)]))
        .get();
  }

  Stream<List<DecayLog>> watchLast30Days(String projectId) {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return (select(decayLogs)
          ..where((d) => d.projectId.equals(projectId))
          ..where((d) => d.date.isBiggerThanValue(cutoff))
          ..orderBy([(d) => OrderingTerm.asc(d.date)]))
        .watch();
  }

  /// Latest decay log per project (for the graph node color).
  Future<DecayLog?> getLatestForProject(String projectId) {
    return (select(decayLogs)
          ..where((d) => d.projectId.equals(projectId))
          ..orderBy([(d) => OrderingTerm.desc(d.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> insertLog(DecayLogsCompanion companion) {
    return into(decayLogs).insert(companion, mode: InsertMode.insertOrReplace);
  }

  /// Week-over-week delta: biggest score mover, for weekly report.
  Future<Map<String, double>> getWeekDeltaByProject() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));

    final thisWeek = await (select(decayLogs)
          ..where((d) => d.date.isBiggerThanValue(weekAgo)))
        .get();
    final prevWeek = await (select(decayLogs)
          ..where((d) => d.date.isBiggerThanValue(twoWeeksAgo))
          ..where((d) => d.date.isSmallerThanValue(weekAgo)))
        .get();

    final Map<String, double> thisMap = {};
    for (final log in thisWeek) {
      thisMap[log.projectId] = log.score;
    }
    final Map<String, double> prevMap = {};
    for (final log in prevWeek) {
      prevMap[log.projectId] = log.score;
    }

    final Map<String, double> deltas = {};
    for (final id in thisMap.keys) {
      if (prevMap.containsKey(id)) {
        deltas[id] = thisMap[id]! - prevMap[id]!;
      }
    }
    return deltas;
  }
}
