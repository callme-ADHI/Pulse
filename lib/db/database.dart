import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tables
// ─────────────────────────────────────────────────────────────────────────────

class Projects extends Table {
  TextColumn     get id               => text()();
  TextColumn     get name             => text()();
  TextColumn     get description      => text().nullable()();
  RealColumn     get weight           => real().withDefault(const Constant(1.0))(); // 0.1–5.0
  TextColumn     get status           => text().withDefault(const Constant('active'))(); // active|paused|completed|archived|dropped
  DateTimeColumn get createdAt        => dateTime()();
  DateTimeColumn get lastSessionAt    => dateTime().nullable()();
  RealColumn     get avgGapDays       => real().withDefault(const Constant(3.0))();
  TextColumn     get lastNote         => text().nullable()(); // "where I left off"
  IntColumn      get estimatedMinutes => integer().nullable()(); // user's estimate
  TextColumn     get colorSeed        => text().nullable()();
  TextColumn     get sourceImportId   => text().nullable()();
  BoolColumn     get isDeleted        => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt        => dateTime().nullable()();
  TextColumn     get dropReason       => text().nullable()(); // why the project was dropped/cancelled
  DateTimeColumn get droppedAt        => dateTime().nullable()(); // when it was dropped
  DateTimeColumn get startDate        => dateTime().nullable()(); // optional project start date
  DateTimeColumn get endDate          => dateTime().nullable()(); // optional project deadline

  @override
  Set<Column> get primaryKey => {id};
}

class Sessions extends Table {
  TextColumn     get id              => text()();
  TextColumn     get projectId       => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt       => dateTime()();
  DateTimeColumn get endedAt         => dateTime().nullable()();
  IntColumn      get durationSeconds => integer().nullable()();
  TextColumn     get tag             => text().nullable()(); // code|read|plan|design|research
  TextColumn     get stopReason      => text().nullable()(); // completed_goal|got_blocked|ran_out_of_time|lost_focus|external_interrupt|other
  TextColumn     get stopNote        => text().nullable()(); // free-text note on stop
  TextColumn     get nextStep        => text().nullable()(); // "where I'm picking up next time"

  @override
  Set<Column> get primaryKey => {id};
}

class Ideas extends Table {
  TextColumn     get id                  => text()();
  TextColumn     get content             => text()();
  TextColumn     get description         => text().nullable()(); // a few lines of context
  TextColumn     get projectId           => text().nullable().references(Projects, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt           => dateTime()();
  TextColumn     get status              => text().withDefault(const Constant('unsorted'))(); // unsorted|linked|promoted|archived
  TextColumn     get promotedToProjectId => text().nullable().references(Projects, #id, onDelete: KeyAction.setNull)();
  TextColumn     get sourceImportId      => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Phases are NOT tasks. No checkboxes, no due dates.
/// They are high-level structural milestones describing the project's plan.
class ExecutionPhases extends Table {
  TextColumn     get id             => text()();
  TextColumn     get projectId      => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  IntColumn      get order          => integer()(); // drag-reorderable
  TextColumn     get name           => text()();
  TextColumn     get summary        => text().nullable()();
  TextColumn     get status         => text().withDefault(const Constant('upcoming'))(); // upcoming|in_progress|done|delayed
  DateTimeColumn get startedAt      => dateTime().nullable()();
  DateTimeColumn get doneAt         => dateTime().nullable()();
  DateTimeColumn get deadline       => dateTime().nullable()(); // optional due date
  TextColumn     get sourceImportId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Skills and concepts to learn FROM this project.
class LearningGoals extends Table {
  TextColumn     get id             => text()();
  TextColumn     get projectId      => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn     get topic          => text()();
  TextColumn     get description    => text().nullable()();
  BoolColumn     get isDone         => boolean().withDefault(const Constant(false))();
  DateTimeColumn get doneAt         => dateTime().nullable()();
  TextColumn     get sourceImportId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Optional periods where no work happened — subtracted from decay gap calculation.
class DeadTimes extends Table {
  TextColumn     get id        => text()();
  TextColumn     get projectId => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get fromDate  => dateTime()();
  DateTimeColumn get toDate    => dateTime()();
  TextColumn     get reason    => text().nullable()(); // sick|blocked|holiday|other
  TextColumn     get note      => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Every pause/resume/complete event is recorded for analysis.
class PauseLogs extends Table {
  TextColumn     get id               => text()();
  TextColumn     get projectId        => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn     get action           => text()(); // paused|resumed|completed
  DateTimeColumn get timestamp        => dateTime()();
  TextColumn     get reason           => text().nullable()();
  IntColumn      get plannedPauseDays => integer().nullable()(); // user's estimate when pausing

  @override
  Set<Column> get primaryKey => {id};
}

class Relations extends Table {
  TextColumn     get id           => text()();
  TextColumn     get fromId       => text()();
  TextColumn     get fromType     => text()(); // project|idea
  TextColumn     get toId         => text()();
  TextColumn     get toType       => text()();
  TextColumn     get relationType => text()(); // depends_on|blocks|inspired_by|part_of|related_to
  TextColumn     get note         => text().nullable()();
  DateTimeColumn get createdAt    => dateTime()();
  TextColumn     get sourceImportId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class YamlImports extends Table {
  TextColumn     get id            => text()();
  TextColumn     get rawYaml       => text()();
  TextColumn     get summary       => text()();
  TextColumn     get parseWarnings => text().nullable()();
  DateTimeColumn get importedAt    => dateTime()();
  BoolColumn     get isReverted    => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class DecayLogs extends Table {
  TextColumn     get id        => text()();
  TextColumn     get projectId => text().references(Projects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date      => dateTime()();
  RealColumn     get score     => real()();
  TextColumn     get zone      => text()(); // active|drifting|cold|critical

  @override
  Set<Column> get primaryKey => {id};
}

class NotificationLog extends Table {
  TextColumn     get id        => text()();
  TextColumn     get projectId => text().nullable()();
  DateTimeColumn get sentAt    => dateTime()();
  TextColumn     get type      => text()(); // nudge|cold_alert|weekly_digest

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────────────────────────────────────────
// Database
// ─────────────────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  Projects, Sessions, Ideas,
  ExecutionPhases, LearningGoals, DeadTimes, PauseLogs,
  Relations, YamlImports, DecayLogs, NotificationLog,
])
class PulseDatabase extends _$PulseDatabase {
  PulseDatabase() : super(_openConnection());
  PulseDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _createIndexes();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // v1 → v2: add 4 new tables + new columns on existing tables
          await m.createTable(executionPhases);
          await m.createTable(learningGoals);
          await m.createTable(deadTimes);
          await m.createTable(pauseLogs);

          // New columns on Projects
          await m.addColumn(projects, projects.weight);
          await m.addColumn(projects, projects.estimatedMinutes);
          // status column existed in v1 — skip if already present (no-op via try)

          // New columns on Sessions
          await m.addColumn(sessions, sessions.stopReason);
          await m.addColumn(sessions, sessions.stopNote);
          await m.addColumn(sessions, sessions.nextStep);

          // New column on Ideas
          await m.addColumn(ideas, ideas.description);

          await _createIndexes();
        }
        if (from < 3) {
          await m.addColumn(projects, projects.dropReason);
          await m.addColumn(projects, projects.droppedAt);
        }
        if (from < 4) {
          await m.addColumn(projects, projects.startDate);
          await m.addColumn(projects, projects.endDate);
        }
        if (from < 5) {
          // v4 → v5: add deadline column to execution_phases
          await m.addColumn(executionPhases, executionPhases.deadline);
        }
      },
    );
  }

  Future<void> _createIndexes() async {
    final stmts = [
      'CREATE INDEX IF NOT EXISTS idx_sessions_project ON sessions(project_id)',
      'CREATE INDEX IF NOT EXISTS idx_ideas_project ON ideas(project_id)',
      'CREATE INDEX IF NOT EXISTS idx_phases_project_order ON execution_phases(project_id, "order")',
      'CREATE INDEX IF NOT EXISTS idx_learning_project ON learning_goals(project_id)',
      'CREATE INDEX IF NOT EXISTS idx_dead_times_project ON dead_times(project_id)',
      'CREATE INDEX IF NOT EXISTS idx_pause_logs_project ON pause_logs(project_id)',
      'CREATE INDEX IF NOT EXISTS idx_relations_from ON relations(from_id, from_type)',
      'CREATE INDEX IF NOT EXISTS idx_relations_to ON relations(to_id, to_type)',
      'CREATE INDEX IF NOT EXISTS idx_decay_project_date ON decay_logs(project_id, date)',
      'CREATE INDEX IF NOT EXISTS idx_notif_project_sent ON notification_log(project_id, sent_at)',
      'CREATE INDEX IF NOT EXISTS idx_projects_import ON projects(source_import_id)',
    ];
    for (final s in stmts) await customStatement(s);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pulse.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
