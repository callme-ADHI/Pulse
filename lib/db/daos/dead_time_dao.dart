import 'package:drift/drift.dart';
import '../database.dart';

class DeadTimeDao {
  DeadTimeDao(this._db);
  final PulseDatabase _db;

  Stream<List<DeadTime>> watchDeadTimesForProject(String projectId) {
    return (_db.select(_db.deadTimes)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.fromDate)]))
        .watch();
  }

  Future<List<DeadTime>> getDeadTimesForProject(String projectId) {
    return (_db.select(_db.deadTimes)
          ..where((t) => t.projectId.equals(projectId)))
        .get();
  }

  Future<void> insertDeadTime(DeadTimesCompanion dt) async {
    await _db.into(_db.deadTimes).insert(dt);
  }

  Future<void> deleteDeadTime(String id) async {
    await (_db.delete(_db.deadTimes)..where((t) => t.id.equals(id))).go();
  }
}
