import 'package:drift/drift.dart';
import '../database.dart';

class LearningDao {
  LearningDao(this._db);
  final PulseDatabase _db;

  Stream<List<LearningGoal>> watchGoalsForProject(String projectId) {
    return (_db.select(_db.learningGoals)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.isDone), (t) => OrderingTerm.asc(t.rowId)]))
        .watch();
  }

  Future<List<LearningGoal>> getGoalsForProject(String projectId) {
    return (_db.select(_db.learningGoals)
          ..where((t) => t.projectId.equals(projectId)))
        .get();
  }

  Future<void> insertGoal(LearningGoalsCompanion goal) async {
    await _db.into(_db.learningGoals).insert(goal);
  }

  Future<void> markDone(String id, bool done) async {
    await (_db.update(_db.learningGoals)..where((t) => t.id.equals(id))).write(
      LearningGoalsCompanion(
        isDone: Value(done),
        doneAt: Value(done ? DateTime.now() : null),
      ),
    );
  }

  Future<void> deleteGoal(String id) async {
    await (_db.delete(_db.learningGoals)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteGoalsForImport(String importId) async {
    await (_db.delete(_db.learningGoals)
          ..where((t) => t.sourceImportId.equals(importId)))
        .go();
  }
}
