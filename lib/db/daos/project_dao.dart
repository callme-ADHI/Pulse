import 'package:drift/drift.dart';
import '../database.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectDao extends DatabaseAccessor<PulseDatabase>
    with _$ProjectDaoMixin {
  ProjectDao(super.db);

  // ── Queries ───────────────────────────────────────────────────────────────

  /// All active (non-deleted) projects, ordered by status severity then name.
  Stream<List<Project>> watchActiveProjects() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where(
            (p) => p.status.isIn(['active', 'paused', 'completed']),
          )
          ..orderBy([
            (p) => OrderingTerm.asc(p.name),
          ]))
        .watch();
  }

  /// Projects for the home list — excludes archived and deleted.
  Stream<List<Project>> watchHomeProjects() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.status.isNotIn(['archived'])))
        .watch();
  }

  Future<Project?> getProjectById(String id) {
    return (select(projects)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  Stream<Project?> watchProjectById(String id) {
    return (select(projects)..where((p) => p.id.equals(id))).watchSingleOrNull();
  }

  Future<List<Project>> getAllActiveProjectsList() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.status.isNotIn(['archived'])))
        .get();
  }

  Future<List<Project>> getProjectsBySourceImport(String importId) {
    return (select(projects)
          ..where((p) => p.sourceImportId.equals(importId)))
        .get();
  }

  // (getProjectsForDecayJob is defined at the bottom of this file — active-only)

  // ── Mutations ─────────────────────────────────────────────────────────────

  Future<void> insertProject(ProjectsCompanion companion) {
    return into(projects).insert(companion);
  }

  Future<void> updateProject(ProjectsCompanion companion) {
    return (update(projects)..where((p) => p.id.equals(companion.id.value)))
        .write(companion);
  }

  /// Soft-delete a project.
  Future<void> softDeleteProject(String id) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Hard-delete projects soft-deleted > 30 days ago.
  Future<void> hardDeleteExpired() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    await (delete(projects)
          ..where((p) => p.isDeleted.equals(true))
          ..where((p) => p.deletedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  Future<void> updateLastSessionAt(String id, DateTime time) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(lastSessionAt: Value(time)),
    );
  }

  Future<void> updateAvgGapDays(String id, double newAvg) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(avgGapDays: Value(newAvg)),
    );
  }

  Future<void> updateLastNote(String id, String note) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(lastNote: Value(note)),
    );
  }

  Future<void> updateStatus(String id, String status) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(status: Value(status)),
    );
  }

  Future<void> updateWeight(String id, double weight) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(weight: Value(weight)),
    );
  }

  Future<void> updateEstimatedMinutes(String id, int? minutes) {
    return (update(projects)..where((p) => p.id.equals(id))).write(
      ProjectsCompanion(estimatedMinutes: Value(minutes)),
    );
  }

  /// Projects that need decay recompute — active only (not paused, completed, archived).
  Future<List<Project>> getProjectsForDecayJob() {
    return (select(projects)
          ..where((p) => p.isDeleted.equals(false))
          ..where((p) => p.status.equals('active')))
        .get();
  }
}
