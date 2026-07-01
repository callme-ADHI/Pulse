import 'package:drift/drift.dart';
import '../database.dart';

class PhaseDao {
  PhaseDao(this._db);
  final PulseDatabase _db;

  // ── Streams ───────────────────────────────────────────────────────────────

  Stream<List<ExecutionPhase>> watchPhasesForProject(String projectId) {
    return (_db.select(_db.executionPhases)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .watch();
  }

  // ── Reads ─────────────────────────────────────────────────────────────────

  Future<List<ExecutionPhase>> getPhasesForProject(String projectId) {
    return (_db.select(_db.executionPhases)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  // ── Writes ────────────────────────────────────────────────────────────────

  Future<void> insertPhase(ExecutionPhasesCompanion phase) async {
    await _db.into(_db.executionPhases).insert(phase);
  }

  Future<void> updatePhase(ExecutionPhasesCompanion phase) async {
    await (_db.update(_db.executionPhases)
          ..where((t) => t.id.equals(phase.id.value)))
        .write(phase);
  }

  Future<void> updateStatus(String id, String status, {DateTime? doneAt}) async {
    await (_db.update(_db.executionPhases)..where((t) => t.id.equals(id))).write(
      ExecutionPhasesCompanion(
        status: Value(status),
        doneAt: Value(doneAt),
        startedAt: status == 'in_progress' ? Value(DateTime.now()) : const Value.absent(),
      ),
    );
  }

  Future<void> reorderPhases(List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.executionPhases)
              ..where((t) => t.id.equals(orderedIds[i])))
            .write(ExecutionPhasesCompanion(order: Value(i)));
      }
    });
  }

  Future<void> deletePhase(String id) async {
    await (_db.delete(_db.executionPhases)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deletePhasesForImport(String importId) async {
    await (_db.delete(_db.executionPhases)
          ..where((t) => t.sourceImportId.equals(importId)))
        .go();
  }
}
