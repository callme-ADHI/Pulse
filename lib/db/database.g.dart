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
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
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
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    weight,
    status,
    createdAt,
    lastSessionAt,
    avgGapDays,
    lastNote,
    estimatedMinutes,
    colorSeed,
    sourceImportId,
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
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
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
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('color_seed')) {
      context.handle(
        _colorSeedMeta,
        colorSeed.isAcceptableOrUnknown(data['color_seed']!, _colorSeedMeta),
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
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
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
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      ),
      colorSeed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_seed'],
      ),
      sourceImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_import_id'],
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
  final double weight;
  final String status;
  final DateTime createdAt;
  final DateTime? lastSessionAt;
  final double avgGapDays;
  final String? lastNote;
  final int? estimatedMinutes;
  final String? colorSeed;
  final String? sourceImportId;
  final bool isDeleted;
  final DateTime? deletedAt;
  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.weight,
    required this.status,
    required this.createdAt,
    this.lastSessionAt,
    required this.avgGapDays,
    this.lastNote,
    this.estimatedMinutes,
    this.colorSeed,
    this.sourceImportId,
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
    map['weight'] = Variable<double>(weight);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastSessionAt != null) {
      map['last_session_at'] = Variable<DateTime>(lastSessionAt);
    }
    map['avg_gap_days'] = Variable<double>(avgGapDays);
    if (!nullToAbsent || lastNote != null) {
      map['last_note'] = Variable<String>(lastNote);
    }
    if (!nullToAbsent || estimatedMinutes != null) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    }
    if (!nullToAbsent || colorSeed != null) {
      map['color_seed'] = Variable<String>(colorSeed);
    }
    if (!nullToAbsent || sourceImportId != null) {
      map['source_import_id'] = Variable<String>(sourceImportId);
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
      weight: Value(weight),
      status: Value(status),
      createdAt: Value(createdAt),
      lastSessionAt: lastSessionAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSessionAt),
      avgGapDays: Value(avgGapDays),
      lastNote: lastNote == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNote),
      estimatedMinutes: estimatedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedMinutes),
      colorSeed: colorSeed == null && nullToAbsent
          ? const Value.absent()
          : Value(colorSeed),
      sourceImportId: sourceImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImportId),
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
      weight: serializer.fromJson<double>(json['weight']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSessionAt: serializer.fromJson<DateTime?>(json['lastSessionAt']),
      avgGapDays: serializer.fromJson<double>(json['avgGapDays']),
      lastNote: serializer.fromJson<String?>(json['lastNote']),
      estimatedMinutes: serializer.fromJson<int?>(json['estimatedMinutes']),
      colorSeed: serializer.fromJson<String?>(json['colorSeed']),
      sourceImportId: serializer.fromJson<String?>(json['sourceImportId']),
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
      'weight': serializer.toJson<double>(weight),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSessionAt': serializer.toJson<DateTime?>(lastSessionAt),
      'avgGapDays': serializer.toJson<double>(avgGapDays),
      'lastNote': serializer.toJson<String?>(lastNote),
      'estimatedMinutes': serializer.toJson<int?>(estimatedMinutes),
      'colorSeed': serializer.toJson<String?>(colorSeed),
      'sourceImportId': serializer.toJson<String?>(sourceImportId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    double? weight,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> lastSessionAt = const Value.absent(),
    double? avgGapDays,
    Value<String?> lastNote = const Value.absent(),
    Value<int?> estimatedMinutes = const Value.absent(),
    Value<String?> colorSeed = const Value.absent(),
    Value<String?> sourceImportId = const Value.absent(),
    bool? isDeleted,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    weight: weight ?? this.weight,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    lastSessionAt: lastSessionAt.present
        ? lastSessionAt.value
        : this.lastSessionAt,
    avgGapDays: avgGapDays ?? this.avgGapDays,
    lastNote: lastNote.present ? lastNote.value : this.lastNote,
    estimatedMinutes: estimatedMinutes.present
        ? estimatedMinutes.value
        : this.estimatedMinutes,
    colorSeed: colorSeed.present ? colorSeed.value : this.colorSeed,
    sourceImportId: sourceImportId.present
        ? sourceImportId.value
        : this.sourceImportId,
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
      weight: data.weight.present ? data.weight.value : this.weight,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSessionAt: data.lastSessionAt.present
          ? data.lastSessionAt.value
          : this.lastSessionAt,
      avgGapDays: data.avgGapDays.present
          ? data.avgGapDays.value
          : this.avgGapDays,
      lastNote: data.lastNote.present ? data.lastNote.value : this.lastNote,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      colorSeed: data.colorSeed.present ? data.colorSeed.value : this.colorSeed,
      sourceImportId: data.sourceImportId.present
          ? data.sourceImportId.value
          : this.sourceImportId,
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
          ..write('weight: $weight, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSessionAt: $lastSessionAt, ')
          ..write('avgGapDays: $avgGapDays, ')
          ..write('lastNote: $lastNote, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('colorSeed: $colorSeed, ')
          ..write('sourceImportId: $sourceImportId, ')
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
    weight,
    status,
    createdAt,
    lastSessionAt,
    avgGapDays,
    lastNote,
    estimatedMinutes,
    colorSeed,
    sourceImportId,
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
          other.weight == this.weight &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.lastSessionAt == this.lastSessionAt &&
          other.avgGapDays == this.avgGapDays &&
          other.lastNote == this.lastNote &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.colorSeed == this.colorSeed &&
          other.sourceImportId == this.sourceImportId &&
          other.isDeleted == this.isDeleted &&
          other.deletedAt == this.deletedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> weight;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastSessionAt;
  final Value<double> avgGapDays;
  final Value<String?> lastNote;
  final Value<int?> estimatedMinutes;
  final Value<String?> colorSeed;
  final Value<String?> sourceImportId;
  final Value<bool> isDeleted;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.weight = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSessionAt = const Value.absent(),
    this.avgGapDays = const Value.absent(),
    this.lastNote = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.colorSeed = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.weight = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.lastSessionAt = const Value.absent(),
    this.avgGapDays = const Value.absent(),
    this.lastNote = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.colorSeed = const Value.absent(),
    this.sourceImportId = const Value.absent(),
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
    Expression<double>? weight,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSessionAt,
    Expression<double>? avgGapDays,
    Expression<String>? lastNote,
    Expression<int>? estimatedMinutes,
    Expression<String>? colorSeed,
    Expression<String>? sourceImportId,
    Expression<bool>? isDeleted,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (weight != null) 'weight': weight,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSessionAt != null) 'last_session_at': lastSessionAt,
      if (avgGapDays != null) 'avg_gap_days': avgGapDays,
      if (lastNote != null) 'last_note': lastNote,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (colorSeed != null) 'color_seed': colorSeed,
      if (sourceImportId != null) 'source_import_id': sourceImportId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<double>? weight,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastSessionAt,
    Value<double>? avgGapDays,
    Value<String?>? lastNote,
    Value<int?>? estimatedMinutes,
    Value<String?>? colorSeed,
    Value<String?>? sourceImportId,
    Value<bool>? isDeleted,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastSessionAt: lastSessionAt ?? this.lastSessionAt,
      avgGapDays: avgGapDays ?? this.avgGapDays,
      lastNote: lastNote ?? this.lastNote,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      colorSeed: colorSeed ?? this.colorSeed,
      sourceImportId: sourceImportId ?? this.sourceImportId,
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
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
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
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (colorSeed.present) {
      map['color_seed'] = Variable<String>(colorSeed.value);
    }
    if (sourceImportId.present) {
      map['source_import_id'] = Variable<String>(sourceImportId.value);
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
          ..write('weight: $weight, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSessionAt: $lastSessionAt, ')
          ..write('avgGapDays: $avgGapDays, ')
          ..write('lastNote: $lastNote, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('colorSeed: $colorSeed, ')
          ..write('sourceImportId: $sourceImportId, ')
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
  static const VerificationMeta _stopReasonMeta = const VerificationMeta(
    'stopReason',
  );
  @override
  late final GeneratedColumn<String> stopReason = GeneratedColumn<String>(
    'stop_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stopNoteMeta = const VerificationMeta(
    'stopNote',
  );
  @override
  late final GeneratedColumn<String> stopNote = GeneratedColumn<String>(
    'stop_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextStepMeta = const VerificationMeta(
    'nextStep',
  );
  @override
  late final GeneratedColumn<String> nextStep = GeneratedColumn<String>(
    'next_step',
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
    stopReason,
    stopNote,
    nextStep,
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
    if (data.containsKey('stop_reason')) {
      context.handle(
        _stopReasonMeta,
        stopReason.isAcceptableOrUnknown(data['stop_reason']!, _stopReasonMeta),
      );
    }
    if (data.containsKey('stop_note')) {
      context.handle(
        _stopNoteMeta,
        stopNote.isAcceptableOrUnknown(data['stop_note']!, _stopNoteMeta),
      );
    }
    if (data.containsKey('next_step')) {
      context.handle(
        _nextStepMeta,
        nextStep.isAcceptableOrUnknown(data['next_step']!, _nextStepMeta),
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
      stopReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stop_reason'],
      ),
      stopNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stop_note'],
      ),
      nextStep: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_step'],
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
  final String? stopReason;
  final String? stopNote;
  final String? nextStep;
  const Session({
    required this.id,
    required this.projectId,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.tag,
    this.stopReason,
    this.stopNote,
    this.nextStep,
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
    if (!nullToAbsent || stopReason != null) {
      map['stop_reason'] = Variable<String>(stopReason);
    }
    if (!nullToAbsent || stopNote != null) {
      map['stop_note'] = Variable<String>(stopNote);
    }
    if (!nullToAbsent || nextStep != null) {
      map['next_step'] = Variable<String>(nextStep);
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
      stopReason: stopReason == null && nullToAbsent
          ? const Value.absent()
          : Value(stopReason),
      stopNote: stopNote == null && nullToAbsent
          ? const Value.absent()
          : Value(stopNote),
      nextStep: nextStep == null && nullToAbsent
          ? const Value.absent()
          : Value(nextStep),
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
      stopReason: serializer.fromJson<String?>(json['stopReason']),
      stopNote: serializer.fromJson<String?>(json['stopNote']),
      nextStep: serializer.fromJson<String?>(json['nextStep']),
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
      'stopReason': serializer.toJson<String?>(stopReason),
      'stopNote': serializer.toJson<String?>(stopNote),
      'nextStep': serializer.toJson<String?>(nextStep),
    };
  }

  Session copyWith({
    String? id,
    String? projectId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<String?> tag = const Value.absent(),
    Value<String?> stopReason = const Value.absent(),
    Value<String?> stopNote = const Value.absent(),
    Value<String?> nextStep = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    tag: tag.present ? tag.value : this.tag,
    stopReason: stopReason.present ? stopReason.value : this.stopReason,
    stopNote: stopNote.present ? stopNote.value : this.stopNote,
    nextStep: nextStep.present ? nextStep.value : this.nextStep,
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
      stopReason: data.stopReason.present
          ? data.stopReason.value
          : this.stopReason,
      stopNote: data.stopNote.present ? data.stopNote.value : this.stopNote,
      nextStep: data.nextStep.present ? data.nextStep.value : this.nextStep,
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
          ..write('tag: $tag, ')
          ..write('stopReason: $stopReason, ')
          ..write('stopNote: $stopNote, ')
          ..write('nextStep: $nextStep')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    startedAt,
    endedAt,
    durationSeconds,
    tag,
    stopReason,
    stopNote,
    nextStep,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.tag == this.tag &&
          other.stopReason == this.stopReason &&
          other.stopNote == this.stopNote &&
          other.nextStep == this.nextStep);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationSeconds;
  final Value<String?> tag;
  final Value<String?> stopReason;
  final Value<String?> stopNote;
  final Value<String?> nextStep;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.tag = const Value.absent(),
    this.stopReason = const Value.absent(),
    this.stopNote = const Value.absent(),
    this.nextStep = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String projectId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.tag = const Value.absent(),
    this.stopReason = const Value.absent(),
    this.stopNote = const Value.absent(),
    this.nextStep = const Value.absent(),
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
    Expression<String>? stopReason,
    Expression<String>? stopNote,
    Expression<String>? nextStep,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (tag != null) 'tag': tag,
      if (stopReason != null) 'stop_reason': stopReason,
      if (stopNote != null) 'stop_note': stopNote,
      if (nextStep != null) 'next_step': nextStep,
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
    Value<String?>? stopReason,
    Value<String?>? stopNote,
    Value<String?>? nextStep,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      tag: tag ?? this.tag,
      stopReason: stopReason ?? this.stopReason,
      stopNote: stopNote ?? this.stopNote,
      nextStep: nextStep ?? this.nextStep,
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
    if (stopReason.present) {
      map['stop_reason'] = Variable<String>(stopReason.value);
    }
    if (stopNote.present) {
      map['stop_note'] = Variable<String>(stopNote.value);
    }
    if (nextStep.present) {
      map['next_step'] = Variable<String>(nextStep.value);
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
          ..write('stopReason: $stopReason, ')
          ..write('stopNote: $stopNote, ')
          ..write('nextStep: $nextStep, ')
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
    description,
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
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
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
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
  final String? description;
  final String? projectId;
  final DateTime createdAt;
  final String status;
  final String? promotedToProjectId;
  final String? sourceImportId;
  const Idea({
    required this.id,
    required this.content,
    this.description,
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
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
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
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
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
      description: serializer.fromJson<String?>(json['description']),
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
      'description': serializer.toJson<String?>(description),
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
    Value<String?> description = const Value.absent(),
    Value<String?> projectId = const Value.absent(),
    DateTime? createdAt,
    String? status,
    Value<String?> promotedToProjectId = const Value.absent(),
    Value<String?> sourceImportId = const Value.absent(),
  }) => Idea(
    id: id ?? this.id,
    content: content ?? this.content,
    description: description.present ? description.value : this.description,
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
      description: data.description.present
          ? data.description.value
          : this.description,
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
          ..write('description: $description, ')
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
    description,
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
          other.description == this.description &&
          other.projectId == this.projectId &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.promotedToProjectId == this.promotedToProjectId &&
          other.sourceImportId == this.sourceImportId);
}

class IdeasCompanion extends UpdateCompanion<Idea> {
  final Value<String> id;
  final Value<String> content;
  final Value<String?> description;
  final Value<String?> projectId;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<String?> promotedToProjectId;
  final Value<String?> sourceImportId;
  final Value<int> rowid;
  const IdeasCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.description = const Value.absent(),
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
    this.description = const Value.absent(),
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
    Expression<String>? description,
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
      if (description != null) 'description': description,
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
    Value<String?>? description,
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
      description: description ?? this.description,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
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
          ..write('description: $description, ')
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

class $ExecutionPhasesTable extends ExecutionPhases
    with TableInfo<$ExecutionPhasesTable, ExecutionPhase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExecutionPhasesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('upcoming'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    order,
    name,
    summary,
    status,
    startedAt,
    doneAt,
    sourceImportId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'execution_phases';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExecutionPhase> instance, {
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
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
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
  ExecutionPhase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExecutionPhase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
      sourceImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_import_id'],
      ),
    );
  }

  @override
  $ExecutionPhasesTable createAlias(String alias) {
    return $ExecutionPhasesTable(attachedDatabase, alias);
  }
}

class ExecutionPhase extends DataClass implements Insertable<ExecutionPhase> {
  final String id;
  final String projectId;
  final int order;
  final String name;
  final String? summary;
  final String status;
  final DateTime? startedAt;
  final DateTime? doneAt;
  final String? sourceImportId;
  const ExecutionPhase({
    required this.id,
    required this.projectId,
    required this.order,
    required this.name,
    this.summary,
    required this.status,
    this.startedAt,
    this.doneAt,
    this.sourceImportId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['order'] = Variable<int>(order);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    if (!nullToAbsent || sourceImportId != null) {
      map['source_import_id'] = Variable<String>(sourceImportId);
    }
    return map;
  }

  ExecutionPhasesCompanion toCompanion(bool nullToAbsent) {
    return ExecutionPhasesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      order: Value(order),
      name: Value(name),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      status: Value(status),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      sourceImportId: sourceImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImportId),
    );
  }

  factory ExecutionPhase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExecutionPhase(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      order: serializer.fromJson<int>(json['order']),
      name: serializer.fromJson<String>(json['name']),
      summary: serializer.fromJson<String?>(json['summary']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
      sourceImportId: serializer.fromJson<String?>(json['sourceImportId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'order': serializer.toJson<int>(order),
      'name': serializer.toJson<String>(name),
      'summary': serializer.toJson<String?>(summary),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
      'sourceImportId': serializer.toJson<String?>(sourceImportId),
    };
  }

  ExecutionPhase copyWith({
    String? id,
    String? projectId,
    int? order,
    String? name,
    Value<String?> summary = const Value.absent(),
    String? status,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> doneAt = const Value.absent(),
    Value<String?> sourceImportId = const Value.absent(),
  }) => ExecutionPhase(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    order: order ?? this.order,
    name: name ?? this.name,
    summary: summary.present ? summary.value : this.summary,
    status: status ?? this.status,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    sourceImportId: sourceImportId.present
        ? sourceImportId.value
        : this.sourceImportId,
  );
  ExecutionPhase copyWithCompanion(ExecutionPhasesCompanion data) {
    return ExecutionPhase(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      order: data.order.present ? data.order.value : this.order,
      name: data.name.present ? data.name.value : this.name,
      summary: data.summary.present ? data.summary.value : this.summary,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      sourceImportId: data.sourceImportId.present
          ? data.sourceImportId.value
          : this.sourceImportId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExecutionPhase(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('order: $order, ')
          ..write('name: $name, ')
          ..write('summary: $summary, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('doneAt: $doneAt, ')
          ..write('sourceImportId: $sourceImportId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    order,
    name,
    summary,
    status,
    startedAt,
    doneAt,
    sourceImportId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExecutionPhase &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.order == this.order &&
          other.name == this.name &&
          other.summary == this.summary &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.doneAt == this.doneAt &&
          other.sourceImportId == this.sourceImportId);
}

class ExecutionPhasesCompanion extends UpdateCompanion<ExecutionPhase> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<int> order;
  final Value<String> name;
  final Value<String?> summary;
  final Value<String> status;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> doneAt;
  final Value<String?> sourceImportId;
  final Value<int> rowid;
  const ExecutionPhasesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.order = const Value.absent(),
    this.name = const Value.absent(),
    this.summary = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExecutionPhasesCompanion.insert({
    required String id,
    required String projectId,
    required int order,
    required String name,
    this.summary = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       order = Value(order),
       name = Value(name);
  static Insertable<ExecutionPhase> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<int>? order,
    Expression<String>? name,
    Expression<String>? summary,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? doneAt,
    Expression<String>? sourceImportId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (order != null) 'order': order,
      if (name != null) 'name': name,
      if (summary != null) 'summary': summary,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (doneAt != null) 'done_at': doneAt,
      if (sourceImportId != null) 'source_import_id': sourceImportId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExecutionPhasesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<int>? order,
    Value<String>? name,
    Value<String?>? summary,
    Value<String>? status,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? doneAt,
    Value<String?>? sourceImportId,
    Value<int>? rowid,
  }) {
    return ExecutionPhasesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      order: order ?? this.order,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      doneAt: doneAt ?? this.doneAt,
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
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
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
    return (StringBuffer('ExecutionPhasesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('order: $order, ')
          ..write('name: $name, ')
          ..write('summary: $summary, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('doneAt: $doneAt, ')
          ..write('sourceImportId: $sourceImportId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearningGoalsTable extends LearningGoals
    with TableInfo<$LearningGoalsTable, LearningGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningGoalsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
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
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    topic,
    description,
    isDone,
    doneAt,
    sourceImportId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningGoal> instance, {
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
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
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
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
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
  LearningGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
      sourceImportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_import_id'],
      ),
    );
  }

  @override
  $LearningGoalsTable createAlias(String alias) {
    return $LearningGoalsTable(attachedDatabase, alias);
  }
}

class LearningGoal extends DataClass implements Insertable<LearningGoal> {
  final String id;
  final String projectId;
  final String topic;
  final String? description;
  final bool isDone;
  final DateTime? doneAt;
  final String? sourceImportId;
  const LearningGoal({
    required this.id,
    required this.projectId,
    required this.topic,
    this.description,
    required this.isDone,
    this.doneAt,
    this.sourceImportId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['topic'] = Variable<String>(topic);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_done'] = Variable<bool>(isDone);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    if (!nullToAbsent || sourceImportId != null) {
      map['source_import_id'] = Variable<String>(sourceImportId);
    }
    return map;
  }

  LearningGoalsCompanion toCompanion(bool nullToAbsent) {
    return LearningGoalsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      topic: Value(topic),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isDone: Value(isDone),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      sourceImportId: sourceImportId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceImportId),
    );
  }

  factory LearningGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningGoal(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      topic: serializer.fromJson<String>(json['topic']),
      description: serializer.fromJson<String?>(json['description']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
      sourceImportId: serializer.fromJson<String?>(json['sourceImportId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'topic': serializer.toJson<String>(topic),
      'description': serializer.toJson<String?>(description),
      'isDone': serializer.toJson<bool>(isDone),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
      'sourceImportId': serializer.toJson<String?>(sourceImportId),
    };
  }

  LearningGoal copyWith({
    String? id,
    String? projectId,
    String? topic,
    Value<String?> description = const Value.absent(),
    bool? isDone,
    Value<DateTime?> doneAt = const Value.absent(),
    Value<String?> sourceImportId = const Value.absent(),
  }) => LearningGoal(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    topic: topic ?? this.topic,
    description: description.present ? description.value : this.description,
    isDone: isDone ?? this.isDone,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    sourceImportId: sourceImportId.present
        ? sourceImportId.value
        : this.sourceImportId,
  );
  LearningGoal copyWithCompanion(LearningGoalsCompanion data) {
    return LearningGoal(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      topic: data.topic.present ? data.topic.value : this.topic,
      description: data.description.present
          ? data.description.value
          : this.description,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      sourceImportId: data.sourceImportId.present
          ? data.sourceImportId.value
          : this.sourceImportId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningGoal(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('topic: $topic, ')
          ..write('description: $description, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt, ')
          ..write('sourceImportId: $sourceImportId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    topic,
    description,
    isDone,
    doneAt,
    sourceImportId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningGoal &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.topic == this.topic &&
          other.description == this.description &&
          other.isDone == this.isDone &&
          other.doneAt == this.doneAt &&
          other.sourceImportId == this.sourceImportId);
}

class LearningGoalsCompanion extends UpdateCompanion<LearningGoal> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> topic;
  final Value<String?> description;
  final Value<bool> isDone;
  final Value<DateTime?> doneAt;
  final Value<String?> sourceImportId;
  final Value<int> rowid;
  const LearningGoalsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.topic = const Value.absent(),
    this.description = const Value.absent(),
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearningGoalsCompanion.insert({
    required String id,
    required String projectId,
    required String topic,
    this.description = const Value.absent(),
    this.isDone = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.sourceImportId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       topic = Value(topic);
  static Insertable<LearningGoal> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? topic,
    Expression<String>? description,
    Expression<bool>? isDone,
    Expression<DateTime>? doneAt,
    Expression<String>? sourceImportId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (topic != null) 'topic': topic,
      if (description != null) 'description': description,
      if (isDone != null) 'is_done': isDone,
      if (doneAt != null) 'done_at': doneAt,
      if (sourceImportId != null) 'source_import_id': sourceImportId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearningGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? topic,
    Value<String?>? description,
    Value<bool>? isDone,
    Value<DateTime?>? doneAt,
    Value<String?>? sourceImportId,
    Value<int>? rowid,
  }) {
    return LearningGoalsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      doneAt: doneAt ?? this.doneAt,
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
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
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
    return (StringBuffer('LearningGoalsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('topic: $topic, ')
          ..write('description: $description, ')
          ..write('isDone: $isDone, ')
          ..write('doneAt: $doneAt, ')
          ..write('sourceImportId: $sourceImportId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeadTimesTable extends DeadTimes
    with TableInfo<$DeadTimesTable, DeadTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeadTimesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fromDateMeta = const VerificationMeta(
    'fromDate',
  );
  @override
  late final GeneratedColumn<DateTime> fromDate = GeneratedColumn<DateTime>(
    'from_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toDateMeta = const VerificationMeta('toDate');
  @override
  late final GeneratedColumn<DateTime> toDate = GeneratedColumn<DateTime>(
    'to_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    fromDate,
    toDate,
    reason,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dead_times';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeadTime> instance, {
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
    if (data.containsKey('from_date')) {
      context.handle(
        _fromDateMeta,
        fromDate.isAcceptableOrUnknown(data['from_date']!, _fromDateMeta),
      );
    } else if (isInserting) {
      context.missing(_fromDateMeta);
    }
    if (data.containsKey('to_date')) {
      context.handle(
        _toDateMeta,
        toDate.isAcceptableOrUnknown(data['to_date']!, _toDateMeta),
      );
    } else if (isInserting) {
      context.missing(_toDateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeadTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeadTime(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      fromDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}from_date'],
      )!,
      toDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}to_date'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $DeadTimesTable createAlias(String alias) {
    return $DeadTimesTable(attachedDatabase, alias);
  }
}

class DeadTime extends DataClass implements Insertable<DeadTime> {
  final String id;
  final String projectId;
  final DateTime fromDate;
  final DateTime toDate;
  final String? reason;
  final String? note;
  const DeadTime({
    required this.id,
    required this.projectId,
    required this.fromDate,
    required this.toDate,
    this.reason,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['from_date'] = Variable<DateTime>(fromDate);
    map['to_date'] = Variable<DateTime>(toDate);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  DeadTimesCompanion toCompanion(bool nullToAbsent) {
    return DeadTimesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      fromDate: Value(fromDate),
      toDate: Value(toDate),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory DeadTime.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeadTime(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      fromDate: serializer.fromJson<DateTime>(json['fromDate']),
      toDate: serializer.fromJson<DateTime>(json['toDate']),
      reason: serializer.fromJson<String?>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'fromDate': serializer.toJson<DateTime>(fromDate),
      'toDate': serializer.toJson<DateTime>(toDate),
      'reason': serializer.toJson<String?>(reason),
      'note': serializer.toJson<String?>(note),
    };
  }

  DeadTime copyWith({
    String? id,
    String? projectId,
    DateTime? fromDate,
    DateTime? toDate,
    Value<String?> reason = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => DeadTime(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    fromDate: fromDate ?? this.fromDate,
    toDate: toDate ?? this.toDate,
    reason: reason.present ? reason.value : this.reason,
    note: note.present ? note.value : this.note,
  );
  DeadTime copyWithCompanion(DeadTimesCompanion data) {
    return DeadTime(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      fromDate: data.fromDate.present ? data.fromDate.value : this.fromDate,
      toDate: data.toDate.present ? data.toDate.value : this.toDate,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeadTime(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('reason: $reason, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, fromDate, toDate, reason, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeadTime &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.fromDate == this.fromDate &&
          other.toDate == this.toDate &&
          other.reason == this.reason &&
          other.note == this.note);
}

class DeadTimesCompanion extends UpdateCompanion<DeadTime> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<DateTime> fromDate;
  final Value<DateTime> toDate;
  final Value<String?> reason;
  final Value<String?> note;
  final Value<int> rowid;
  const DeadTimesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.fromDate = const Value.absent(),
    this.toDate = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeadTimesCompanion.insert({
    required String id,
    required String projectId,
    required DateTime fromDate,
    required DateTime toDate,
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       fromDate = Value(fromDate),
       toDate = Value(toDate);
  static Insertable<DeadTime> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<DateTime>? fromDate,
    Expression<DateTime>? toDate,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeadTimesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<DateTime>? fromDate,
    Value<DateTime>? toDate,
    Value<String?>? reason,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return DeadTimesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      reason: reason ?? this.reason,
      note: note ?? this.note,
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
    if (fromDate.present) {
      map['from_date'] = Variable<DateTime>(fromDate.value);
    }
    if (toDate.present) {
      map['to_date'] = Variable<DateTime>(toDate.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeadTimesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('fromDate: $fromDate, ')
          ..write('toDate: $toDate, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PauseLogsTable extends PauseLogs
    with TableInfo<$PauseLogsTable, PauseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PauseLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedPauseDaysMeta = const VerificationMeta(
    'plannedPauseDays',
  );
  @override
  late final GeneratedColumn<int> plannedPauseDays = GeneratedColumn<int>(
    'planned_pause_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    action,
    timestamp,
    reason,
    plannedPauseDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pause_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PauseLog> instance, {
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
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('planned_pause_days')) {
      context.handle(
        _plannedPauseDaysMeta,
        plannedPauseDays.isAcceptableOrUnknown(
          data['planned_pause_days']!,
          _plannedPauseDaysMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PauseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PauseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      plannedPauseDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_pause_days'],
      ),
    );
  }

  @override
  $PauseLogsTable createAlias(String alias) {
    return $PauseLogsTable(attachedDatabase, alias);
  }
}

class PauseLog extends DataClass implements Insertable<PauseLog> {
  final String id;
  final String projectId;
  final String action;
  final DateTime timestamp;
  final String? reason;
  final int? plannedPauseDays;
  const PauseLog({
    required this.id,
    required this.projectId,
    required this.action,
    required this.timestamp,
    this.reason,
    this.plannedPauseDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['action'] = Variable<String>(action);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || plannedPauseDays != null) {
      map['planned_pause_days'] = Variable<int>(plannedPauseDays);
    }
    return map;
  }

  PauseLogsCompanion toCompanion(bool nullToAbsent) {
    return PauseLogsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      action: Value(action),
      timestamp: Value(timestamp),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      plannedPauseDays: plannedPauseDays == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedPauseDays),
    );
  }

  factory PauseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PauseLog(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      action: serializer.fromJson<String>(json['action']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      reason: serializer.fromJson<String?>(json['reason']),
      plannedPauseDays: serializer.fromJson<int?>(json['plannedPauseDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'action': serializer.toJson<String>(action),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'reason': serializer.toJson<String?>(reason),
      'plannedPauseDays': serializer.toJson<int?>(plannedPauseDays),
    };
  }

  PauseLog copyWith({
    String? id,
    String? projectId,
    String? action,
    DateTime? timestamp,
    Value<String?> reason = const Value.absent(),
    Value<int?> plannedPauseDays = const Value.absent(),
  }) => PauseLog(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    action: action ?? this.action,
    timestamp: timestamp ?? this.timestamp,
    reason: reason.present ? reason.value : this.reason,
    plannedPauseDays: plannedPauseDays.present
        ? plannedPauseDays.value
        : this.plannedPauseDays,
  );
  PauseLog copyWithCompanion(PauseLogsCompanion data) {
    return PauseLog(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      action: data.action.present ? data.action.value : this.action,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      reason: data.reason.present ? data.reason.value : this.reason,
      plannedPauseDays: data.plannedPauseDays.present
          ? data.plannedPauseDays.value
          : this.plannedPauseDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PauseLog(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('action: $action, ')
          ..write('timestamp: $timestamp, ')
          ..write('reason: $reason, ')
          ..write('plannedPauseDays: $plannedPauseDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, action, timestamp, reason, plannedPauseDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PauseLog &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.action == this.action &&
          other.timestamp == this.timestamp &&
          other.reason == this.reason &&
          other.plannedPauseDays == this.plannedPauseDays);
}

class PauseLogsCompanion extends UpdateCompanion<PauseLog> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> action;
  final Value<DateTime> timestamp;
  final Value<String?> reason;
  final Value<int?> plannedPauseDays;
  final Value<int> rowid;
  const PauseLogsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.action = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.reason = const Value.absent(),
    this.plannedPauseDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PauseLogsCompanion.insert({
    required String id,
    required String projectId,
    required String action,
    required DateTime timestamp,
    this.reason = const Value.absent(),
    this.plannedPauseDays = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       action = Value(action),
       timestamp = Value(timestamp);
  static Insertable<PauseLog> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? action,
    Expression<DateTime>? timestamp,
    Expression<String>? reason,
    Expression<int>? plannedPauseDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (action != null) 'action': action,
      if (timestamp != null) 'timestamp': timestamp,
      if (reason != null) 'reason': reason,
      if (plannedPauseDays != null) 'planned_pause_days': plannedPauseDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PauseLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? action,
    Value<DateTime>? timestamp,
    Value<String?>? reason,
    Value<int?>? plannedPauseDays,
    Value<int>? rowid,
  }) {
    return PauseLogsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      reason: reason ?? this.reason,
      plannedPauseDays: plannedPauseDays ?? this.plannedPauseDays,
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
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (plannedPauseDays.present) {
      map['planned_pause_days'] = Variable<int>(plannedPauseDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PauseLogsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('action: $action, ')
          ..write('timestamp: $timestamp, ')
          ..write('reason: $reason, ')
          ..write('plannedPauseDays: $plannedPauseDays, ')
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
  late final $ExecutionPhasesTable executionPhases = $ExecutionPhasesTable(
    this,
  );
  late final $LearningGoalsTable learningGoals = $LearningGoalsTable(this);
  late final $DeadTimesTable deadTimes = $DeadTimesTable(this);
  late final $PauseLogsTable pauseLogs = $PauseLogsTable(this);
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
    executionPhases,
    learningGoals,
    deadTimes,
    pauseLogs,
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
      result: [TableUpdate('execution_phases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('learning_goals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dead_times', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pause_logs', kind: UpdateKind.delete)],
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
      Value<double> weight,
      Value<String> status,
      required DateTime createdAt,
      Value<DateTime?> lastSessionAt,
      Value<double> avgGapDays,
      Value<String?> lastNote,
      Value<int?> estimatedMinutes,
      Value<String?> colorSeed,
      Value<String?> sourceImportId,
      Value<bool> isDeleted,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<double> weight,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSessionAt,
      Value<double> avgGapDays,
      Value<String?> lastNote,
      Value<int?> estimatedMinutes,
      Value<String?> colorSeed,
      Value<String?> sourceImportId,
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

  static MultiTypedResultKey<$ExecutionPhasesTable, List<ExecutionPhase>>
  _executionPhasesRefsTable(_$PulseDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.executionPhases,
        aliasName: $_aliasNameGenerator(
          db.projects.id,
          db.executionPhases.projectId,
        ),
      );

  $$ExecutionPhasesTableProcessedTableManager get executionPhasesRefs {
    final manager = $$ExecutionPhasesTableTableManager(
      $_db,
      $_db.executionPhases,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _executionPhasesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LearningGoalsTable, List<LearningGoal>>
  _learningGoalsRefsTable(_$PulseDatabase db) => MultiTypedResultKey.fromTable(
    db.learningGoals,
    aliasName: $_aliasNameGenerator(db.projects.id, db.learningGoals.projectId),
  );

  $$LearningGoalsTableProcessedTableManager get learningGoalsRefs {
    final manager = $$LearningGoalsTableTableManager(
      $_db,
      $_db.learningGoals,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_learningGoalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeadTimesTable, List<DeadTime>>
  _deadTimesRefsTable(_$PulseDatabase db) => MultiTypedResultKey.fromTable(
    db.deadTimes,
    aliasName: $_aliasNameGenerator(db.projects.id, db.deadTimes.projectId),
  );

  $$DeadTimesTableProcessedTableManager get deadTimesRefs {
    final manager = $$DeadTimesTableTableManager(
      $_db,
      $_db.deadTimes,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deadTimesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PauseLogsTable, List<PauseLog>>
  _pauseLogsRefsTable(_$PulseDatabase db) => MultiTypedResultKey.fromTable(
    db.pauseLogs,
    aliasName: $_aliasNameGenerator(db.projects.id, db.pauseLogs.projectId),
  );

  $$PauseLogsTableProcessedTableManager get pauseLogsRefs {
    final manager = $$PauseLogsTableTableManager(
      $_db,
      $_db.pauseLogs,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pauseLogsRefsTable($_db));
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

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
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

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorSeed => $composableBuilder(
    column: $table.colorSeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
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

  Expression<bool> executionPhasesRefs(
    Expression<bool> Function($$ExecutionPhasesTableFilterComposer f) f,
  ) {
    final $$ExecutionPhasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.executionPhases,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionPhasesTableFilterComposer(
            $db: $db,
            $table: $db.executionPhases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> learningGoalsRefs(
    Expression<bool> Function($$LearningGoalsTableFilterComposer f) f,
  ) {
    final $$LearningGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningGoals,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningGoalsTableFilterComposer(
            $db: $db,
            $table: $db.learningGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deadTimesRefs(
    Expression<bool> Function($$DeadTimesTableFilterComposer f) f,
  ) {
    final $$DeadTimesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deadTimes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadTimesTableFilterComposer(
            $db: $db,
            $table: $db.deadTimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pauseLogsRefs(
    Expression<bool> Function($$PauseLogsTableFilterComposer f) f,
  ) {
    final $$PauseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pauseLogs,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PauseLogsTableFilterComposer(
            $db: $db,
            $table: $db.pauseLogs,
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

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
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

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorSeed => $composableBuilder(
    column: $table.colorSeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
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

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

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

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorSeed =>
      $composableBuilder(column: $table.colorSeed, builder: (column) => column);

  GeneratedColumn<String> get sourceImportId => $composableBuilder(
    column: $table.sourceImportId,
    builder: (column) => column,
  );

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

  Expression<T> executionPhasesRefs<T extends Object>(
    Expression<T> Function($$ExecutionPhasesTableAnnotationComposer a) f,
  ) {
    final $$ExecutionPhasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.executionPhases,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutionPhasesTableAnnotationComposer(
            $db: $db,
            $table: $db.executionPhases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> learningGoalsRefs<T extends Object>(
    Expression<T> Function($$LearningGoalsTableAnnotationComposer a) f,
  ) {
    final $$LearningGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.learningGoals,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LearningGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.learningGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deadTimesRefs<T extends Object>(
    Expression<T> Function($$DeadTimesTableAnnotationComposer a) f,
  ) {
    final $$DeadTimesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deadTimes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeadTimesTableAnnotationComposer(
            $db: $db,
            $table: $db.deadTimes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pauseLogsRefs<T extends Object>(
    Expression<T> Function($$PauseLogsTableAnnotationComposer a) f,
  ) {
    final $$PauseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pauseLogs,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PauseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.pauseLogs,
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
          PrefetchHooks Function({
            bool sessionsRefs,
            bool executionPhasesRefs,
            bool learningGoalsRefs,
            bool deadTimesRefs,
            bool pauseLogsRefs,
            bool decayLogsRefs,
          })
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
                Value<double> weight = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSessionAt = const Value.absent(),
                Value<double> avgGapDays = const Value.absent(),
                Value<String?> lastNote = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<String?> colorSeed = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                description: description,
                weight: weight,
                status: status,
                createdAt: createdAt,
                lastSessionAt: lastSessionAt,
                avgGapDays: avgGapDays,
                lastNote: lastNote,
                estimatedMinutes: estimatedMinutes,
                colorSeed: colorSeed,
                sourceImportId: sourceImportId,
                isDeleted: isDeleted,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastSessionAt = const Value.absent(),
                Value<double> avgGapDays = const Value.absent(),
                Value<String?> lastNote = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<String?> colorSeed = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                description: description,
                weight: weight,
                status: status,
                createdAt: createdAt,
                lastSessionAt: lastSessionAt,
                avgGapDays: avgGapDays,
                lastNote: lastNote,
                estimatedMinutes: estimatedMinutes,
                colorSeed: colorSeed,
                sourceImportId: sourceImportId,
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
              ({
                sessionsRefs = false,
                executionPhasesRefs = false,
                learningGoalsRefs = false,
                deadTimesRefs = false,
                pauseLogsRefs = false,
                decayLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionsRefs) db.sessions,
                    if (executionPhasesRefs) db.executionPhases,
                    if (learningGoalsRefs) db.learningGoals,
                    if (deadTimesRefs) db.deadTimes,
                    if (pauseLogsRefs) db.pauseLogs,
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
                      if (executionPhasesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          ExecutionPhase
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._executionPhasesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).executionPhasesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (learningGoalsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          LearningGoal
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._learningGoalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).learningGoalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (deadTimesRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          DeadTime
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._deadTimesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).deadTimesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pauseLogsRefs)
                        await $_getPrefetchedData<
                          Project,
                          $ProjectsTable,
                          PauseLog
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._pauseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).pauseLogsRefs,
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
      PrefetchHooks Function({
        bool sessionsRefs,
        bool executionPhasesRefs,
        bool learningGoalsRefs,
        bool deadTimesRefs,
        bool pauseLogsRefs,
        bool decayLogsRefs,
      })
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String projectId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<String?> tag,
      Value<String?> stopReason,
      Value<String?> stopNote,
      Value<String?> nextStep,
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
      Value<String?> stopReason,
      Value<String?> stopNote,
      Value<String?> nextStep,
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

  ColumnFilters<String> get stopReason => $composableBuilder(
    column: $table.stopReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stopNote => $composableBuilder(
    column: $table.stopNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextStep => $composableBuilder(
    column: $table.nextStep,
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

  ColumnOrderings<String> get stopReason => $composableBuilder(
    column: $table.stopReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stopNote => $composableBuilder(
    column: $table.stopNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextStep => $composableBuilder(
    column: $table.nextStep,
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

  GeneratedColumn<String> get stopReason => $composableBuilder(
    column: $table.stopReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stopNote =>
      $composableBuilder(column: $table.stopNote, builder: (column) => column);

  GeneratedColumn<String> get nextStep =>
      $composableBuilder(column: $table.nextStep, builder: (column) => column);

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
                Value<String?> stopReason = const Value.absent(),
                Value<String?> stopNote = const Value.absent(),
                Value<String?> nextStep = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                tag: tag,
                stopReason: stopReason,
                stopNote: stopNote,
                nextStep: nextStep,
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
                Value<String?> stopReason = const Value.absent(),
                Value<String?> stopNote = const Value.absent(),
                Value<String?> nextStep = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                tag: tag,
                stopReason: stopReason,
                stopNote: stopNote,
                nextStep: nextStep,
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
      Value<String?> description,
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
      Value<String?> description,
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

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
                Value<String?> description = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> promotedToProjectId = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion(
                id: id,
                content: content,
                description: description,
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
                Value<String?> description = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                required DateTime createdAt,
                Value<String> status = const Value.absent(),
                Value<String?> promotedToProjectId = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IdeasCompanion.insert(
                id: id,
                content: content,
                description: description,
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
typedef $$ExecutionPhasesTableCreateCompanionBuilder =
    ExecutionPhasesCompanion Function({
      required String id,
      required String projectId,
      required int order,
      required String name,
      Value<String?> summary,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> doneAt,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });
typedef $$ExecutionPhasesTableUpdateCompanionBuilder =
    ExecutionPhasesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<int> order,
      Value<String> name,
      Value<String?> summary,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> doneAt,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });

final class $$ExecutionPhasesTableReferences
    extends
        BaseReferences<_$PulseDatabase, $ExecutionPhasesTable, ExecutionPhase> {
  $$ExecutionPhasesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.executionPhases.projectId, db.projects.id),
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

class $$ExecutionPhasesTableFilterComposer
    extends Composer<_$PulseDatabase, $ExecutionPhasesTable> {
  $$ExecutionPhasesTableFilterComposer({
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

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
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
}

class $$ExecutionPhasesTableOrderingComposer
    extends Composer<_$PulseDatabase, $ExecutionPhasesTable> {
  $$ExecutionPhasesTableOrderingComposer({
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

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
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
}

class $$ExecutionPhasesTableAnnotationComposer
    extends Composer<_$PulseDatabase, $ExecutionPhasesTable> {
  $$ExecutionPhasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

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
}

class $$ExecutionPhasesTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $ExecutionPhasesTable,
          ExecutionPhase,
          $$ExecutionPhasesTableFilterComposer,
          $$ExecutionPhasesTableOrderingComposer,
          $$ExecutionPhasesTableAnnotationComposer,
          $$ExecutionPhasesTableCreateCompanionBuilder,
          $$ExecutionPhasesTableUpdateCompanionBuilder,
          (ExecutionPhase, $$ExecutionPhasesTableReferences),
          ExecutionPhase,
          PrefetchHooks Function({bool projectId})
        > {
  $$ExecutionPhasesTableTableManager(
    _$PulseDatabase db,
    $ExecutionPhasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExecutionPhasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExecutionPhasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExecutionPhasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExecutionPhasesCompanion(
                id: id,
                projectId: projectId,
                order: order,
                name: name,
                summary: summary,
                status: status,
                startedAt: startedAt,
                doneAt: doneAt,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required int order,
                required String name,
                Value<String?> summary = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExecutionPhasesCompanion.insert(
                id: id,
                projectId: projectId,
                order: order,
                name: name,
                summary: summary,
                status: status,
                startedAt: startedAt,
                doneAt: doneAt,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExecutionPhasesTableReferences(db, table, e),
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
                                referencedTable:
                                    $$ExecutionPhasesTableReferences
                                        ._projectIdTable(db),
                                referencedColumn:
                                    $$ExecutionPhasesTableReferences
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

typedef $$ExecutionPhasesTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $ExecutionPhasesTable,
      ExecutionPhase,
      $$ExecutionPhasesTableFilterComposer,
      $$ExecutionPhasesTableOrderingComposer,
      $$ExecutionPhasesTableAnnotationComposer,
      $$ExecutionPhasesTableCreateCompanionBuilder,
      $$ExecutionPhasesTableUpdateCompanionBuilder,
      (ExecutionPhase, $$ExecutionPhasesTableReferences),
      ExecutionPhase,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$LearningGoalsTableCreateCompanionBuilder =
    LearningGoalsCompanion Function({
      required String id,
      required String projectId,
      required String topic,
      Value<String?> description,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });
typedef $$LearningGoalsTableUpdateCompanionBuilder =
    LearningGoalsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> topic,
      Value<String?> description,
      Value<bool> isDone,
      Value<DateTime?> doneAt,
      Value<String?> sourceImportId,
      Value<int> rowid,
    });

final class $$LearningGoalsTableReferences
    extends BaseReferences<_$PulseDatabase, $LearningGoalsTable, LearningGoal> {
  $$LearningGoalsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.learningGoals.projectId, db.projects.id),
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

class $$LearningGoalsTableFilterComposer
    extends Composer<_$PulseDatabase, $LearningGoalsTable> {
  $$LearningGoalsTableFilterComposer({
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

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
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
}

class $$LearningGoalsTableOrderingComposer
    extends Composer<_$PulseDatabase, $LearningGoalsTable> {
  $$LearningGoalsTableOrderingComposer({
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

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
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
}

class $$LearningGoalsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $LearningGoalsTable> {
  $$LearningGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

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
}

class $$LearningGoalsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $LearningGoalsTable,
          LearningGoal,
          $$LearningGoalsTableFilterComposer,
          $$LearningGoalsTableOrderingComposer,
          $$LearningGoalsTableAnnotationComposer,
          $$LearningGoalsTableCreateCompanionBuilder,
          $$LearningGoalsTableUpdateCompanionBuilder,
          (LearningGoal, $$LearningGoalsTableReferences),
          LearningGoal,
          PrefetchHooks Function({bool projectId})
        > {
  $$LearningGoalsTableTableManager(
    _$PulseDatabase db,
    $LearningGoalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningGoalsCompanion(
                id: id,
                projectId: projectId,
                topic: topic,
                description: description,
                isDone: isDone,
                doneAt: doneAt,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String topic,
                Value<String?> description = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
                Value<String?> sourceImportId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearningGoalsCompanion.insert(
                id: id,
                projectId: projectId,
                topic: topic,
                description: description,
                isDone: isDone,
                doneAt: doneAt,
                sourceImportId: sourceImportId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LearningGoalsTableReferences(db, table, e),
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
                                referencedTable: $$LearningGoalsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$LearningGoalsTableReferences
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

typedef $$LearningGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $LearningGoalsTable,
      LearningGoal,
      $$LearningGoalsTableFilterComposer,
      $$LearningGoalsTableOrderingComposer,
      $$LearningGoalsTableAnnotationComposer,
      $$LearningGoalsTableCreateCompanionBuilder,
      $$LearningGoalsTableUpdateCompanionBuilder,
      (LearningGoal, $$LearningGoalsTableReferences),
      LearningGoal,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$DeadTimesTableCreateCompanionBuilder =
    DeadTimesCompanion Function({
      required String id,
      required String projectId,
      required DateTime fromDate,
      required DateTime toDate,
      Value<String?> reason,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$DeadTimesTableUpdateCompanionBuilder =
    DeadTimesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<DateTime> fromDate,
      Value<DateTime> toDate,
      Value<String?> reason,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$DeadTimesTableReferences
    extends BaseReferences<_$PulseDatabase, $DeadTimesTable, DeadTime> {
  $$DeadTimesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.deadTimes.projectId, db.projects.id),
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

class $$DeadTimesTableFilterComposer
    extends Composer<_$PulseDatabase, $DeadTimesTable> {
  $$DeadTimesTableFilterComposer({
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

  ColumnFilters<DateTime> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

class $$DeadTimesTableOrderingComposer
    extends Composer<_$PulseDatabase, $DeadTimesTable> {
  $$DeadTimesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get fromDate => $composableBuilder(
    column: $table.fromDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get toDate => $composableBuilder(
    column: $table.toDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

class $$DeadTimesTableAnnotationComposer
    extends Composer<_$PulseDatabase, $DeadTimesTable> {
  $$DeadTimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fromDate =>
      $composableBuilder(column: $table.fromDate, builder: (column) => column);

  GeneratedColumn<DateTime> get toDate =>
      $composableBuilder(column: $table.toDate, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

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

class $$DeadTimesTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $DeadTimesTable,
          DeadTime,
          $$DeadTimesTableFilterComposer,
          $$DeadTimesTableOrderingComposer,
          $$DeadTimesTableAnnotationComposer,
          $$DeadTimesTableCreateCompanionBuilder,
          $$DeadTimesTableUpdateCompanionBuilder,
          (DeadTime, $$DeadTimesTableReferences),
          DeadTime,
          PrefetchHooks Function({bool projectId})
        > {
  $$DeadTimesTableTableManager(_$PulseDatabase db, $DeadTimesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeadTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeadTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeadTimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<DateTime> fromDate = const Value.absent(),
                Value<DateTime> toDate = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeadTimesCompanion(
                id: id,
                projectId: projectId,
                fromDate: fromDate,
                toDate: toDate,
                reason: reason,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required DateTime fromDate,
                required DateTime toDate,
                Value<String?> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeadTimesCompanion.insert(
                id: id,
                projectId: projectId,
                fromDate: fromDate,
                toDate: toDate,
                reason: reason,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeadTimesTableReferences(db, table, e),
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
                                referencedTable: $$DeadTimesTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$DeadTimesTableReferences
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

typedef $$DeadTimesTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $DeadTimesTable,
      DeadTime,
      $$DeadTimesTableFilterComposer,
      $$DeadTimesTableOrderingComposer,
      $$DeadTimesTableAnnotationComposer,
      $$DeadTimesTableCreateCompanionBuilder,
      $$DeadTimesTableUpdateCompanionBuilder,
      (DeadTime, $$DeadTimesTableReferences),
      DeadTime,
      PrefetchHooks Function({bool projectId})
    >;
typedef $$PauseLogsTableCreateCompanionBuilder =
    PauseLogsCompanion Function({
      required String id,
      required String projectId,
      required String action,
      required DateTime timestamp,
      Value<String?> reason,
      Value<int?> plannedPauseDays,
      Value<int> rowid,
    });
typedef $$PauseLogsTableUpdateCompanionBuilder =
    PauseLogsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> action,
      Value<DateTime> timestamp,
      Value<String?> reason,
      Value<int?> plannedPauseDays,
      Value<int> rowid,
    });

final class $$PauseLogsTableReferences
    extends BaseReferences<_$PulseDatabase, $PauseLogsTable, PauseLog> {
  $$PauseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$PulseDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.pauseLogs.projectId, db.projects.id),
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

class $$PauseLogsTableFilterComposer
    extends Composer<_$PulseDatabase, $PauseLogsTable> {
  $$PauseLogsTableFilterComposer({
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

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedPauseDays => $composableBuilder(
    column: $table.plannedPauseDays,
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

class $$PauseLogsTableOrderingComposer
    extends Composer<_$PulseDatabase, $PauseLogsTable> {
  $$PauseLogsTableOrderingComposer({
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

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedPauseDays => $composableBuilder(
    column: $table.plannedPauseDays,
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

class $$PauseLogsTableAnnotationComposer
    extends Composer<_$PulseDatabase, $PauseLogsTable> {
  $$PauseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get plannedPauseDays => $composableBuilder(
    column: $table.plannedPauseDays,
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
}

class $$PauseLogsTableTableManager
    extends
        RootTableManager<
          _$PulseDatabase,
          $PauseLogsTable,
          PauseLog,
          $$PauseLogsTableFilterComposer,
          $$PauseLogsTableOrderingComposer,
          $$PauseLogsTableAnnotationComposer,
          $$PauseLogsTableCreateCompanionBuilder,
          $$PauseLogsTableUpdateCompanionBuilder,
          (PauseLog, $$PauseLogsTableReferences),
          PauseLog,
          PrefetchHooks Function({bool projectId})
        > {
  $$PauseLogsTableTableManager(_$PulseDatabase db, $PauseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PauseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PauseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PauseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int?> plannedPauseDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PauseLogsCompanion(
                id: id,
                projectId: projectId,
                action: action,
                timestamp: timestamp,
                reason: reason,
                plannedPauseDays: plannedPauseDays,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String action,
                required DateTime timestamp,
                Value<String?> reason = const Value.absent(),
                Value<int?> plannedPauseDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PauseLogsCompanion.insert(
                id: id,
                projectId: projectId,
                action: action,
                timestamp: timestamp,
                reason: reason,
                plannedPauseDays: plannedPauseDays,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PauseLogsTableReferences(db, table, e),
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
                                referencedTable: $$PauseLogsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$PauseLogsTableReferences
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

typedef $$PauseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$PulseDatabase,
      $PauseLogsTable,
      PauseLog,
      $$PauseLogsTableFilterComposer,
      $$PauseLogsTableOrderingComposer,
      $$PauseLogsTableAnnotationComposer,
      $$PauseLogsTableCreateCompanionBuilder,
      $$PauseLogsTableUpdateCompanionBuilder,
      (PauseLog, $$PauseLogsTableReferences),
      PauseLog,
      PrefetchHooks Function({bool projectId})
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
  $$ExecutionPhasesTableTableManager get executionPhases =>
      $$ExecutionPhasesTableTableManager(_db, _db.executionPhases);
  $$LearningGoalsTableTableManager get learningGoals =>
      $$LearningGoalsTableTableManager(_db, _db.learningGoals);
  $$DeadTimesTableTableManager get deadTimes =>
      $$DeadTimesTableTableManager(_db, _db.deadTimes);
  $$PauseLogsTableTableManager get pauseLogs =>
      $$PauseLogsTableTableManager(_db, _db.pauseLogs);
  $$RelationsTableTableManager get relations =>
      $$RelationsTableTableManager(_db, _db.relations);
  $$YamlImportsTableTableManager get yamlImports =>
      $$YamlImportsTableTableManager(_db, _db.yamlImports);
  $$DecayLogsTableTableManager get decayLogs =>
      $$DecayLogsTableTableManager(_db, _db.decayLogs);
  $$NotificationLogTableTableManager get notificationLog =>
      $$NotificationLogTableTableManager(_db, _db.notificationLog);
}
