import 'package:drift/drift.dart';
import '../database.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectDao extends DatabaseAccessor<PulseDatabase>
    with _$ProjectDaoMixin {
  ProjectDao(super.db);

  // ── Queries ───────────────────────────────────────────────────────────────

  /// Active + paused only (Home screen)
  Stream<List<Project>> watchActiveAndPaused() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false) & p.status.isIn(['active', 'paused']))
          ..orderBy([(p) => OrderingTerm.desc(p.lastSessionAt)]))
        .watch();
  }

  /// All non-deleted (for Map)
  Stream<List<Project>> watchAllLive() {
    return (select(projects)..where((p) => p.isDeleted.equals(false))).watch();
  }

  /// Archived + dropped + completed (for Archive screen)
  Stream<List<Project>> watchArchivedAndDropped() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false) & p.status.isIn(['archived', 'dropped', 'completed'])))
        .watch();
  }

  Stream<Project?> watchById(String id) {
    return (select(projects)..where((p) => p.id.equals(id))).watchSingleOrNull();
  }

  Future<Project?> getById(String id) {
    return (select(projects)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  /// Keep for backward compatibility
  Stream<Project?> watchProjectById(String id) => watchById(id);
  Future<Project?> getProjectById(String id) => getById(id);

  /// Projects for the home list — excludes archived and deleted.
  Stream<List<Project>> watchHomeProjects() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.status.isNotIn(['archived', 'dropped', 'completed'])))
        .watch();
  }

  Future<List<Project>> getAllActiveProjectsList() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.status.isNotIn(['archived', 'dropped', 'completed'])))
        .get();
  }

  Future<List<Project>> getProjectsBySourceImport(String importId) {
    return (select(projects)
          ..where((p) => p.sourceImportId.equals(importId)))
        .get();
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<void> upsert(ProjectsCompanion c) {
    return into(projects).insertOnConflictUpdate(c);
  }

  Future<void> insertProject(ProjectsCompanion companion) {
    return into(projects).insert(companion);
  }

  Future<void> updateProject(ProjectsCompanion companion) {
    return (update(projects)..where((p) => p.id.equals(companion.id.value)))
        .write(companion);
  }

  Future<void> updateStatus(String id, String status) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(status: Value(status)));
  }

  Future<void> dropProject(String id, String reason) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(
      status: const Value('dropped'),
      dropReason: Value(reason),
      droppedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateAvgGap(String id, double avgGap) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(avgGapDays: Value(avgGap)));
  }

  Future<void> updateAvgGapDays(String id, double avgGap) => updateAvgGap(id, avgGap);

  Future<void> updateLastSession(String id, DateTime dt, String? note) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(
      lastSessionAt: Value(dt),
      lastNote: Value(note),
    ));
  }

  Future<void> updateLastSessionAt(String id, DateTime dt) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(lastSessionAt: Value(dt)));
  }

  Future<void> updateLastNote(String id, String note) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(lastNote: Value(note)));
  }

  Future<void> softDelete(String id) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(ProjectsCompanion(
      isDeleted: const Value(true),
      deletedAt: Value(DateTime.now()),
    ));
  }

  Future<void> softDeleteProject(String id) => softDelete(id);

  Future<void> restore(String id) {
    return (update(projects)..where((p) => p.id.equals(id)))
        .write(const ProjectsCompanion(status: Value('active')));
  }

  Future<void> purgeOldDeleted() {
    return (delete(projects)
          ..where((p) => p.isDeleted.equals(true) &
              p.deletedAt.isSmallerThanValue(
                DateTime.now().subtract(const Duration(days: 30)),
              )))
        .go();
  }

  Future<void> hardDeleteExpired() => purgeOldDeleted();

  Future<List<Project>> getAll() => select(projects).get();

  Future<List<Project>> getProjectsForDecayJob() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.status.equals('active')))
        .get();
  }
}
