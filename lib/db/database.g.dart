// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSessionAtMeta = const VerificationMeta(
    'lastSessionAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSessionAt =
      GeneratedColumn<DateTime>(
        'last_session_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _avgGapDaysMeta = const VerificationMeta(
    'avgGapDays',
  );
  @override
  late final GeneratedColumn<double> avgGapDays = GeneratedColumn<double>(
    'avg_gap_days',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(3.0),
  );
  static const VerificationMeta _lastNoteMeta = const VerificationMeta(
    'lastNote',
  );
  @override
  late final GeneratedColumn<String> lastNote = GeneratedColumn<String>(
    'last_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceImportIdMeta = const VerificationMeta(
    'sourceImportId',
  );
  @override
  late final GeneratedColumn<String> sourceImportId = GeneratedColumn<String>(
    'source_import_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorSeedMeta = const VerificationMeta(
    'colorSeed',
  );
  @override
  late final GeneratedColumn<String> colorSeed = GeneratedColumn<String>(
    'color_seed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    priority,
    status,
    createdAt,
    lastSessionAt,
    avgGapDays,
    lastNote,
    sourceImportId,
    colorSeed,
    isDeleted,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_session_at')) {
      context.handle(
        _lastSessionAtMeta,
        lastSessionAt.isAcceptableOrUnknown(
          data['last_session_at']!,
          _lastSessionAtMeta,
        ),
      );
    }
    if (data.containsKey('avg_gap_days')) {
      context.handle(
        _avgGapDaysMeta,
        avgGapDays.isAcceptableOrUnknown(
          data['avg_gap_days']!,
          _avgGapDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_note')) {
      context.handle(
        _lastNoteMeta,
        lastNote.isAcceptableOrUnknown(data['last_note']!, _lastNoteMeta),
      );
    }
    if (data.containsKey('source_import_id')) {
      context.handle(
        _sourceImportIdMeta,
        sourceImportId.isAcceptableOrUnknown(
          data['source_import_id']!,
          _sourceImportIdMeta,
        ),
      );
    }
    if (data.containsKey('color_seed')) {
      context.handle(
        _colorSeedMeta,
        colorSeed.isAcceptableOrUnknown(data['color_seed']!, _colorSeedMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastSessionAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_session_at'],
      ),
      avgGapDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_gap_days'],
      )!,
      lastNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_note'],
      ),
      sourceImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_import_id'],
      ),
      colorSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_seed'],
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String? description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime? lastSessionAt;
  final double avgGapDays;
  final String? lastNote;
  final String? sourceImportId;
  final String? colorSeed;
  final bool isDeleted;
  final DateTime? deletedAt;
  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.lastSessionAt,
    required this.avgGapDays,
    this.lastNote,
    this.sourceImportId,
    this.colorSeed,
    required this.isDeleted,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastSessionAt != null) {
      map['last_session_at'] = Variable<DateTime>(lastSessionAt);
    }
    map['avg_gap_days'] = Variable<double>(avgGapDays);
    if (!nullToAbsent || lastNote != null) {
      map['last_note'] = Variable<String>(lastNote);
    }
    if (!nullToAbsent || sourceImportId != null) {
      map['source_import_id'] = Variable<String>(sourceImportId);
    }
    if (!nullToAbsent || colorSeed != null) {
      map['color_seed'] = Variable<String>(colorSeed);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      priority: Value(priority),
      status: Value(status),
      createdAt: Value(createdAt),
      lastSessionAt: lastSessionAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSessionAt),
      avgGapDays: Value(avgGapDays),
      lastNote: lastNote == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNote),
      sourceImportId: sourceImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImportId),
      colorSeed: colorSeed == null && nullToAbsent
          ? const Value.absent()
          : Value(colorSeed),
      isDeleted: Value(isDeleted),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSessionAt: serializer.fromJson<DateTime?>(json['lastSessionAt']),
      avgGapDays: serializer.fromJson<double>(json['avgGapDays']),
      lastNote: serializer.fromJson<String?>(json['lastNote']),
      sourceImportId: serializer.fromJson<String?>(json['sourceImportId']),
      colorSeed: serializer.fromJson<String?>(json['colorSeed']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSessionAt': serializer.toJson<DateTime?>(lastSessionAt),
      'avgGapDays': serializer.toJson<double>(avgGapDays),
      'lastNote': serializer.toJson<String?>(lastNote),
      'sourceImportId': serializer.toJson<String?>(sourceImportId),
      'colorSeed': serializer.toJson<String?>(colorSeed),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? priority,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> lastSessionAt = const Value.absent(),
    double? avgGapDays,
    Value<String?> lastNote = const Value.absent(),
    Value<String?> sourceImportId = const Value.absent(),
    Value<String?> colorSeed = const Value.absent(),
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    lastSessionAt: lastSessionAt.present
        ? lastSessionAt.value
        : this.lastSessionAt,
    avgGapDays: avgGapDays ?? this.avgGapDays,
    lastNote: lastNote.present ? lastNote.value : this.lastNote,
    sourceImportId: sourceImportId.present
        ? sourceImportId.value
        : this.sourceImportId,
    colorSeed: colorSeed.present ? colorSeed.value : this.colorSeed,
    isDeleted: isDeleted ?? this.isDeleted,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSessionAt: data.lastSessionAt.present
          ? data.lastSessionAt.value
          : this.lastSessionAt,
      avgGapDays: data.avgGapDays.present
          ? data.avgGapDays.value
          : this.avgGapDays,
      lastNote: data.lastNote.present ? data.lastNote.value : this.lastNote,
      sourceImportId: data.sourceImportId.present
          ? data.sourceImportId.value
          : this.sourceImportId,
      colorSeed: data.colorSeed.present ? data.colorSeed.value : this.colorSeed,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSessionAt: $lastSessionAt, ')
          ..write('avgGapDays: $avgGapDays, ')
          ..write('lastNote: $lastNote, ')
          ..write('sourceImportId: $sourceImportId, ')
          ..write('colorSeed: $colorSeed, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    priority,
    status,
    createdAt,
    lastSessionAt,
    avgGapDays,
    lastNote,
    sourceImportId,
    colorSeed,
    isDeleted,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.lastSessionAt == this.lastSessionAt &&
          other.avgGapDays == this.avgGapDays &&
          other.lastNote == this.lastNote &&
          other.sourceImportId == this.sourceImportId &&
          other.colorSeed == this.colorSeed &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> priority;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastSessionAt;
  final Value<double> avgGapDays;
  final Value<String?> lastNote;
  final Value<String?> sourceImportId;
  final Value<String?> colorSeed;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSessionAt = const Value.absent(),
    this.avgGapDays = const Value.absent(),
    this.lastNote = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.colorSeed = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.lastSessionAt = const Value.absent(),
    this.avgGapDays = const Value.absent(),
    this.lastNote = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.colorSeed = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSessionAt,
    Expression<double>? avgGapDays,
    Expression<String>? lastNote,
    Expression<String>? sourceImportId,
    Expression<String>? colorSeed,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSessionAt != null) 'last_session_at': lastSessionAt,
      if (avgGapDays != null) 'avg_gap_days': avgGapDays,
      if (lastNote != null) 'last_note': lastNote,
      if (sourceImportId != null) 'source_import_id': sourceImportId,
      if (colorSeed != null) 'color_seed': colorSeed,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? priority,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastSessionAt,
    Value<double>? avgGapDays,
    Value<String?>? lastNote,
    Value<String?>? sourceImportId,
    Value<String?>? colorSeed,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
      avgGapDays: avgGapDays ?? this.avgGapDays,
      lastNote: lastNote ?? this.lastNote,
      sourceImportId: sourceImportId ?? this.sourceImportId,
      colorSeed: colorSeed ?? this.colorSeed,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastSessionAt.present) {
      map['last_session_at'] = Variable<DateTime>(lastSessionAt.value);
    }
    if (avgGapDays.present) {
      map['avg_gap_days'] = Variable<double>(avgGapDays.value);
    }
    if (lastNote.present) {
      map['last_note'] = Variable<String>(lastNote.value);
    }
    if (sourceImportId.present) {
      map['source_import_id'] = Variable<String>(sourceImportId.value);
    }
    if (colorSeed.present) {
      map['color_seed'] = Variable<String>(colorSeed.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSessionAt: $lastSessionAt, ')
          ..write('avgGapDays: $avgGapDays, ')
          ..write('lastNote: $lastNote, ')
          ..write('sourceImportId: $sourceImportId, ')
          ..write('colorSeed: $colorSeed, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    startedAt,
    endedAt,
    durationSeconds,
    tag,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String projectId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final String? tag;
  const Session({
    required this.id,
    required this.projectId,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.tag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      tag: serializer.fromJson<String?>(json['tag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'tag': serializer.toJson<String?>(tag),
    };
  }

  Session copyWith({
    String? id,
    String? projectId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> tag = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    tag: tag.present ? tag.value : this.tag,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      tag: data.tag.present ? data.tag.value : this.tag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, startedAt, endedAt, durationSeconds, tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.tag == this.tag);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationSeconds;
  final Value<String?> tag;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String projectId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.tag = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       startedAt = Value(startedAt);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<String>? tag,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (tag != null) 'tag': tag,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? durationSeconds,
    Value<String?>? tag,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      tag: tag ?? this.tag,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('tag: $tag, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IdeasTable extends Ideas with TableInfo<$IdeasTable, Idea> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IdeasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unsorted'),
  );
  static const VerificationMeta _promotedToProjectIdMeta =
      const VerificationMeta('promotedToProjectId');
  @override
  late final GeneratedColumn<String> promotedToProjectId =
      GeneratedColumn<String>(
        'promoted_to_project_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _sourceImportIdMeta = const VerificationMeta(
    'sourceImportId',
  );
  @override
  late final GeneratedColumn<String> sourceImportId = GeneratedColumn<String>(
    'source_import_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    projectId,
    createdAt,
    status,
    promotedToProjectId,
    sourceImportId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ideas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Idea> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('promoted_to_project_id')) {
      context.handle(
        _promotedToProjectIdMeta,
        promotedToProjectId.isAcceptableOrUnknown(
          data['promoted_to_project_id']!,
          _promotedToProjectIdMeta,
        ),
      );
    }
    if (data.containsKey('source_import_id')) {
      context.handle(
        _sourceImportIdMeta,
        sourceImportId.isAcceptableOrUnknown(
          data['source_import_id']!,
          _sourceImportIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Idea map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Idea(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      promotedToProjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promoted_to_project_id'],
      ),
      sourceImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_import_id'],
      ),
    );
  }

  @override
  $IdeasTable createAlias(String alias) {
    return $IdeasTable(attachedDatabase, alias);
  }
}

class Idea extends DataClass implements Insertable<Idea> {
  final String id;
  final String content;
  final String? projectId;
  final DateTime createdAt;
  final String status;
  final String? promotedToProjectId;
  final String? sourceImportId;
  const Idea({
    required this.id,
    required this.content,
    this.projectId,
    required this.createdAt,
    required this.status,
    this.promotedToProjectId,
    this.sourceImportId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || promotedToProjectId != null) {
      map['promoted_to_project_id'] = Variable<String>(promotedToProjectId);
    }
    if (!nullToAbsent || sourceImportId != null) {
      map['source_import_id'] = Variable<String>(sourceImportId);
    }
    return map;
  }

  IdeasCompanion toCompanion(bool nullToAbsent) {
    return IdeasCompanion(
      id: Value(id),
      content: Value(content),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      createdAt: Value(createdAt),
      status: Value(status),
      promotedToProjectId: promotedToProjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(promotedToProjectId),
      sourceImportId: sourceImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImportId),
    );
  }

  factory Idea.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Idea(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      promotedToProjectId: serializer.fromJson<String?>(
        json['promotedToProjectId'],
      ),
      sourceImportId: serializer.fromJson<String?>(json['sourceImportId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'projectId': serializer.toJson<String?>(projectId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'promotedToProjectId': serializer.toJson<String?>(promotedToProjectId),
      'sourceImportId': serializer.toJson<String?>(sourceImportId),
    };
  }

  Idea copyWith({
    String? id,
    String? content,
    Value<String?> projectId = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<String?> promotedToProjectId = const Value.absent(),
    Value<String?> sourceImportId = const Value.absent(),
  }) => Idea(
    id: id ?? this.id,
    content: content ?? this.content,
    projectId: projectId.present ? projectId.value : this.projectId,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    promotedToProjectId: promotedToProjectId.present
        ? promotedToProjectId.value
        : this.promotedToProjectId,
    sourceImportId: sourceImportId.present
        ? sourceImportId.value
        : this.sourceImportId,
  );
  Idea copyWithCompanion(IdeasCompanion data) {
    return Idea(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      promotedToProjectId: data.promotedToProjectId.present
          ? data.promotedToProjectId.value
          : this.promotedToProjectId,
      sourceImportId: data.sourceImportId.present
          ? data.sourceImportId.value
          : this.sourceImportId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Idea(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('projectId: $projectId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('promotedToProjectId: $promotedToProjectId, ')
          ..write('sourceImportId: $sourceImportId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    projectId,
    createdAt,
    status,
    promotedToProjectId,
    sourceImportId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Idea &&
          other.id == this.id &&
          other.content == this.content &&
          other.projectId == this.projectId &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.promotedToProjectId == this.promotedToProjectId &&
          other.sourceImportId == this.sourceImportId);
}

class IdeasCompanion extends UpdateCompanion<Idea> {
  final Value<String> id;
  final Value<String> content;
  final Value<String?> projectId;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<String?> promotedToProjectId;
  final Value<String?> sourceImportId;
  final Value<int> rowid;
  const IdeasCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.projectId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.promotedToProjectId = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IdeasCompanion.insert({
    required String id,
    required String content,
    this.projectId = const Value.absent(),
    required DateTime createdAt,
    this.status = const Value.absent(),
    this.promotedToProjectId = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<Idea> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? projectId,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<String>? promotedToProjectId,
    Expression<String>? sourceImportId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (projectId != null) 'project_id': projectId,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (promotedToProjectId != null)
        'promoted_to_project_id': promotedToProjectId,
      if (sourceImportId != null) 'source_import_id': sourceImportId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IdeasCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String?>? projectId,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<String?>? promotedToProjectId,
    Value<String?>? sourceImportId,
    Value<int>? rowid,
  }) {
    return IdeasCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      promotedToProjectId: promotedToProjectId ?? this.promotedToProjectId,
      sourceImportId: sourceImportId ?? this.sourceImportId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (promotedToProjectId.present) {
      map['promoted_to_project_id'] = Variable<String>(
        promotedToProjectId.value,
      );
    }
    if (sourceImportId.present) {
      map['source_import_id'] = Variable<String>(sourceImportId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IdeasCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('projectId: $projectId, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('promotedToProjectId: $promotedToProjectId, ')
          ..write('sourceImportId: $sourceImportId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationsTable extends Relations
    with TableInfo<$RelationsTable, Relation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<String> fromId = GeneratedColumn<String>(
    'from_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromTypeMeta = const VerificationMeta(
    'fromType',
  );
  @override
  late final GeneratedColumn<String> fromType = GeneratedColumn<String>(
    'from_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<String> toId = GeneratedColumn<String>(
    'to_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toTypeMeta = const VerificationMeta('toType');
  @override
  late final GeneratedColumn<String> toType = GeneratedColumn<String>(
    'to_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationTypeMeta = const VerificationMeta(
    'relationType',
  );
  @override
  late final GeneratedColumn<String> relationType = GeneratedColumn<String>(
    'relation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceImportIdMeta = const VerificationMeta(
    'sourceImportId',
  );
  @override
  late final GeneratedColumn<String> sourceImportId = GeneratedColumn<String>(
    'source_import_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromId,
    fromType,
    toId,
    toType,
    relationType,
    note,
    createdAt,
    sourceImportId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Relation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(
        _fromIdMeta,
        fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fromIdMeta);
    }
    if (data.containsKey('from_type')) {
      context.handle(
        _fromTypeMeta,
        fromType.isAcceptableOrUnknown(data['from_type']!, _fromTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fromTypeMeta);
    }
    if (data.containsKey('to_id')) {
      context.handle(
        _toIdMeta,
        toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta),
      );
    } else if (isInserting) {
      context.missing(_toIdMeta);
    }
    if (data.containsKey('to_type')) {
      context.handle(
        _toTypeMeta,
        toType.isAcceptableOrUnknown(data['to_type']!, _toTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_toTypeMeta);
    }
    if (data.containsKey('relation_type')) {
      context.handle(
        _relationTypeMeta,
        relationType.isAcceptableOrUnknown(
          data['relation_type']!,
          _relationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relationTypeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('source_import_id')) {
      context.handle(
        _sourceImportIdMeta,
        sourceImportId.isAcceptableOrUnknown(
          data['source_import_id']!,
          _sourceImportIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Relation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Relation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_id'],
      )!,
      fromType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_type'],
      )!,
      toId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_id'],
      )!,
      toType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_type'],
      )!,
      relationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      sourceImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_import_id'],
      ),
    );
  }

  @override
  $RelationsTable createAlias(String alias) {
    return $RelationsTable(attachedDatabase, alias);
  }
}

class Relation extends DataClass implements Insertable<Relation> {
  final String id;
  final String fromId;
  final String fromType;
  final String toId;
  final String toType;
  final String relationType;
  final String? note;
  final DateTime createdAt;
  final String? sourceImportId;
  const Relation({
    required this.id,
    required this.fromId,
    required this.fromType,
    required this.toId,
    required this.toType,
    required this.relationType,
    this.note,
    required this.createdAt,
    this.sourceImportId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_id'] = Variable<String>(fromId);
    map['from_type'] = Variable<String>(fromType);
    map['to_id'] = Variable<String>(toId);
    map['to_type'] = Variable<String>(toType);
    map['relation_type'] = Variable<String>(relationType);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || sourceImportId != null) {
      map['source_import_id'] = Variable<String>(sourceImportId);
    }
    return map;
  }

  RelationsCompanion toCompanion(bool nullToAbsent) {
    return RelationsCompanion(
      id: Value(id),
      fromId: Value(fromId),
      fromType: Value(fromType),
      toId: Value(toId),
      toType: Value(toType),
      relationType: Value(relationType),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      sourceImportId: sourceImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImportId),
    );
  }

  factory Relation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Relation(
      id: serializer.fromJson<String>(json['id']),
      fromId: serializer.fromJson<String>(json['fromId']),
      fromType: serializer.fromJson<String>(json['fromType']),
      toId: serializer.fromJson<String>(json['toId']),
      toType: serializer.fromJson<String>(json['toType']),
      relationType: serializer.fromJson<String>(json['relationType']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sourceImportId: serializer.fromJson<String?>(json['sourceImportId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromId': serializer.toJson<String>(fromId),
      'fromType': serializer.toJson<String>(fromType),
      'toId': serializer.toJson<String>(toId),
      'toType': serializer.toJson<String>(toType),
      'relationType': serializer.toJson<String>(relationType),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sourceImportId': serializer.toJson<String?>(sourceImportId),
    };
  }

  Relation copyWith({
    String? id,
    String? fromId,
    String? fromType,
    String? toId,
    String? toType,
    String? relationType,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    Value<String?> sourceImportId = const Value.absent(),
  }) => Relation(
    id: id ?? this.id,
    fromId: fromId ?? this.fromId,
    fromType: fromType ?? this.fromType,
    toId: toId ?? this.toId,
    toType: toType ?? this.toType,
    relationType: relationType ?? this.relationType,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    sourceImportId: sourceImportId.present
        ? sourceImportId.value
        : this.sourceImportId,
  );
  Relation copyWithCompanion(RelationsCompanion data) {
    return Relation(
      id: data.id.present ? data.id.value : this.id,
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      fromType: data.fromType.present ? data.fromType.value : this.fromType,
      toId: data.toId.present ? data.toId.value : this.toId,
      toType: data.toType.present ? data.toType.value : this.toType,
      relationType: data.relationType.present
          ? data.relationType.value
          : this.relationType,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sourceImportId: data.sourceImportId.present
          ? data.sourceImportId.value
          : this.sourceImportId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Relation(')
          ..write('id: $id, ')
          ..write('fromId: $fromId, ')
          ..write('fromType: $fromType, ')
          ..write('toId: $toId, ')
          ..write('toType: $toType, ')
          ..write('relationType: $relationType, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourceImportId: $sourceImportId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromId,
    fromType,
    toId,
    toType,
    relationType,
    note,
    createdAt,
    sourceImportId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Relation &&
          other.id == this.id &&
          other.fromId == this.fromId &&
          other.fromType == this.fromType &&
          other.toId == this.toId &&
          other.toType == this.toType &&
          other.relationType == this.relationType &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.sourceImportId == this.sourceImportId);
}

class RelationsCompanion extends UpdateCompanion<Relation> {
  final Value<String> id;
  final Value<String> fromId;
  final Value<String> fromType;
  final Value<String> toId;
  final Value<String> toType;
  final Value<String> relationType;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<String?> sourceImportId;
  final Value<int> rowid;
  const RelationsCompanion({
    this.id = const Value.absent(),
    this.fromId = const Value.absent(),
    this.fromType = const Value.absent(),
    this.toId = const Value.absent(),
    this.toType = const Value.absent(),
    this.relationType = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationsCompanion.insert({
    required String id,
    required String fromId,
    required String fromType,
    required String toId,
    required String toType,
    required String relationType,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromId = Value(fromId),
       fromType = Value(fromType),
       toId = Value(toId),
       toType = Value(toType),
       relationType = Value(relationType),
       createdAt = Value(createdAt);
  static Insertable<Relation> custom({
    Expression<String>? id,
    Expression<String>? fromId,
    Expression<String>? fromType,
    Expression<String>? toId,
    Expression<String>? toType,
    Expression<String>? relationType,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<String>? sourceImportId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromId != null) 'from_id': fromId,
      if (fromType != null) 'from_type': fromType,
      if (toId != null) 'to_id': toId,
      if (toType != null) 'to_type': toType,
      if (relationType != null) 'relation_type': relationType,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (sourceImportId != null) 'source_import_id': sourceImportId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationsCompanion copyWith({
    Value<String>? id,
    Value<String>? fromId,
    Value<String>? fromType,
    Value<String>? toId,
    Value<String>? toType,
    Value<String>? relationType,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<String?>? sourceImportId,
    Value<int>? rowid,
  }) {
    return RelationsCompanion(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      fromType: fromType ?? this.fromType,
      toId: toId ?? this.toId,
      toType: toType ?? this.toType,
      relationType: relationType ?? this.relationType,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      sourceImportId: sourceImportId ?? this.sourceImportId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<String>(fromId.value);
    }
    if (fromType.present) {
      map['from_type'] = Variable<String>(fromType.value);
    }
    if (toId.present) {
      map['to_id'] = Variable<String>(toId.value);
    }
    if (toType.present) {
      map['to_type'] = Variable<String>(toType.value);
    }
    if (relationType.present) {
      map['relation_type'] = Variable<String>(relationType.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sourceImportId.present) {
      map['source_import_id'] = Variable<String>(sourceImportId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationsCompanion(')
          ..write('id: $id, ')
          ..write('fromId: $fromId, ')
          ..write('fromType: $fromType, ')
          ..write('toId: $toId, ')
          ..write('toType: $toType, ')
          ..write('relationType: $relationType, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('sourceImportId: $sourceImportId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $YamlImportsTable extends YamlImports
    with TableInfo<$YamlImportsTable, YamlImport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YamlImportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawYamlMeta = const VerificationMeta(
    'rawYaml',
  );
  @override
  late final GeneratedColumn<String> rawYaml = GeneratedColumn<String>(
    'raw_yaml',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parseWarningsMeta = const VerificationMeta(
    'parseWarnings',
  );
  @override
  late final GeneratedColumn<String> parseWarnings = GeneratedColumn<String>(
    'parse_warnings',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRevertedMeta = const VerificationMeta(
    'isReverted',
  );
  @override
  late final GeneratedColumn<bool> isReverted = GeneratedColumn<bool>(
    'is_reverted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reverted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rawYaml,
    summary,
    parseWarnings,
    importedAt,
    isReverted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'yaml_imports';
  @override
  VerificationContext validateIntegrity(
    Insertable<YamlImport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('raw_yaml')) {
      context.handle(
        _rawYamlMeta,
        rawYaml.isAcceptableOrUnknown(data['raw_yaml']!, _rawYamlMeta),
      );
    } else if (isInserting) {
      context.missing(_rawYamlMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('parse_warnings')) {
      context.handle(
        _parseWarningsMeta,
        parseWarnings.isAcceptableOrUnknown(
          data['parse_warnings']!,
          _parseWarningsMeta,
        ),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('is_reverted')) {
      context.handle(
        _isRevertedMeta,
        isReverted.isAcceptableOrUnknown(data['is_reverted']!, _isRevertedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  YamlImport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return YamlImport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rawYaml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_yaml'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      parseWarnings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parse_warnings'],
      ),
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}imported_at'],
      )!,
      isReverted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_reverted'],
      )!,
    );
  }

  @override
  $YamlImportsTable createAlias(String alias) {
    return $YamlImportsTable(attachedDatabase, alias);
  }
}

class YamlImport extends DataClass implements Insertable<YamlImport> {
  final String id;
  final String rawYaml;
  final String summary;
  final String? parseWarnings;
  final DateTime importedAt;
  final bool isReverted;
  const YamlImport({
    required this.id,
    required this.rawYaml,
    required this.summary,
    this.parseWarnings,
    required this.importedAt,
    required this.isReverted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['raw_yaml'] = Variable<String>(rawYaml);
    map['summary'] = Variable<String>(summary);
    if (!nullToAbsent || parseWarnings != null) {
      map['parse_warnings'] = Variable<String>(parseWarnings);
    }
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['is_reverted'] = Variable<bool>(isReverted);
    return map;
  }

  YamlImportsCompanion toCompanion(bool nullToAbsent) {
    return YamlImportsCompanion(
      id: Value(id),
      rawYaml: Value(rawYaml),
      summary: Value(summary),
      parseWarnings: parseWarnings == null && nullToAbsent
          ? const Value.absent()
          : Value(parseWarnings),
      importedAt: Value(importedAt),
      isReverted: Value(isReverted),
    );
  }

  factory YamlImport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return YamlImport(
      id: serializer.fromJson<String>(json['id']),
      rawYaml: serializer.fromJson<String>(json['rawYaml']),
      summary: serializer.fromJson<String>(json['summary']),
      parseWarnings: serializer.fromJson<String?>(json['parseWarnings']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      isReverted: serializer.fromJson<bool>(json['isReverted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rawYaml': serializer.toJson<String>(rawYaml),
      'summary': serializer.toJson<String>(summary),
      'parseWarnings': serializer.toJson<String?>(parseWarnings),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'isReverted': serializer.toJson<bool>(isReverted),
    };
  }

  YamlImport copyWith({
    String? id,
    String? rawYaml,
    String? summary,
    Value<String?> parseWarnings = const Value.absent(),
    DateTime? importedAt,
    bool? isReverted,
  }) => YamlImport(
    id: id ?? this.id,
    rawYaml: rawYaml ?? this.rawYaml,
    summary: summary ?? this.summary,
    parseWarnings: parseWarnings.present
        ? parseWarnings.value
        : this.parseWarnings,
    importedAt: importedAt ?? this.importedAt,
    isReverted: isReverted ?? this.isReverted,
  );
  YamlImport copyWithCompanion(YamlImportsCompanion data) {
    return YamlImport(
      id: data.id.present ? data.id.value : this.id,
      rawYaml: data.rawYaml.present ? data.rawYaml.value : this.rawYaml,
      summary: data.summary.present ? data.summary.value : this.summary,
      parseWarnings: data.parseWarnings.present
          ? data.parseWarnings.value
          : this.parseWarnings,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      isReverted: data.isReverted.present
          ? data.isReverted.value
          : this.isReverted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('YamlImport(')
          ..write('id: $id, ')
          ..write('rawYaml: $rawYaml, ')
          ..write('summary: $summary, ')
          ..write('parseWarnings: $parseWarnings, ')
          ..write('importedAt: $importedAt, ')
          ..write('isReverted: $isReverted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, rawYaml, summary, parseWarnings, importedAt, isReverted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is YamlImport &&
          other.id == this.id &&
          other.rawYaml == this.rawYaml &&
          other.summary == this.summary &&
          other.parseWarnings == this.parseWarnings &&
          other.importedAt == this.importedAt &&
          other.isReverted == this.isReverted);
}

class YamlImportsCompanion extends UpdateCompanion<YamlImport> {
  final Value<String> id;
  final Value<String> rawYaml;
  final Value<String> summary;
  final Value<String?> parseWarnings;
  final Value<DateTime> importedAt;
  final Value<bool> isReverted;
  final Value<int> rowid;
  const YamlImportsCompanion({
    this.id = const Value.absent(),
    this.rawYaml = const Value.absent(),
    this.summary = const Value.absent(),
    this.parseWarnings = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.isReverted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  YamlImportsCompanion.insert({
    required String id,
    required String rawYaml,
    required String summary,
    this.parseWarnings = const Value.absent(),
    required DateTime importedAt,
    this.isReverted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rawYaml = Value(rawYaml),
       summary = Value(summary),
       importedAt = Value(importedAt);
  static Insertable<YamlImport> custom({
    Expression<String>? id,
    Expression<String>? rawYaml,
    Expression<String>? summary,
    Expression<String>? parseWarnings,
    Expression<DateTime>? importedAt,
    Expression<bool>? isReverted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawYaml != null) 'raw_yaml': rawYaml,
      if (summary != null) 'summary': summary,
      if (parseWarnings != null) 'parse_warnings': parseWarnings,
      if (importedAt != null) 'imported_at': importedAt,
      if (isReverted != null) 'is_reverted': isReverted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  YamlImportsCompanion copyWith({
    Value<String>? id,
    Value<String>? rawYaml,
    Value<String>? summary,
    Value<String?>? parseWarnings,
    Value<DateTime>? importedAt,
    Value<bool>? isReverted,
    Value<int>? rowid,
  }) {
    return YamlImportsCompanion(
      id: id ?? this.id,
      rawYaml: rawYaml ?? this.rawYaml,
      summary: summary ?? this.summary,
      parseWarnings: parseWarnings ?? this.parseWarnings,
      importedAt: importedAt ?? this.importedAt,
      isReverted: isReverted ?? this.isReverted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rawYaml.present) {
      map['raw_yaml'] = Variable<String>(rawYaml.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (parseWarnings.present) {
      map['parse_warnings'] = Variable<String>(parseWarnings.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (isReverted.present) {
      map['is_reverted'] = Variable<bool>(isReverted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YamlImportsCompanion(')
          ..write('id: $id, ')
          ..write('rawYaml: $rawYaml, ')
          ..write('summary: $summary, ')
          ..write('parseWarnings: $parseWarnings, ')
          ..write('importedAt: $importedAt, ')
          ..write('isReverted: $isReverted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DecayLogsTable extends DecayLogs
    with TableInfo<$DecayLogsTable, DecayLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecayLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, projectId, date, score, zone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decay_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DecayLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    } else if (isInserting) {
      context.missing(_zoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DecayLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DecayLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      zone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone'],
      )!,
    );
  }

  @override
  $DecayLogsTable createAlias(String alias) {
    return $DecayLogsTable(attachedDatabase, alias);
  }
}

class DecayLog extends DataClass implements Insertable<DecayLog> {
  final String id;
  final String projectId;
  final DateTime date;
  final double score;
  final String zone;
  const DecayLog({
    required this.id,
    required this.projectId,
    required this.date,
    required this.score,
    required this.zone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['date'] = Variable<DateTime>(date);
    map['score'] = Variable<double>(score);
    map['zone'] = Variable<String>(zone);
    return map;
  }

  DecayLogsCompanion toCompanion(bool nullToAbsent) {
    return DecayLogsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      date: Value(date),
      score: Value(score),
      zone: Value(zone),
    );
  }

  factory DecayLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DecayLog(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      date: serializer.fromJson<DateTime>(json['date']),
      score: serializer.fromJson<double>(json['score']),
      zone: serializer.fromJson<String>(json['zone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'date': serializer.toJson<DateTime>(date),
      'score': serializer.toJson<double>(score),
      'zone': serializer.toJson<String>(zone),
    };
  }

  DecayLog copyWith({
    String? id,
    String? projectId,
    DateTime? date,
    double? score,
    String? zone,
  }) => DecayLog(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    date: date ?? this.date,
    score: score ?? this.score,
    zone: zone ?? this.zone,
  );
  DecayLog copyWithCompanion(DecayLogsCompanion data) {
    return DecayLog(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      date: data.date.present ? data.date.value : this.date,
      score: data.score.present ? data.score.value : this.score,
      zone: data.zone.present ? data.zone.value : this.zone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DecayLog(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('zone: $zone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, date, score, zone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DecayLog &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.date == this.date &&
          other.score == this.score &&
          other.zone == this.zone);
}

class DecayLogsCompanion extends UpdateCompanion<DecayLog> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<DateTime> date;
  final Value<double> score;
  final Value<String> zone;
  final Value<int> rowid;
  const DecayLogsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.date = const Value.absent(),
    this.score = const Value.absent(),
    this.zone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DecayLogsCompanion.insert({
    required String id,
    required String projectId,
    required DateTime date,
    required double score,
    required String zone,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       date = Value(date),
       score = Value(score),
       zone = Value(zone);
  static Insertable<DecayLog> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<DateTime>? date,
    Expression<double>? score,
    Expression<String>? zone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (date != null) 'date': date,
      if (score != null) 'score': score,
      if (zone != null) 'zone': zone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DecayLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<DateTime>? date,
    Value<double>? score,
    Value<String>? zone,
    Value<int>? rowid,
  }) {
    return DecayLogsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      date: date ?? this.date,
      score: score ?? this.score,
      zone: zone ?? this.zone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecayLogsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('date: $date, ')
          ..write('score: $score, ')
          ..write('zone: $zone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationLogTable extends NotificationLog
    with TableInfo<$NotificationLogTable, NotificationLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, projectId, sentAt, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $NotificationLogTable createAlias(String alias) {
    return $NotificationLogTable(attachedDatabase, alias);
  }
}

class NotificationLogData extends DataClass
    implements Insertable<NotificationLogData> {
  final String id;
  final String? projectId;
  final DateTime sentAt;
  final String type;
  const NotificationLogData({
    required this.id,
    this.projectId,
    required this.sentAt,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['sent_at'] = Variable<DateTime>(sentAt);
    map['type'] = Variable<String>(type);
    return map;
  }

  NotificationLogCompanion toCompanion(bool nullToAbsent) {
    return NotificationLogCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      sentAt: Value(sentAt),
      type: Value(type),
    );
  }

  factory NotificationLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationLogData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'type': serializer.toJson<String>(type),
    };
  }

  NotificationLogData copyWith({
    String? id,
    Value<String?> projectId = const Value.absent(),
    DateTime? sentAt,
    String? type,
  }) => NotificationLogData(
    id: id ?? this.id,
    projectId: projectId.present ? projectId.value : this.projectId,
    sentAt: sentAt ?? this.sentAt,
    type: type ?? this.type,
  );
  NotificationLogData copyWithCompanion(NotificationLogCompanion data) {
    return NotificationLogData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationLogData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('sentAt: $sentAt, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, sentAt, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationLogData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.sentAt == this.sentAt &&
          other.type == this.type);
}

class NotificationLogCompanion extends UpdateCompanion<NotificationLogData> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<DateTime> sentAt;
  final Value<String> type;
  final Value<int> rowid;
  const NotificationLogCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationLogCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required DateTime sentAt,
    required String type,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sentAt = Value(sentAt),
       type = Value(type);
  static Insertable<NotificationLogData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<DateTime>? sentAt,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (sentAt != null) 'sent_at': sentAt,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationLogCompanion copyWith({
    Value<String>? id,
    Value<String?>? projectId,
    Value<DateTime>? sentAt,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return NotificationLogCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      sentAt: sentAt ?? this.sentAt,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationLogCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('sentAt: $sentAt, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PulseDatabase extends GeneratedDatabase {
  _$PulseDatabase(QueryExecutor e) : super(e);
  $PulseDatabaseManager get managers => $PulseDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $IdeasTable ideas = $IdeasTable(this);
  late final $RelationsTable relations = $RelationsTable(this);
  late final $YamlImportsTable yamlImports = $YamlImportsTable(this);
  late final $DecayLogsTable decayLogs = $DecayLogsTable(this);
  late final $NotificationLogTable notificationLog = $NotificationLogTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    sessions,
    ideas,
    relations,
    yamlImports,
    decayLogs,
    notificationLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ideas', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ideas', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('decay_logs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String> priority,
      Value<String> status,
      required DateTime createdAt,
      Value<DateTime?> lastSessionAt,
      Value<double> avgGapDays,
      Value<String?> lastNote,
      Value<String?> sourceImportId,
      Value<String?> colorSeed,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> priority,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSessionAt,
      Value<double> avgGapDays,
      Value<String?> lastNote,
      Value<String?> sourceImportId,
      Value<String?> colorSeed,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$PulseDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$PulseDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: $_aliasNameGenerator(db.projects.id, db.sessions.projectId),
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DecayLogsTable, List<DecayLog>>
  _decayLogsRefsTable(_$PulseDatabase db) => MultiTypedResultKey.fromTable(
    db.decayLogs,
    aliasName: $_aliasNameGenerator(db.projects.id, db.decayLogs.projectId),
  );

  $$DecayLogsTableProcessedTableManager get decayLogsRefs {
    final manager = $$DecayLogsTableTableManager(
      $_db,
      $_db.decayLogs,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_decayLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$PulseDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSessionAt => $composableBuilder(
    column: $table.lastSessionAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgGapDays => $composableBuilder(
    column: $table.avgGapDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastNote => $composableBuilder(
    column: $table.lastNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorSeed => $composableBuilder(
    column: $table.colorSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> decayLogsRefs(
    Expression<bool> Function($$DecayLogsTableFilterComposer f) f,
  ) {
    final $$DecayLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.decayLogs,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecayLogsTableFilterComposer(
            $db: $db,
            $table: $db.decayLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$PulseDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSessionAt => $composableBuilder(
    column: $table.lastSessionAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgGapDays => $composableBuilder(
    column: $table.avgGapDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastNote => $composableBuilder(
    column: $table.lastNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorSeed => $composableBuilder(
    column: $table.colorSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSessionAt => $composableBuilder(
    column: $table.lastSessionAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgGapDays => $composableBuilder(
    column: $table.avgGapDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastNote =>
      $composableBuilder(column: $table.lastNote, builder: (column) => column);

  GeneratedColumn<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorSeed =>
      $composableBuilder(column: $table.colorSeed, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> decayLogsRefs<T extends Object>(
    Expression<T> Function($$DecayLogsTableAnnotationComposer a) f,
  ) {
    final $$DecayLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.decayLogs,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DecayLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.decayLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool sessionsRefs, bool decayLogsRefs})
        > {
  $$ProjectsTableTableManager(_$PulseDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSessionAt = const Value.absent(),
                Value<double> avgGapDays = const Value.absent(),
                Value<String?> lastNote = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<String?> colorSeed = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                description: description,
                priority: priority,
                status: status,
                createdAt: createdAt,
                lastSessionAt: lastSessionAt,
                avgGapDays: avgGapDays,
                lastNote: lastNote,
                sourceImportId: sourceImportId,
                colorSeed: colorSeed,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastSessionAt = const Value.absent(),
                Value<double> avgGapDays = const Value.absent(),
                Value<String?> lastNote = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<String?> colorSeed = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                description: description,
                priority: priority,
                status: status,
                createdAt: createdAt,
                lastSessionAt: lastSessionAt,
                avgGapDays: avgGapDays,
                lastNote: lastNote,
                sourceImportId: sourceImportId,
                colorSeed: colorSeed,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionsRefs = false, decayLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionsRefs) db.sessions,
                    if (decayLogsRefs) db.decayLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          Session
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (decayLogsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          DecayLog
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._decayLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).decayLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool sessionsRefs, bool decayLogsRefs})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String projectId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String?> tag,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String?> tag,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$PulseDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.sessions.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$PulseDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$PulseDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool projectId})
        > {
  $$SessionsTableTableManager(_$PulseDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                tag: tag,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                tag: tag,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$SessionsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$SessionsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$IdeasTableCreateCompanionBuilder =
    IdeasCompanion Function({
      required String id,
      required String content,
      Value<String?> projectId,
      required DateTime createdAt,
      Value<String> status,
      Value<String?> promotedToProjectId,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });
typedef $$IdeasTableUpdateCompanionBuilder =
    IdeasCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String?> projectId,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<String?> promotedToProjectId,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });

final class $$IdeasTableReferences
    extends BaseReferences<_$PulseDatabase, $IdeasTable, Idea> {
  $$IdeasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.ideas.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _promotedToProjectIdTable(_$PulseDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.ideas.promotedToProjectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager? get promotedToProjectId {
    final $_column = $_itemColumn<String>('promoted_to_project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_promotedToProjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IdeasTableFilterComposer
    extends Composer<_$PulseDatabase, $IdeasTable> {
  $$IdeasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get promotedToProjectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promotedToProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdeasTableOrderingComposer
    extends Composer<_$PulseDatabase, $IdeasTable> {
  $$IdeasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get promotedToProjectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promotedToProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdeasTableAnnotationComposer
    extends Composer<_$PulseDatabase, $IdeasTable> {
  $$IdeasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => column,
  );

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get promotedToProjectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.promotedToProjectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IdeasTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $IdeasTable,
          Idea,
          $$IdeasTableFilterComposer,
          $$IdeasTableOrderingComposer,
          $$IdeasTableAnnotationComposer,
          $$IdeasTableCreateCompanionBuilder,
          $$IdeasTableUpdateCompanionBuilder,
          (Idea, $$IdeasTableReferences),
          Idea,
          PrefetchHooks Function({bool projectId, bool promotedToProjectId})
        > {
  $$IdeasTableTableManager(_$PulseDatabase db, $IdeasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IdeasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IdeasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IdeasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> promotedToProjectId = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion(
                id: id,
                content: content,
                projectId: projectId,
                createdAt: createdAt,
                status: status,
                promotedToProjectId: promotedToProjectId,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                Value<String?> projectId = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<String?> promotedToProjectId = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion.insert(
                id: id,
                content: content,
                projectId: projectId,
                createdAt: createdAt,
                status: status,
                promotedToProjectId: promotedToProjectId,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$IdeasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, promotedToProjectId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$IdeasTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$IdeasTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (promotedToProjectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.promotedToProjectId,
                                    referencedTable: $$IdeasTableReferences
                                        ._promotedToProjectIdTable(db),
                                    referencedColumn: $$IdeasTableReferences
                                        ._promotedToProjectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$IdeasTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $IdeasTable,
      Idea,
      $$IdeasTableFilterComposer,
      $$IdeasTableOrderingComposer,
      $$IdeasTableAnnotationComposer,
      $$IdeasTableCreateCompanionBuilder,
      $$IdeasTableUpdateCompanionBuilder,
      (Idea, $$IdeasTableReferences),
      Idea,
      PrefetchHooks Function({bool projectId, bool promotedToProjectId})
    >;
typedef $$RelationsTableCreateCompanionBuilder =
    RelationsCompanion Function({
      required String id,
      required String fromId,
      required String fromType,
      required String toId,
      required String toType,
      required String relationType,
      Value<String?> note,
      required DateTime createdAt,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });
typedef $$RelationsTableUpdateCompanionBuilder =
    RelationsCompanion Function({
      Value<String> id,
      Value<String> fromId,
      Value<String> fromType,
      Value<String> toId,
      Value<String> toType,
      Value<String> relationType,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });

class $$RelationsTableFilterComposer
    extends Composer<_$PulseDatabase, $RelationsTable> {
  $$RelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromType => $composableBuilder(
    column: $table.fromType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toType => $composableBuilder(
    column: $table.toType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RelationsTableOrderingComposer
    extends Composer<_$PulseDatabase, $RelationsTable> {
  $$RelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromType => $composableBuilder(
    column: $table.fromType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toType => $composableBuilder(
    column: $table.toType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RelationsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $RelationsTable> {
  $$RelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<String> get fromType =>
      $composableBuilder(column: $table.fromType, builder: (column) => column);

  GeneratedColumn<String> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<String> get toType =>
      $composableBuilder(column: $table.toType, builder: (column) => column);

  GeneratedColumn<String> get relationType => $composableBuilder(
    column: $table.relationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => column,
  );
}

class $$RelationsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $RelationsTable,
          Relation,
          $$RelationsTableFilterComposer,
          $$RelationsTableOrderingComposer,
          $$RelationsTableAnnotationComposer,
          $$RelationsTableCreateCompanionBuilder,
          $$RelationsTableUpdateCompanionBuilder,
          (
            Relation,
            BaseReferences<_$PulseDatabase, $RelationsTable, Relation>,
          ),
          Relation,
          PrefetchHooks Function()
        > {
  $$RelationsTableTableManager(_$PulseDatabase db, $RelationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromId = const Value.absent(),
                Value<String> fromType = const Value.absent(),
                Value<String> toId = const Value.absent(),
                Value<String> toType = const Value.absent(),
                Value<String> relationType = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelationsCompanion(
                id: id,
                fromId: fromId,
                fromType: fromType,
                toId: toId,
                toType: toType,
                relationType: relationType,
                note: note,
                createdAt: createdAt,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromId,
                required String fromType,
                required String toId,
                required String toType,
                required String relationType,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RelationsCompanion.insert(
                id: id,
                fromId: fromId,
                fromType: fromType,
                toId: toId,
                toType: toType,
                relationType: relationType,
                note: note,
                createdAt: createdAt,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $RelationsTable,
      Relation,
      $$RelationsTableFilterComposer,
      $$RelationsTableOrderingComposer,
      $$RelationsTableAnnotationComposer,
      $$RelationsTableCreateCompanionBuilder,
      $$RelationsTableUpdateCompanionBuilder,
      (Relation, BaseReferences<_$PulseDatabase, $RelationsTable, Relation>),
      Relation,
      PrefetchHooks Function()
    >;
typedef $$YamlImportsTableCreateCompanionBuilder =
    YamlImportsCompanion Function({
      required String id,
      required String rawYaml,
      required String summary,
      Value<String?> parseWarnings,
      required DateTime importedAt,
      Value<bool> isReverted,
      Value<int> rowid,
    });
typedef $$YamlImportsTableUpdateCompanionBuilder =
    YamlImportsCompanion Function({
      Value<String> id,
      Value<String> rawYaml,
      Value<String> summary,
      Value<String?> parseWarnings,
      Value<DateTime> importedAt,
      Value<bool> isReverted,
      Value<int> rowid,
    });

class $$YamlImportsTableFilterComposer
    extends Composer<_$PulseDatabase, $YamlImportsTable> {
  $$YamlImportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawYaml => $composableBuilder(
    column: $table.rawYaml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parseWarnings => $composableBuilder(
    column: $table.parseWarnings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReverted => $composableBuilder(
    column: $table.isReverted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$YamlImportsTableOrderingComposer
    extends Composer<_$PulseDatabase, $YamlImportsTable> {
  $$YamlImportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawYaml => $composableBuilder(
    column: $table.rawYaml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parseWarnings => $composableBuilder(
    column: $table.parseWarnings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReverted => $composableBuilder(
    column: $table.isReverted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$YamlImportsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $YamlImportsTable> {
  $$YamlImportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawYaml =>
      $composableBuilder(column: $table.rawYaml, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get parseWarnings => $composableBuilder(
    column: $table.parseWarnings,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isReverted => $composableBuilder(
    column: $table.isReverted,
    builder: (column) => column,
  );
}

class $$YamlImportsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $YamlImportsTable,
          YamlImport,
          $$YamlImportsTableFilterComposer,
          $$YamlImportsTableOrderingComposer,
          $$YamlImportsTableAnnotationComposer,
          $$YamlImportsTableCreateCompanionBuilder,
          $$YamlImportsTableUpdateCompanionBuilder,
          (
            YamlImport,
            BaseReferences<_$PulseDatabase, $YamlImportsTable, YamlImport>,
          ),
          YamlImport,
          PrefetchHooks Function()
        > {
  $$YamlImportsTableTableManager(_$PulseDatabase db, $YamlImportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YamlImportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YamlImportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YamlImportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rawYaml = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String?> parseWarnings = const Value.absent(),
                Value<DateTime> importedAt = const Value.absent(),
                Value<bool> isReverted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YamlImportsCompanion(
                id: id,
                rawYaml: rawYaml,
                summary: summary,
                parseWarnings: parseWarnings,
                importedAt: importedAt,
                isReverted: isReverted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rawYaml,
                required String summary,
                Value<String?> parseWarnings = const Value.absent(),
                required DateTime importedAt,
                Value<bool> isReverted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => YamlImportsCompanion.insert(
                id: id,
                rawYaml: rawYaml,
                summary: summary,
                parseWarnings: parseWarnings,
                importedAt: importedAt,
                isReverted: isReverted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$YamlImportsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $YamlImportsTable,
      YamlImport,
      $$YamlImportsTableFilterComposer,
      $$YamlImportsTableOrderingComposer,
      $$YamlImportsTableAnnotationComposer,
      $$YamlImportsTableCreateCompanionBuilder,
      $$YamlImportsTableUpdateCompanionBuilder,
      (
        YamlImport,
        BaseReferences<_$PulseDatabase, $YamlImportsTable, YamlImport>,
      ),
      YamlImport,
      PrefetchHooks Function()
    >;
typedef $$DecayLogsTableCreateCompanionBuilder =
    DecayLogsCompanion Function({
      required String id,
      required String projectId,
      required DateTime date,
      required double score,
      required String zone,
      Value<int> rowid,
    });
typedef $$DecayLogsTableUpdateCompanionBuilder =
    DecayLogsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<DateTime> date,
      Value<double> score,
      Value<String> zone,
      Value<int> rowid,
    });

final class $$DecayLogsTableReferences
    extends BaseReferences<_$PulseDatabase, $DecayLogsTable, DecayLog> {
  $$DecayLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.decayLogs.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DecayLogsTableFilterComposer
    extends Composer<_$PulseDatabase, $DecayLogsTable> {
  $$DecayLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecayLogsTableOrderingComposer
    extends Composer<_$PulseDatabase, $DecayLogsTable> {
  $$DecayLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecayLogsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $DecayLogsTable> {
  $$DecayLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DecayLogsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $DecayLogsTable,
          DecayLog,
          $$DecayLogsTableFilterComposer,
          $$DecayLogsTableOrderingComposer,
          $$DecayLogsTableAnnotationComposer,
          $$DecayLogsTableCreateCompanionBuilder,
          $$DecayLogsTableUpdateCompanionBuilder,
          (DecayLog, $$DecayLogsTableReferences),
          DecayLog,
          PrefetchHooks Function({bool projectId})
        > {
  $$DecayLogsTableTableManager(_$PulseDatabase db, $DecayLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecayLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecayLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecayLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<String> zone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DecayLogsCompanion(
                id: id,
                projectId: projectId,
                date: date,
                score: score,
                zone: zone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required DateTime date,
                required double score,
                required String zone,
                Value<int> rowid = const Value.absent(),
              }) => DecayLogsCompanion.insert(
                id: id,
                projectId: projectId,
                date: date,
                score: score,
                zone: zone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DecayLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$DecayLogsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$DecayLogsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DecayLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $DecayLogsTable,
      DecayLog,
      $$DecayLogsTableFilterComposer,
      $$DecayLogsTableOrderingComposer,
      $$DecayLogsTableAnnotationComposer,
      $$DecayLogsTableCreateCompanionBuilder,
      $$DecayLogsTableUpdateCompanionBuilder,
      (DecayLog, $$DecayLogsTableReferences),
      DecayLog,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$NotificationLogTableCreateCompanionBuilder =
    NotificationLogCompanion Function({
      required String id,
      Value<String?> projectId,
      required DateTime sentAt,
      required String type,
      Value<int> rowid,
    });
typedef $$NotificationLogTableUpdateCompanionBuilder =
    NotificationLogCompanion Function({
      Value<String> id,
      Value<String?> projectId,
      Value<DateTime> sentAt,
      Value<String> type,
      Value<int> rowid,
    });

class $$NotificationLogTableFilterComposer
    extends Composer<_$PulseDatabase, $NotificationLogTable> {
  $$NotificationLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationLogTableOrderingComposer
    extends Composer<_$PulseDatabase, $NotificationLogTable> {
  $$NotificationLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationLogTableAnnotationComposer
    extends Composer<_$PulseDatabase, $NotificationLogTable> {
  $$NotificationLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$NotificationLogTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $NotificationLogTable,
          NotificationLogData,
          $$NotificationLogTableFilterComposer,
          $$NotificationLogTableOrderingComposer,
          $$NotificationLogTableAnnotationComposer,
          $$NotificationLogTableCreateCompanionBuilder,
          $$NotificationLogTableUpdateCompanionBuilder,
          (
            NotificationLogData,
            BaseReferences<
              _$PulseDatabase,
              $NotificationLogTable,
              NotificationLogData
            >,
          ),
          NotificationLogData,
          PrefetchHooks Function()
        > {
  $$NotificationLogTableTableManager(
    _$PulseDatabase db,
    $NotificationLogTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationLogCompanion(
                id: id,
                projectId: projectId,
                sentAt: sentAt,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> projectId = const Value.absent(),
                required DateTime sentAt,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => NotificationLogCompanion.insert(
                id: id,
                projectId: projectId,
                sentAt: sentAt,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationLogTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $NotificationLogTable,
      NotificationLogData,
      $$NotificationLogTableFilterComposer,
      $$NotificationLogTableOrderingComposer,
      $$NotificationLogTableAnnotationComposer,
      $$NotificationLogTableCreateCompanionBuilder,
      $$NotificationLogTableUpdateCompanionBuilder,
      (
        NotificationLogData,
        BaseReferences<
          _$PulseDatabase,
          $NotificationLogTable,
          NotificationLogData
        >,
      ),
      NotificationLogData,
      PrefetchHooks Function()
    >;

class $PulseDatabaseManager {
  final _$PulseDatabase _db;
  $PulseDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$IdeasTableTableManager get ideas =>
      $$IdeasTableTableManager(_db, _db.ideas);
  $$RelationsTableTableManager get relations =>
      $$RelationsTableTableManager(_db, _db.relations);
  $$YamlImportsTableTableManager get yamlImports =>
      $$YamlImportsTableTableManager(_db, _db.yamlImports);
  $$DecayLogsTableTableManager get decayLogs =>
      $$DecayLogsTableTableManager(_db, _db.decayLogs);
  $$NotificationLogTableTableManager get notificationLog =>
      $$NotificationLogTableTableManager(_db, _db.notificationLog);
}
