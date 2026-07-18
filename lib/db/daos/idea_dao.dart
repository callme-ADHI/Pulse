import 'package:drift/drift.dart';
import '../database.dart';

part 'idea_dao.g.dart';

@DriftAccessor(tables: [Ideas, Projects])
class IdeaDao extends DatabaseAccessor<PulseDatabase> with _$IdeaDaoMixin {
  IdeaDao(super.db);

  // ── Queries ───────────────────────────────────────────────────────────────

  /// Inbox: unsorted ideas, newest first.
  Stream<List<Idea>> watchInboxIdeas() {
    return (select(ideas)
          ..where((i) => i.status.equals('unsorted'))
          ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]))
        .watch();
  }

  /// Ideas linked to a project.
  Stream<List<Idea>> watchIdeasForProject(String projectId) {
    return (select(ideas)
          ..where((i) => i.projectId.equals(projectId))
          ..where((i) => i.status.isNotIn(['archived']))
          ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]))
        .watch();
  }

  Future<List<Idea>> getIdeasBySourceImport(String importId) {
    return (select(ideas)
          ..where((i) => i.sourceImportId.equals(importId)))
        .get();
  }

  Future<Idea?> getIdeaById(String id) {
    return (select(ideas)..where((i) => i.id.equals(id))).getSingleOrNull();
  }

  Stream<Idea?> watchIdeaById(String id) {
    return (select(ideas)..where((i) => i.id.equals(id))).watchSingleOrNull();
  }

  /// Ideas that have at least one relation — shown on the graph.
  Future<List<Idea>> getIdeasWithRelations(List<String> ideaIds) {
    if (ideaIds.isEmpty) return Future.value([]);
    return (select(ideas)..where((i) => i.id.isIn(ideaIds))).get();
  }

  Future<List<Idea>> getAllUnsorted() {
    return (select(ideas)..where((i) => i.status.equals('unsorted'))).get();
  }

  Future<List<Idea>> getAll() {
    return select(ideas).get();
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<void> insertIdea(IdeasCompanion companion) {
    return into(ideas).insert(companion);
  }

  Future<void> linkIdeaToProject(String ideaId, String projectId) {
    return (update(ideas)..where((i) => i.id.equals(ideaId))).write(
      IdeasCompanion(
        projectId: Value(projectId),
        status: const Value('linked'),
      ),
    );
  }

  Future<void> promoteIdea(String ideaId, String newProjectId) {
    return (update(ideas)..where((i) => i.id.equals(ideaId))).write(
      IdeasCompanion(
        status: const Value('promoted'),
        promotedToProjectId: Value(newProjectId),
      ),
    );
  }

  Future<void> archiveIdea(String ideaId) {
    return (update(ideas)..where((i) => i.id.equals(ideaId))).write(
      const IdeasCompanion(status: Value('archived')),
    );
  }

  Future<void> updateIdea(IdeasCompanion companion) {
    return (update(ideas)..where((i) => i.id.equals(companion.id.value)))
        .write(companion);
  }

  Future<void> deleteIdea(String id) {
    return (delete(ideas)..where((i) => i.id.equals(id))).go();
  }

  Stream<List<Idea>> watchAll() {
    return select(ideas).watch();
  }
}
