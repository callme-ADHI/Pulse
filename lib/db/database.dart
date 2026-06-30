// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// Tables
part 'database.g.dart';

// ── Table Definitions ─────────────────────────────────────────────────────────

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get priority => text().withDefault(const Constant('medium'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastSessionAt => dateTime().nullable()();
  RealColumn get avgGapDays => real().withDefault(const Constant(3.0))();
  TextColumn get lastNote => text().nullable()();
  TextColumn get sourceImportId => text().nullable()();
  TextColumn get colorSeed => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Sessions extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  TextColumn get tag => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Ideas extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  TextColumn get projectId =>
      text().nullable().references(Projects, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text().withDefault(const Constant('unsorted'))();
  TextColumn get promotedToProjectId =>
      text().nullable().references(Projects, #id, onDelete: KeyAction.setNull)();
  TextColumn get sourceImportId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Relations extends Table {
  TextColumn get id => text()();
  TextColumn get fromId => text()();
  TextColumn get fromType => text()();
  TextColumn get toId => text()();
  TextColumn get toType => text()();
  TextColumn get relationType => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get sourceImportId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class YamlImports extends Table {
  TextColumn get id => text()();
  TextColumn get rawYaml => text()();
  TextColumn get summary => text()();
  TextColumn get parseWarnings => text().nullable()();
  DateTimeColumn get importedAt => dateTime()();
  BoolColumn get isReverted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class DecayLogs extends Table {
  TextColumn get id => text()();
  TextColumn get projectId =>
      text().references(Projects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  RealColumn get score => real()();
  TextColumn get zone => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class NotificationLog extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().nullable()();
  DateTimeColumn get sentAt => dateTime()();
  TextColumn get type => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [
    Projects,
    Sessions,
    Ideas,
    Relations,
    YamlImports,
    DecayLogs,
    NotificationLog,
  ],
)
class PulseDatabase extends _$PulseDatabase {
  PulseDatabase() : super(_openConnection());
  PulseDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Indexes for performance
        await customStatement(
          'CREATE INDEX idx_sessions_project ON sessions(project_id)',
        );
        await customStatement(
          'CREATE INDEX idx_ideas_project ON ideas(project_id)',
        );
        await customStatement(
          'CREATE INDEX idx_relations_from ON relations(from_id, from_type)',
        );
        await customStatement(
          'CREATE INDEX idx_relations_to ON relations(to_id, to_type)',
        );
        await customStatement(
          'CREATE INDEX idx_decay_logs_project_date ON decay_logs(project_id, date)',
        );
        await customStatement(
          'CREATE INDEX idx_notification_log_project_sent ON notification_log(project_id, sent_at)',
        );
        await customStatement(
          'CREATE INDEX idx_projects_source_import ON projects(source_import_id)',
        );
        await customStatement(
          'CREATE INDEX idx_relations_source_import ON relations(source_import_id)',
        );
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pulse.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
