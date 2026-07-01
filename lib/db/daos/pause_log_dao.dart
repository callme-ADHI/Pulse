import 'package:drift/drift.dart';
import '../database.dart';

class PauseLogDao {
  PauseLogDao(this._db);
  final PulseDatabase _db;

  Stream<List<PauseLog>> watchLogsForProject(String projectId) {
    return (_db.select(_db.pauseLogs)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  Future<List<PauseLog>> getLogsForProject(String projectId) {
    return (_db.select(_db.pauseLogs)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<void> insertLog(PauseLogsCompanion log) async {
    await _db.into(_db.pauseLogs).insert(log);
  }

  /// Returns the latest pause entry if the project is currently paused
  /// (i.e., the most recent log is 'paused' not 'resumed'/'completed').
  Future<PauseLog?> getLatestPause(String projectId) async {
    final logs = await getLogsForProject(projectId);
    if (logs.isNotEmpty && logs.first.action == 'paused') return logs.first;
    return null;
  }
}
