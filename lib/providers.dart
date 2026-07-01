import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'db/database.dart';
import 'db/daos/project_dao.dart';
import 'db/daos/session_dao.dart';
import 'db/daos/idea_dao.dart';
import 'db/daos/phase_dao.dart';
import 'db/daos/learning_dao.dart';
import 'db/daos/dead_time_dao.dart';
import 'db/daos/pause_log_dao.dart';
import 'db/daos/relation_dao.dart';
import 'db/daos/yaml_import_dao.dart';
import 'db/daos/decay_log_dao.dart';

// ── Database singleton ────────────────────────────────────────────────────────

final databaseProvider = Provider<PulseDatabase>((ref) {
  final db = PulseDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── DAOs ──────────────────────────────────────────────────────────────────────

final projectDaoProvider = Provider<ProjectDao>(
  (ref) => ProjectDao(ref.watch(databaseProvider)),
);
final sessionDaoProvider = Provider<SessionDao>(
  (ref) => SessionDao(ref.watch(databaseProvider)),
);
final ideaDaoProvider = Provider<IdeaDao>(
  (ref) => IdeaDao(ref.watch(databaseProvider)),
);
final phaseDaoProvider = Provider<PhaseDao>(
  (ref) => PhaseDao(ref.watch(databaseProvider)),
);
final learningDaoProvider = Provider<LearningDao>(
  (ref) => LearningDao(ref.watch(databaseProvider)),
);
final deadTimeDaoProvider = Provider<DeadTimeDao>(
  (ref) => DeadTimeDao(ref.watch(databaseProvider)),
);
final pauseLogDaoProvider = Provider<PauseLogDao>(
  (ref) => PauseLogDao(ref.watch(databaseProvider)),
);
final relationDaoProvider = Provider<RelationDao>(
  (ref) => RelationDao(ref.watch(databaseProvider)),
);
final yamlImportDaoProvider = Provider<YamlImportDao>(
  (ref) => YamlImportDao(ref.watch(databaseProvider)),
);
final decayLogDaoProvider = Provider<DecayLogDao>(
  (ref) => DecayLogDao(ref.watch(databaseProvider)),
);

// ── Global streams ────────────────────────────────────────────────────────────

final homeProjectsProvider = StreamProvider<List<Project>>((ref) {
  return ref.watch(projectDaoProvider).watchHomeProjects();
});

final activeSessionProvider = StreamProvider<Session?>((ref) {
  return ref.watch(sessionDaoProvider).watchActiveSession();
});

final inboxIdeasProvider = StreamProvider<List<Idea>>((ref) {
  return ref.watch(ideaDaoProvider).watchInboxIdeas();
});

final allRelationsProvider = StreamProvider<List<Relation>>((ref) {
  return ref.watch(relationDaoProvider).watchAllRelations();
});

final yamlImportHistoryProvider = StreamProvider<List<YamlImport>>((ref) {
  return ref.watch(yamlImportDaoProvider).watchAllImports();
});

// ── Per-project family providers ──────────────────────────────────────────────

final projectByIdProvider = StreamProvider.family<Project?, String>((ref, id) {
  return ref.watch(projectDaoProvider).watchProjectById(id);
});

final projectSessionsProvider =
    StreamProvider.family<List<Session>, String>((ref, projectId) {
  return ref.watch(sessionDaoProvider).watchSessionsForProject(projectId);
});

final projectIdeasProvider =
    StreamProvider.family<List<Idea>, String>((ref, projectId) {
  return ref.watch(ideaDaoProvider).watchIdeasForProject(projectId);
});

final projectPhasesProvider =
    StreamProvider.family<List<ExecutionPhase>, String>((ref, projectId) {
  return ref.watch(phaseDaoProvider).watchPhasesForProject(projectId);
});

final projectLearningGoalsProvider =
    StreamProvider.family<List<LearningGoal>, String>((ref, projectId) {
  return ref.watch(learningDaoProvider).watchGoalsForProject(projectId);
});

final projectDeadTimesProvider =
    StreamProvider.family<List<DeadTime>, String>((ref, projectId) {
  return ref.watch(deadTimeDaoProvider).watchDeadTimesForProject(projectId);
});

final projectPauseLogsProvider =
    StreamProvider.family<List<PauseLog>, String>((ref, projectId) {
  return ref.watch(pauseLogDaoProvider).watchLogsForProject(projectId);
});

final projectRelationsProvider =
    StreamProvider.family<List<Relation>, String>((ref, projectId) {
  return ref.watch(relationDaoProvider).watchRelationsForProject(projectId);
});

final decayLogsProvider =
    StreamProvider.family<List<DecayLog>, String>((ref, projectId) {
  return ref.watch(decayLogDaoProvider).watchLast30Days(projectId);
});
