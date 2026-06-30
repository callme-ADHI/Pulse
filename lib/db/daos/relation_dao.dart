import 'package:drift/drift.dart';
import '../database.dart';

part 'relation_dao.g.dart';

@DriftAccessor(tables: [Relations])
class RelationDao extends DatabaseAccessor<PulseDatabase>
    with _$RelationDaoMixin {
  RelationDao(super.db);

  // ── Queries ───────────────────────────────────────────────────────────────

  Stream<List<Relation>> watchRelationsForProject(String projectId) {
    return (select(relations)
          ..where(
            (r) =>
                (r.fromId.equals(projectId) & r.fromType.equals('project')) |
                (r.toId.equals(projectId) & r.toType.equals('project')),
          ))
        .watch();
  }

  Future<List<Relation>> getRelationsForProject(String projectId) {
    return (select(relations)
          ..where(
            (r) =>
                (r.fromId.equals(projectId) & r.fromType.equals('project')) |
                (r.toId.equals(projectId) & r.toType.equals('project')),
          ))
        .get();
  }

  /// All relations for graph rendering.
  Stream<List<Relation>> watchAllRelations() {
    return select(relations).watch();
  }

  Future<List<Relation>> getAllRelations() {
    return select(relations).get();
  }

  Future<List<Relation>> getRelationsBySourceImport(String importId) {
    return (select(relations)
          ..where((r) => r.sourceImportId.equals(importId)))
        .get();
  }

  Future<Relation?> getRelationById(String id) {
    return (select(relations)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  /// Check if two nodes are already related (to prevent duplicates).
  Future<bool> relationExists(
    String fromId,
    String toId,
    String type,
  ) async {
    final result = await (select(relations)
          ..where((r) => r.fromId.equals(fromId))
          ..where((r) => r.toId.equals(toId))
          ..where((r) => r.relationType.equals(type))
          ..limit(1))
        .getSingleOrNull();
    return result != null;
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<void> insertRelation(RelationsCompanion companion) {
    return into(relations).insert(companion);
  }

  Future<void> deleteRelation(String id) {
    return (delete(relations)..where((r) => r.id.equals(id))).go();
  }

  Future<void> softDeleteRelationsBySourceImport(String importId) async {
    // Relations are hard-deleted on revert since they have no isDeleted flag.
    // This is intentional — only Projects/Ideas get soft-deleted.
    await (delete(relations)
          ..where((r) => r.sourceImportId.equals(importId)))
        .go();
  }

  Future<void> updateRelation(RelationsCompanion companion) {
    return (update(relations)..where((r) => r.id.equals(companion.id.value)))
        .write(companion);
  }
}
