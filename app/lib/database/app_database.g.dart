// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BodyMeasurementsTable extends BodyMeasurements
    with TableInfo<$BodyMeasurementsTable, BodyMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyFatPctMeta = const VerificationMeta(
    'bodyFatPct',
  );
  @override
  late final GeneratedColumn<double> bodyFatPct = GeneratedColumn<double>(
    'body_fat_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleMassKgMeta = const VerificationMeta(
    'muscleMassKg',
  );
  @override
  late final GeneratedColumn<double> muscleMassKg = GeneratedColumn<double>(
    'muscle_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    measuredAt,
    weightKg,
    bodyFatPct,
    muscleMassKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('body_fat_pct')) {
      context.handle(
        _bodyFatPctMeta,
        bodyFatPct.isAcceptableOrUnknown(
          data['body_fat_pct']!,
          _bodyFatPctMeta,
        ),
      );
    }
    if (data.containsKey('muscle_mass_kg')) {
      context.handle(
        _muscleMassKgMeta,
        muscleMassKg.isAcceptableOrUnknown(
          data['muscle_mass_kg']!,
          _muscleMassKgMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      bodyFatPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_pct'],
      ),
      muscleMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_mass_kg'],
      ),
    );
  }

  @override
  $BodyMeasurementsTable createAlias(String alias) {
    return $BodyMeasurementsTable(attachedDatabase, alias);
  }
}

class BodyMeasurement extends DataClass implements Insertable<BodyMeasurement> {
  final int id;
  final DateTime measuredAt;
  final double weightKg;
  final double? bodyFatPct;
  final double? muscleMassKg;
  const BodyMeasurement({
    required this.id,
    required this.measuredAt,
    required this.weightKg,
    this.bodyFatPct,
    this.muscleMassKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || bodyFatPct != null) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct);
    }
    if (!nullToAbsent || muscleMassKg != null) {
      map['muscle_mass_kg'] = Variable<double>(muscleMassKg);
    }
    return map;
  }

  BodyMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return BodyMeasurementsCompanion(
      id: Value(id),
      measuredAt: Value(measuredAt),
      weightKg: Value(weightKg),
      bodyFatPct: bodyFatPct == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPct),
      muscleMassKg: muscleMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleMassKg),
    );
  }

  factory BodyMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMeasurement(
      id: serializer.fromJson<int>(json['id']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      bodyFatPct: serializer.fromJson<double?>(json['bodyFatPct']),
      muscleMassKg: serializer.fromJson<double?>(json['muscleMassKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'weightKg': serializer.toJson<double>(weightKg),
      'bodyFatPct': serializer.toJson<double?>(bodyFatPct),
      'muscleMassKg': serializer.toJson<double?>(muscleMassKg),
    };
  }

  BodyMeasurement copyWith({
    int? id,
    DateTime? measuredAt,
    double? weightKg,
    Value<double?> bodyFatPct = const Value.absent(),
    Value<double?> muscleMassKg = const Value.absent(),
  }) => BodyMeasurement(
    id: id ?? this.id,
    measuredAt: measuredAt ?? this.measuredAt,
    weightKg: weightKg ?? this.weightKg,
    bodyFatPct: bodyFatPct.present ? bodyFatPct.value : this.bodyFatPct,
    muscleMassKg: muscleMassKg.present ? muscleMassKg.value : this.muscleMassKg,
  );
  BodyMeasurement copyWithCompanion(BodyMeasurementsCompanion data) {
    return BodyMeasurement(
      id: data.id.present ? data.id.value : this.id,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bodyFatPct: data.bodyFatPct.present
          ? data.bodyFatPct.value
          : this.bodyFatPct,
      muscleMassKg: data.muscleMassKg.present
          ? data.muscleMassKg.value
          : this.muscleMassKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurement(')
          ..write('id: $id, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPct: $bodyFatPct, ')
          ..write('muscleMassKg: $muscleMassKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, measuredAt, weightKg, bodyFatPct, muscleMassKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMeasurement &&
          other.id == this.id &&
          other.measuredAt == this.measuredAt &&
          other.weightKg == this.weightKg &&
          other.bodyFatPct == this.bodyFatPct &&
          other.muscleMassKg == this.muscleMassKg);
}

class BodyMeasurementsCompanion extends UpdateCompanion<BodyMeasurement> {
  final Value<int> id;
  final Value<DateTime> measuredAt;
  final Value<double> weightKg;
  final Value<double?> bodyFatPct;
  final Value<double?> muscleMassKg;
  const BodyMeasurementsCompanion({
    this.id = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bodyFatPct = const Value.absent(),
    this.muscleMassKg = const Value.absent(),
  });
  BodyMeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime measuredAt,
    required double weightKg,
    this.bodyFatPct = const Value.absent(),
    this.muscleMassKg = const Value.absent(),
  }) : measuredAt = Value(measuredAt),
       weightKg = Value(weightKg);
  static Insertable<BodyMeasurement> custom({
    Expression<int>? id,
    Expression<DateTime>? measuredAt,
    Expression<double>? weightKg,
    Expression<double>? bodyFatPct,
    Expression<double>? muscleMassKg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bodyFatPct != null) 'body_fat_pct': bodyFatPct,
      if (muscleMassKg != null) 'muscle_mass_kg': muscleMassKg,
    });
  }

  BodyMeasurementsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? measuredAt,
    Value<double>? weightKg,
    Value<double?>? bodyFatPct,
    Value<double?>? muscleMassKg,
  }) {
    return BodyMeasurementsCompanion(
      id: id ?? this.id,
      measuredAt: measuredAt ?? this.measuredAt,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      muscleMassKg: muscleMassKg ?? this.muscleMassKg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bodyFatPct.present) {
      map['body_fat_pct'] = Variable<double>(bodyFatPct.value);
    }
    if (muscleMassKg.present) {
      map['muscle_mass_kg'] = Variable<double>(muscleMassKg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPct: $bodyFatPct, ')
          ..write('muscleMassKg: $muscleMassKg')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _bodyPartMeta = const VerificationMeta(
    'bodyPart',
  );
  @override
  late final GeneratedColumn<String> bodyPart = GeneratedColumn<String>(
    'body_part',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, bodyPart, isCustom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('body_part')) {
      context.handle(
        _bodyPartMeta,
        bodyPart.isAcceptableOrUnknown(data['body_part']!, _bodyPartMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyPartMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bodyPart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_part'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String bodyPart;
  final bool isCustom;
  const Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['body_part'] = Variable<String>(bodyPart);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      bodyPart: Value(bodyPart),
      isCustom: Value(isCustom),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bodyPart: serializer.fromJson<String>(json['bodyPart']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bodyPart': serializer.toJson<String>(bodyPart),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? bodyPart,
    bool? isCustom,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    bodyPart: bodyPart ?? this.bodyPart,
    isCustom: isCustom ?? this.isCustom,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bodyPart: data.bodyPart.present ? data.bodyPart.value : this.bodyPart,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bodyPart: $bodyPart, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, bodyPart, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.bodyPart == this.bodyPart &&
          other.isCustom == this.isCustom);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> bodyPart;
  final Value<bool> isCustom;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bodyPart = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String bodyPart,
    this.isCustom = const Value.absent(),
  }) : name = Value(name),
       bodyPart = Value(bodyPart);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bodyPart,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bodyPart != null) 'body_part': bodyPart,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? bodyPart,
    Value<bool>? isCustom,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyPart: bodyPart ?? this.bodyPart,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bodyPart.present) {
      map['body_part'] = Variable<String>(bodyPart.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bodyPart: $bodyPart, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, startedAt, endedAt, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? status;
  const WorkoutSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String?>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String?>(status),
    };
  }

  WorkoutSession copyWith({
    int? id,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<String?> status = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status.present ? status.value : this.status,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String?> status;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
  }) : startedAt = Value(startedAt);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String?>? status,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetGroupsTable extends WorkoutSetGroups
    with TableInfo<$WorkoutSetGroupsTable, WorkoutSetGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _groupTypeMeta = const VerificationMeta(
    'groupType',
  );
  @override
  late final GeneratedColumn<String> groupType = GeneratedColumn<String>(
    'group_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _orderInSessionMeta = const VerificationMeta(
    'orderInSession',
  );
  @override
  late final GeneratedColumn<int> orderInSession = GeneratedColumn<int>(
    'order_in_session',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    groupType,
    orderInSession,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('group_type')) {
      context.handle(
        _groupTypeMeta,
        groupType.isAcceptableOrUnknown(data['group_type']!, _groupTypeMeta),
      );
    }
    if (data.containsKey('order_in_session')) {
      context.handle(
        _orderInSessionMeta,
        orderInSession.isAcceptableOrUnknown(
          data['order_in_session']!,
          _orderInSessionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderInSessionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      groupType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_type'],
      )!,
      orderInSession: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_in_session'],
      )!,
    );
  }

  @override
  $WorkoutSetGroupsTable createAlias(String alias) {
    return $WorkoutSetGroupsTable(attachedDatabase, alias);
  }
}

class WorkoutSetGroup extends DataClass implements Insertable<WorkoutSetGroup> {
  final int id;
  final int sessionId;
  final String groupType;
  final int orderInSession;
  const WorkoutSetGroup({
    required this.id,
    required this.sessionId,
    required this.groupType,
    required this.orderInSession,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['group_type'] = Variable<String>(groupType);
    map['order_in_session'] = Variable<int>(orderInSession);
    return map;
  }

  WorkoutSetGroupsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetGroupsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      groupType: Value(groupType),
      orderInSession: Value(orderInSession),
    );
  }

  factory WorkoutSetGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetGroup(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      groupType: serializer.fromJson<String>(json['groupType']),
      orderInSession: serializer.fromJson<int>(json['orderInSession']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'groupType': serializer.toJson<String>(groupType),
      'orderInSession': serializer.toJson<int>(orderInSession),
    };
  }

  WorkoutSetGroup copyWith({
    int? id,
    int? sessionId,
    String? groupType,
    int? orderInSession,
  }) => WorkoutSetGroup(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    groupType: groupType ?? this.groupType,
    orderInSession: orderInSession ?? this.orderInSession,
  );
  WorkoutSetGroup copyWithCompanion(WorkoutSetGroupsCompanion data) {
    return WorkoutSetGroup(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      groupType: data.groupType.present ? data.groupType.value : this.groupType,
      orderInSession: data.orderInSession.present
          ? data.orderInSession.value
          : this.orderInSession,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetGroup(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('groupType: $groupType, ')
          ..write('orderInSession: $orderInSession')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, groupType, orderInSession);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetGroup &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.groupType == this.groupType &&
          other.orderInSession == this.orderInSession);
}

class WorkoutSetGroupsCompanion extends UpdateCompanion<WorkoutSetGroup> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> groupType;
  final Value<int> orderInSession;
  const WorkoutSetGroupsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.groupType = const Value.absent(),
    this.orderInSession = const Value.absent(),
  });
  WorkoutSetGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    this.groupType = const Value.absent(),
    required int orderInSession,
  }) : sessionId = Value(sessionId),
       orderInSession = Value(orderInSession);
  static Insertable<WorkoutSetGroup> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? groupType,
    Expression<int>? orderInSession,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (groupType != null) 'group_type': groupType,
      if (orderInSession != null) 'order_in_session': orderInSession,
    });
  }

  WorkoutSetGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? groupType,
    Value<int>? orderInSession,
  }) {
    return WorkoutSetGroupsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      groupType: groupType ?? this.groupType,
      orderInSession: orderInSession ?? this.orderInSession,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (groupType.present) {
      map['group_type'] = Variable<String>(groupType.value);
    }
    if (orderInSession.present) {
      map['order_in_session'] = Variable<int>(orderInSession.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetGroupsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('groupType: $groupType, ')
          ..write('orderInSession: $orderInSession')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_set_groups (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _orderInGroupMeta = const VerificationMeta(
    'orderInGroup',
  );
  @override
  late final GeneratedColumn<int> orderInGroup = GeneratedColumn<int>(
    'order_in_group',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    exerciseId,
    orderInGroup,
    weightKg,
    reps,
    restSeconds,
    isDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_in_group')) {
      context.handle(
        _orderInGroupMeta,
        orderInGroup.isAcceptableOrUnknown(
          data['order_in_group']!,
          _orderInGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderInGroupMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderInGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_in_group'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final int id;
  final int groupId;
  final int exerciseId;
  final int orderInGroup;
  final double weightKg;
  final int reps;
  final int? restSeconds;
  final bool isDone;
  const WorkoutSet({
    required this.id,
    required this.groupId,
    required this.exerciseId,
    required this.orderInGroup,
    required this.weightKg,
    required this.reps,
    this.restSeconds,
    required this.isDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['group_id'] = Variable<int>(groupId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['order_in_group'] = Variable<int>(orderInGroup);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      exerciseId: Value(exerciseId),
      orderInGroup: Value(orderInGroup),
      weightKg: Value(weightKg),
      reps: Value(reps),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      isDone: Value(isDone),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int>(json['groupId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      orderInGroup: serializer.fromJson<int>(json['orderInGroup']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int>(groupId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'orderInGroup': serializer.toJson<int>(orderInGroup),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? groupId,
    int? exerciseId,
    int? orderInGroup,
    double? weightKg,
    int? reps,
    Value<int?> restSeconds = const Value.absent(),
    bool? isDone,
  }) => WorkoutSet(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderInGroup: orderInGroup ?? this.orderInGroup,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
    isDone: isDone ?? this.isDone,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderInGroup: data.orderInGroup.present
          ? data.orderInGroup.value
          : this.orderInGroup,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderInGroup: $orderInGroup, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    exerciseId,
    orderInGroup,
    weightKg,
    reps,
    restSeconds,
    isDone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.exerciseId == this.exerciseId &&
          other.orderInGroup == this.orderInGroup &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.restSeconds == this.restSeconds &&
          other.isDone == this.isDone);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<int> id;
  final Value<int> groupId;
  final Value<int> exerciseId;
  final Value<int> orderInGroup;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<int?> restSeconds;
  final Value<bool> isDone;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderInGroup = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required int groupId,
    required int exerciseId,
    required int orderInGroup,
    required double weightKg,
    required int reps,
    this.restSeconds = const Value.absent(),
    this.isDone = const Value.absent(),
  }) : groupId = Value(groupId),
       exerciseId = Value(exerciseId),
       orderInGroup = Value(orderInGroup),
       weightKg = Value(weightKg),
       reps = Value(reps);
  static Insertable<WorkoutSet> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<int>? exerciseId,
    Expression<int>? orderInGroup,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? restSeconds,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderInGroup != null) 'order_in_group': orderInGroup,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (isDone != null) 'is_done': isDone,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<int>? id,
    Value<int>? groupId,
    Value<int>? exerciseId,
    Value<int>? orderInGroup,
    Value<double>? weightKg,
    Value<int>? reps,
    Value<int?>? restSeconds,
    Value<bool>? isDone,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderInGroup: orderInGroup ?? this.orderInGroup,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (orderInGroup.present) {
      map['order_in_group'] = Variable<int>(orderInGroup.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderInGroup: $orderInGroup, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetAssistsTable extends WorkoutSetAssists
    with TableInfo<$WorkoutSetAssistsTable, WorkoutSetAssist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetAssistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<int> setId = GeneratedColumn<int>(
    'set_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sets (id)',
    ),
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assistedRepsMeta = const VerificationMeta(
    'assistedReps',
  );
  @override
  late final GeneratedColumn<int> assistedReps = GeneratedColumn<int>(
    'assisted_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assistedByMeta = const VerificationMeta(
    'assistedBy',
  );
  @override
  late final GeneratedColumn<String> assistedBy = GeneratedColumn<String>(
    'assisted_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    setId,
    scope,
    assistedReps,
    assistedBy,
    memo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_assists';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetAssist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('set_id')) {
      context.handle(
        _setIdMeta,
        setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta),
      );
    } else if (isInserting) {
      context.missing(_setIdMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('assisted_reps')) {
      context.handle(
        _assistedRepsMeta,
        assistedReps.isAcceptableOrUnknown(
          data['assisted_reps']!,
          _assistedRepsMeta,
        ),
      );
    }
    if (data.containsKey('assisted_by')) {
      context.handle(
        _assistedByMeta,
        assistedBy.isAcceptableOrUnknown(data['assisted_by']!, _assistedByMeta),
      );
    } else if (isInserting) {
      context.missing(_assistedByMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetAssist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetAssist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      setId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_id'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      assistedReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assisted_reps'],
      ),
      assistedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assisted_by'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
    );
  }

  @override
  $WorkoutSetAssistsTable createAlias(String alias) {
    return $WorkoutSetAssistsTable(attachedDatabase, alias);
  }
}

class WorkoutSetAssist extends DataClass
    implements Insertable<WorkoutSetAssist> {
  final int id;
  final int setId;
  final String scope;
  final int? assistedReps;
  final String assistedBy;
  final String? memo;
  const WorkoutSetAssist({
    required this.id,
    required this.setId,
    required this.scope,
    this.assistedReps,
    required this.assistedBy,
    this.memo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['set_id'] = Variable<int>(setId);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || assistedReps != null) {
      map['assisted_reps'] = Variable<int>(assistedReps);
    }
    map['assisted_by'] = Variable<String>(assistedBy);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  WorkoutSetAssistsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetAssistsCompanion(
      id: Value(id),
      setId: Value(setId),
      scope: Value(scope),
      assistedReps: assistedReps == null && nullToAbsent
          ? const Value.absent()
          : Value(assistedReps),
      assistedBy: Value(assistedBy),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory WorkoutSetAssist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetAssist(
      id: serializer.fromJson<int>(json['id']),
      setId: serializer.fromJson<int>(json['setId']),
      scope: serializer.fromJson<String>(json['scope']),
      assistedReps: serializer.fromJson<int?>(json['assistedReps']),
      assistedBy: serializer.fromJson<String>(json['assistedBy']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'setId': serializer.toJson<int>(setId),
      'scope': serializer.toJson<String>(scope),
      'assistedReps': serializer.toJson<int?>(assistedReps),
      'assistedBy': serializer.toJson<String>(assistedBy),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  WorkoutSetAssist copyWith({
    int? id,
    int? setId,
    String? scope,
    Value<int?> assistedReps = const Value.absent(),
    String? assistedBy,
    Value<String?> memo = const Value.absent(),
  }) => WorkoutSetAssist(
    id: id ?? this.id,
    setId: setId ?? this.setId,
    scope: scope ?? this.scope,
    assistedReps: assistedReps.present ? assistedReps.value : this.assistedReps,
    assistedBy: assistedBy ?? this.assistedBy,
    memo: memo.present ? memo.value : this.memo,
  );
  WorkoutSetAssist copyWithCompanion(WorkoutSetAssistsCompanion data) {
    return WorkoutSetAssist(
      id: data.id.present ? data.id.value : this.id,
      setId: data.setId.present ? data.setId.value : this.setId,
      scope: data.scope.present ? data.scope.value : this.scope,
      assistedReps: data.assistedReps.present
          ? data.assistedReps.value
          : this.assistedReps,
      assistedBy: data.assistedBy.present
          ? data.assistedBy.value
          : this.assistedBy,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetAssist(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('scope: $scope, ')
          ..write('assistedReps: $assistedReps, ')
          ..write('assistedBy: $assistedBy, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, setId, scope, assistedReps, assistedBy, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetAssist &&
          other.id == this.id &&
          other.setId == this.setId &&
          other.scope == this.scope &&
          other.assistedReps == this.assistedReps &&
          other.assistedBy == this.assistedBy &&
          other.memo == this.memo);
}

class WorkoutSetAssistsCompanion extends UpdateCompanion<WorkoutSetAssist> {
  final Value<int> id;
  final Value<int> setId;
  final Value<String> scope;
  final Value<int?> assistedReps;
  final Value<String> assistedBy;
  final Value<String?> memo;
  const WorkoutSetAssistsCompanion({
    this.id = const Value.absent(),
    this.setId = const Value.absent(),
    this.scope = const Value.absent(),
    this.assistedReps = const Value.absent(),
    this.assistedBy = const Value.absent(),
    this.memo = const Value.absent(),
  });
  WorkoutSetAssistsCompanion.insert({
    this.id = const Value.absent(),
    required int setId,
    required String scope,
    this.assistedReps = const Value.absent(),
    required String assistedBy,
    this.memo = const Value.absent(),
  }) : setId = Value(setId),
       scope = Value(scope),
       assistedBy = Value(assistedBy);
  static Insertable<WorkoutSetAssist> custom({
    Expression<int>? id,
    Expression<int>? setId,
    Expression<String>? scope,
    Expression<int>? assistedReps,
    Expression<String>? assistedBy,
    Expression<String>? memo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setId != null) 'set_id': setId,
      if (scope != null) 'scope': scope,
      if (assistedReps != null) 'assisted_reps': assistedReps,
      if (assistedBy != null) 'assisted_by': assistedBy,
      if (memo != null) 'memo': memo,
    });
  }

  WorkoutSetAssistsCompanion copyWith({
    Value<int>? id,
    Value<int>? setId,
    Value<String>? scope,
    Value<int?>? assistedReps,
    Value<String>? assistedBy,
    Value<String?>? memo,
  }) {
    return WorkoutSetAssistsCompanion(
      id: id ?? this.id,
      setId: setId ?? this.setId,
      scope: scope ?? this.scope,
      assistedReps: assistedReps ?? this.assistedReps,
      assistedBy: assistedBy ?? this.assistedBy,
      memo: memo ?? this.memo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (setId.present) {
      map['set_id'] = Variable<int>(setId.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (assistedReps.present) {
      map['assisted_reps'] = Variable<int>(assistedReps.value);
    }
    if (assistedBy.present) {
      map['assisted_by'] = Variable<String>(assistedBy.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetAssistsCompanion(')
          ..write('id: $id, ')
          ..write('setId: $setId, ')
          ..write('scope: $scope, ')
          ..write('assistedReps: $assistedReps, ')
          ..write('assistedBy: $assistedBy, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }
}

class $MyTrainingListsTable extends MyTrainingLists
    with TableInfo<$MyTrainingListsTable, MyTrainingList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MyTrainingListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'my_training_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<MyTrainingList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MyTrainingList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MyTrainingList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $MyTrainingListsTable createAlias(String alias) {
    return $MyTrainingListsTable(attachedDatabase, alias);
  }
}

class MyTrainingList extends DataClass implements Insertable<MyTrainingList> {
  final int id;
  final String name;
  const MyTrainingList({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  MyTrainingListsCompanion toCompanion(bool nullToAbsent) {
    return MyTrainingListsCompanion(id: Value(id), name: Value(name));
  }

  factory MyTrainingList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MyTrainingList(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  MyTrainingList copyWith({int? id, String? name}) =>
      MyTrainingList(id: id ?? this.id, name: name ?? this.name);
  MyTrainingList copyWithCompanion(MyTrainingListsCompanion data) {
    return MyTrainingList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MyTrainingList(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyTrainingList &&
          other.id == this.id &&
          other.name == this.name);
}

class MyTrainingListsCompanion extends UpdateCompanion<MyTrainingList> {
  final Value<int> id;
  final Value<String> name;
  const MyTrainingListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  MyTrainingListsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<MyTrainingList> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  MyTrainingListsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return MyTrainingListsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MyTrainingListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $MyTrainingListItemsTable extends MyTrainingListItems
    with TableInfo<$MyTrainingListItemsTable, MyTrainingListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MyTrainingListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES my_training_lists (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<String> targetReps = GeneratedColumn<String>(
    'target_reps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ストレート'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    exerciseId,
    targetSets,
    targetReps,
    orderIndex,
    setType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'my_training_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MyTrainingListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetSetsMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetRepsMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MyTrainingListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MyTrainingListItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_reps'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
    );
  }

  @override
  $MyTrainingListItemsTable createAlias(String alias) {
    return $MyTrainingListItemsTable(attachedDatabase, alias);
  }
}

class MyTrainingListItem extends DataClass
    implements Insertable<MyTrainingListItem> {
  final int id;
  final int listId;
  final int exerciseId;
  final int targetSets;
  final String targetReps;
  final int orderIndex;
  final String setType;
  const MyTrainingListItem({
    required this.id,
    required this.listId,
    required this.exerciseId,
    required this.targetSets,
    required this.targetReps,
    required this.orderIndex,
    required this.setType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['target_sets'] = Variable<int>(targetSets);
    map['target_reps'] = Variable<String>(targetReps);
    map['order_index'] = Variable<int>(orderIndex);
    map['set_type'] = Variable<String>(setType);
    return map;
  }

  MyTrainingListItemsCompanion toCompanion(bool nullToAbsent) {
    return MyTrainingListItemsCompanion(
      id: Value(id),
      listId: Value(listId),
      exerciseId: Value(exerciseId),
      targetSets: Value(targetSets),
      targetReps: Value(targetReps),
      orderIndex: Value(orderIndex),
      setType: Value(setType),
    );
  }

  factory MyTrainingListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MyTrainingListItem(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      targetReps: serializer.fromJson<String>(json['targetReps']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      setType: serializer.fromJson<String>(json['setType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'targetSets': serializer.toJson<int>(targetSets),
      'targetReps': serializer.toJson<String>(targetReps),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'setType': serializer.toJson<String>(setType),
    };
  }

  MyTrainingListItem copyWith({
    int? id,
    int? listId,
    int? exerciseId,
    int? targetSets,
    String? targetReps,
    int? orderIndex,
    String? setType,
  }) => MyTrainingListItem(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    exerciseId: exerciseId ?? this.exerciseId,
    targetSets: targetSets ?? this.targetSets,
    targetReps: targetReps ?? this.targetReps,
    orderIndex: orderIndex ?? this.orderIndex,
    setType: setType ?? this.setType,
  );
  MyTrainingListItem copyWithCompanion(MyTrainingListItemsCompanion data) {
    return MyTrainingListItem(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      setType: data.setType.present ? data.setType.value : this.setType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MyTrainingListItem(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('setType: $setType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    exerciseId,
    targetSets,
    targetReps,
    orderIndex,
    setType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyTrainingListItem &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.exerciseId == this.exerciseId &&
          other.targetSets == this.targetSets &&
          other.targetReps == this.targetReps &&
          other.orderIndex == this.orderIndex &&
          other.setType == this.setType);
}

class MyTrainingListItemsCompanion extends UpdateCompanion<MyTrainingListItem> {
  final Value<int> id;
  final Value<int> listId;
  final Value<int> exerciseId;
  final Value<int> targetSets;
  final Value<String> targetReps;
  final Value<int> orderIndex;
  final Value<String> setType;
  const MyTrainingListItemsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.setType = const Value.absent(),
  });
  MyTrainingListItemsCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    required int exerciseId,
    required int targetSets,
    required String targetReps,
    required int orderIndex,
    this.setType = const Value.absent(),
  }) : listId = Value(listId),
       exerciseId = Value(exerciseId),
       targetSets = Value(targetSets),
       targetReps = Value(targetReps),
       orderIndex = Value(orderIndex);
  static Insertable<MyTrainingListItem> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<int>? exerciseId,
    Expression<int>? targetSets,
    Expression<String>? targetReps,
    Expression<int>? orderIndex,
    Expression<String>? setType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetReps != null) 'target_reps': targetReps,
      if (orderIndex != null) 'order_index': orderIndex,
      if (setType != null) 'set_type': setType,
    });
  }

  MyTrainingListItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? listId,
    Value<int>? exerciseId,
    Value<int>? targetSets,
    Value<String>? targetReps,
    Value<int>? orderIndex,
    Value<String>? setType,
  }) {
    return MyTrainingListItemsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      exerciseId: exerciseId ?? this.exerciseId,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      orderIndex: orderIndex ?? this.orderIndex,
      setType: setType ?? this.setType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<String>(targetReps.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MyTrainingListItemsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetReps: $targetReps, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('setType: $setType')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BodyMeasurementsTable bodyMeasurements = $BodyMeasurementsTable(
    this,
  );
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutSetGroupsTable workoutSetGroups = $WorkoutSetGroupsTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $WorkoutSetAssistsTable workoutSetAssists =
      $WorkoutSetAssistsTable(this);
  late final $MyTrainingListsTable myTrainingLists = $MyTrainingListsTable(
    this,
  );
  late final $MyTrainingListItemsTable myTrainingListItems =
      $MyTrainingListItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bodyMeasurements,
    exercises,
    workoutSessions,
    workoutSetGroups,
    workoutSets,
    workoutSetAssists,
    myTrainingLists,
    myTrainingListItems,
  ];
}

typedef $$BodyMeasurementsTableCreateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<int> id,
      required DateTime measuredAt,
      required double weightKg,
      Value<double?> bodyFatPct,
      Value<double?> muscleMassKg,
    });
typedef $$BodyMeasurementsTableUpdateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<int> id,
      Value<DateTime> measuredAt,
      Value<double> weightKg,
      Value<double?> bodyFatPct,
      Value<double?> muscleMassKg,
    });

class $$BodyMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPct => $composableBuilder(
    column: $table.bodyFatPct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => column,
  );
}

class $$BodyMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurement,
          $$BodyMeasurementsTableFilterComposer,
          $$BodyMeasurementsTableOrderingComposer,
          $$BodyMeasurementsTableAnnotationComposer,
          $$BodyMeasurementsTableCreateCompanionBuilder,
          $$BodyMeasurementsTableUpdateCompanionBuilder,
          (
            BodyMeasurement,
            BaseReferences<
              _$AppDatabase,
              $BodyMeasurementsTable,
              BodyMeasurement
            >,
          ),
          BodyMeasurement,
          PrefetchHooks Function()
        > {
  $$BodyMeasurementsTableTableManager(
    _$AppDatabase db,
    $BodyMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> bodyFatPct = const Value.absent(),
                Value<double?> muscleMassKg = const Value.absent(),
              }) => BodyMeasurementsCompanion(
                id: id,
                measuredAt: measuredAt,
                weightKg: weightKg,
                bodyFatPct: bodyFatPct,
                muscleMassKg: muscleMassKg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime measuredAt,
                required double weightKg,
                Value<double?> bodyFatPct = const Value.absent(),
                Value<double?> muscleMassKg = const Value.absent(),
              }) => BodyMeasurementsCompanion.insert(
                id: id,
                measuredAt: measuredAt,
                weightKg: weightKg,
                bodyFatPct: bodyFatPct,
                muscleMassKg: muscleMassKg,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyMeasurementsTable, BodyMeasurement>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BodyMeasurementsTable,
                    BodyMeasurement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMeasurementsTable,
      BodyMeasurement,
      $$BodyMeasurementsTableFilterComposer,
      $$BodyMeasurementsTableOrderingComposer,
      $$BodyMeasurementsTableAnnotationComposer,
      $$BodyMeasurementsTableCreateCompanionBuilder,
      $$BodyMeasurementsTableUpdateCompanionBuilder,
      (
        BodyMeasurement,
        BaseReferences<_$AppDatabase, $BodyMeasurementsTable, BodyMeasurement>,
      ),
      BodyMeasurement,
      PrefetchHooks Function()
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  required String name,
  required String bodyPart,
  Value<bool> isCustom,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> bodyPart,
  Value<bool> isCustom,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'exercises__id__workout_sets__exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MyTrainingListItemsTable,
    List<MyTrainingListItem>
  >
  _myTrainingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.myTrainingListItems,
        aliasName: 'exercises__id__my_training_list_items__exercise_id',
      );

  $$MyTrainingListItemsTableProcessedTableManager get myTrainingListItemsRefs {
    final manager = $$MyTrainingListItemsTableTableManager(
      $_db,
      $_db.myTrainingListItems,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _myTrainingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyPart => $composableBuilder(
    column: $table.bodyPart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> myTrainingListItemsRefs(
    Expression<bool> Function($$MyTrainingListItemsTableFilterComposer f) f,
  ) {
    final $$MyTrainingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.myTrainingListItems,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MyTrainingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.myTrainingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyPart => $composableBuilder(
    column: $table.bodyPart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bodyPart =>
      $composableBuilder(column: $table.bodyPart, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> myTrainingListItemsRefs<T extends Object>(
    Expression<T> Function($$MyTrainingListItemsTableAnnotationComposer a) f,
  ) {
    final $$MyTrainingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.myTrainingListItems,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MyTrainingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.myTrainingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool workoutSetsRefs,
            bool myTrainingListItemsRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> bodyPart = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                bodyPart: bodyPart,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String bodyPart,
                Value<bool> isCustom = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                bodyPart: bodyPart,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutSetsRefs = false, myTrainingListItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                    if (myTrainingListItemsRefs) db.myTrainingListItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (myTrainingListItemsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          MyTrainingListItem
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._myTrainingListItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).myTrainingListItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
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

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool workoutSetsRefs,
        bool myTrainingListItemsRefs,
      })
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<String?> status,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String?> status,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutSetGroupsTable, List<WorkoutSetGroup>>
  _workoutSetGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSetGroups,
    aliasName: 'workout_sessions__id__workout_set_groups__session_id',
  );

  $$WorkoutSetGroupsTableProcessedTableManager get workoutSetGroupsRefs {
    final manager = $$WorkoutSetGroupsTableTableManager(
      $_db,
      $_db.workoutSetGroups,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSetGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetGroupsRefs(
    Expression<bool> Function($$WorkoutSetGroupsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetGroups,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetGroupsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> workoutSetGroupsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetGroupsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetGroups,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool workoutSetGroupsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> status = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> status = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutSetGroupsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutSetGroupsRefs) db.workoutSetGroups,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetGroupsRefs)
                    await $_getPrefetchedData<
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      WorkoutSetGroup
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._workoutSetGroupsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutSetGroupsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool workoutSetGroupsRefs})
    >;
typedef $$WorkoutSetGroupsTableCreateCompanionBuilder =
    WorkoutSetGroupsCompanion Function({
      Value<int> id,
      required int sessionId,
      Value<String> groupType,
      required int orderInSession,
    });
typedef $$WorkoutSetGroupsTableUpdateCompanionBuilder =
    WorkoutSetGroupsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> groupType,
      Value<int> orderInSession,
    });

final class $$WorkoutSetGroupsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSetGroupsTable, WorkoutSetGroup> {
  $$WorkoutSetGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_set_groups__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_set_groups__id__workout_sets__group_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSetGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetGroupsTable> {
  $$WorkoutSetGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupType => $composableBuilder(
    column: $table.groupType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderInSession => $composableBuilder(
    column: $table.orderInSession,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSetGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetGroupsTable> {
  $$WorkoutSetGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupType => $composableBuilder(
    column: $table.groupType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderInSession => $composableBuilder(
    column: $table.orderInSession,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetGroupsTable> {
  $$WorkoutSetGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupType =>
      $composableBuilder(column: $table.groupType, builder: (column) => column);

  GeneratedColumn<int> get orderInSession => $composableBuilder(
    column: $table.orderInSession,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSetGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetGroupsTable,
          WorkoutSetGroup,
          $$WorkoutSetGroupsTableFilterComposer,
          $$WorkoutSetGroupsTableOrderingComposer,
          $$WorkoutSetGroupsTableAnnotationComposer,
          $$WorkoutSetGroupsTableCreateCompanionBuilder,
          $$WorkoutSetGroupsTableUpdateCompanionBuilder,
          (WorkoutSetGroup, $$WorkoutSetGroupsTableReferences),
          WorkoutSetGroup,
          PrefetchHooks Function({bool sessionId, bool workoutSetsRefs})
        > {
  $$WorkoutSetGroupsTableTableManager(
    _$AppDatabase db,
    $WorkoutSetGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> groupType = const Value.absent(),
                Value<int> orderInSession = const Value.absent(),
              }) => WorkoutSetGroupsCompanion(
                id: id,
                sessionId: sessionId,
                groupType: groupType,
                orderInSession: orderInSession,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                Value<String> groupType = const Value.absent(),
                required int orderInSession,
              }) => WorkoutSetGroupsCompanion.insert(
                id: id,
                sessionId: sessionId,
                groupType: groupType,
                orderInSession: orderInSession,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetGroupsTable, WorkoutSetGroup>(table),
                  $$WorkoutSetGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, workoutSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                  ],
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
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$WorkoutSetGroupsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$WorkoutSetGroupsTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutSetGroup,
                          $WorkoutSetGroupsTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSetGroupsTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSetGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
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

typedef $$WorkoutSetGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetGroupsTable,
      WorkoutSetGroup,
      $$WorkoutSetGroupsTableFilterComposer,
      $$WorkoutSetGroupsTableOrderingComposer,
      $$WorkoutSetGroupsTableAnnotationComposer,
      $$WorkoutSetGroupsTableCreateCompanionBuilder,
      $$WorkoutSetGroupsTableUpdateCompanionBuilder,
      (WorkoutSetGroup, $$WorkoutSetGroupsTableReferences),
      WorkoutSetGroup,
      PrefetchHooks Function({bool sessionId, bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      required int groupId,
      required int exerciseId,
      required int orderInGroup,
      required double weightKg,
      required int reps,
      Value<int?> restSeconds,
      Value<bool> isDone,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<int> id,
      Value<int> groupId,
      Value<int> exerciseId,
      Value<int> orderInGroup,
      Value<double> weightKg,
      Value<int> reps,
      Value<int?> restSeconds,
      Value<bool> isDone,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSetGroupsTable _groupIdTable(_$AppDatabase db) => db
      .workoutSetGroups
      .createAlias('workout_sets__group_id__workout_set_groups__id');

  $$WorkoutSetGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$WorkoutSetGroupsTableTableManager(
      $_db,
      $_db.workoutSetGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('workout_sets__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetAssistsTable, List<WorkoutSetAssist>>
  _workoutSetAssistsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutSetAssists,
        aliasName: 'workout_sets__id__workout_set_assists__set_id',
      );

  $$WorkoutSetAssistsTableProcessedTableManager get workoutSetAssistsRefs {
    final manager = $$WorkoutSetAssistsTableTableManager(
      $_db,
      $_db.workoutSetAssists,
    ).filter((f) => f.setId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSetAssistsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderInGroup => $composableBuilder(
    column: $table.orderInGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSetGroupsTableFilterComposer get groupId {
    final $$WorkoutSetGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.workoutSetGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetGroupsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetAssistsRefs(
    Expression<bool> Function($$WorkoutSetAssistsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetAssistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetAssists,
      getReferencedColumn: (t) => t.setId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetAssistsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetAssists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderInGroup => $composableBuilder(
    column: $table.orderInGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSetGroupsTableOrderingComposer get groupId {
    final $$WorkoutSetGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.workoutSetGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderInGroup => $composableBuilder(
    column: $table.orderInGroup,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  $$WorkoutSetGroupsTableAnnotationComposer get groupId {
    final $$WorkoutSetGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.workoutSetGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSetGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetAssistsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetAssistsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetAssistsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutSetAssists,
          getReferencedColumn: (t) => t.setId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutSetAssistsTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutSetAssists,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({
            bool groupId,
            bool exerciseId,
            bool workoutSetAssistsRefs,
          })
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> groupId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> orderInGroup = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                groupId: groupId,
                exerciseId: exerciseId,
                orderInGroup: orderInGroup,
                weightKg: weightKg,
                reps: reps,
                restSeconds: restSeconds,
                isDone: isDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int groupId,
                required int exerciseId,
                required int orderInGroup,
                required double weightKg,
                required int reps,
                Value<int?> restSeconds = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                groupId: groupId,
                exerciseId: exerciseId,
                orderInGroup: orderInGroup,
                weightKg: weightKg,
                reps: reps,
                restSeconds: restSeconds,
                isDone: isDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                exerciseId = false,
                workoutSetAssistsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetAssistsRefs) db.workoutSetAssists,
                  ],
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
                        if (groupId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.groupId,
                            referencedTable: $$WorkoutSetsTableReferences
                                ._groupIdTable(db),
                            referencedColumn: $$WorkoutSetsTableReferences
                                ._groupIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$WorkoutSetsTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$WorkoutSetsTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetAssistsRefs)
                        await $_getPrefetchedData<
                          WorkoutSet,
                          $WorkoutSetsTable,
                          WorkoutSetAssist
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSetsTableReferences
                              ._workoutSetAssistsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSetsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetAssistsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.setId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({
        bool groupId,
        bool exerciseId,
        bool workoutSetAssistsRefs,
      })
    >;
typedef $$WorkoutSetAssistsTableCreateCompanionBuilder =
    WorkoutSetAssistsCompanion Function({
      Value<int> id,
      required int setId,
      required String scope,
      Value<int?> assistedReps,
      required String assistedBy,
      Value<String?> memo,
    });
typedef $$WorkoutSetAssistsTableUpdateCompanionBuilder =
    WorkoutSetAssistsCompanion Function({
      Value<int> id,
      Value<int> setId,
      Value<String> scope,
      Value<int?> assistedReps,
      Value<String> assistedBy,
      Value<String?> memo,
    });

final class $$WorkoutSetAssistsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSetAssistsTable,
          WorkoutSetAssist
        > {
  $$WorkoutSetAssistsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSetsTable _setIdTable(_$AppDatabase db) => db.workoutSets
      .createAlias('workout_set_assists__set_id__workout_sets__id');

  $$WorkoutSetsTableProcessedTableManager get setId {
    final $_column = $_itemColumn<int>('set_id')!;

    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_setIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetAssistsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetAssistsTable> {
  $$WorkoutSetAssistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assistedReps => $composableBuilder(
    column: $table.assistedReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assistedBy => $composableBuilder(
    column: $table.assistedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSetsTableFilterComposer get setId {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setId,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetAssistsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetAssistsTable> {
  $$WorkoutSetAssistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assistedReps => $composableBuilder(
    column: $table.assistedReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assistedBy => $composableBuilder(
    column: $table.assistedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSetsTableOrderingComposer get setId {
    final $$WorkoutSetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setId,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetAssistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetAssistsTable> {
  $$WorkoutSetAssistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<int> get assistedReps => $composableBuilder(
    column: $table.assistedReps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assistedBy => $composableBuilder(
    column: $table.assistedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  $$WorkoutSetsTableAnnotationComposer get setId {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setId,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetAssistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetAssistsTable,
          WorkoutSetAssist,
          $$WorkoutSetAssistsTableFilterComposer,
          $$WorkoutSetAssistsTableOrderingComposer,
          $$WorkoutSetAssistsTableAnnotationComposer,
          $$WorkoutSetAssistsTableCreateCompanionBuilder,
          $$WorkoutSetAssistsTableUpdateCompanionBuilder,
          (WorkoutSetAssist, $$WorkoutSetAssistsTableReferences),
          WorkoutSetAssist,
          PrefetchHooks Function({bool setId})
        > {
  $$WorkoutSetAssistsTableTableManager(
    _$AppDatabase db,
    $WorkoutSetAssistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetAssistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetAssistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetAssistsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> setId = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<int?> assistedReps = const Value.absent(),
                Value<String> assistedBy = const Value.absent(),
                Value<String?> memo = const Value.absent(),
              }) => WorkoutSetAssistsCompanion(
                id: id,
                setId: setId,
                scope: scope,
                assistedReps: assistedReps,
                assistedBy: assistedBy,
                memo: memo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int setId,
                required String scope,
                Value<int?> assistedReps = const Value.absent(),
                required String assistedBy,
                Value<String?> memo = const Value.absent(),
              }) => WorkoutSetAssistsCompanion.insert(
                id: id,
                setId: setId,
                scope: scope,
                assistedReps: assistedReps,
                assistedBy: assistedBy,
                memo: memo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetAssistsTable, WorkoutSetAssist>(table),
                  $$WorkoutSetAssistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setId = false}) {
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
                    if (setId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.setId,
                        referencedTable: $$WorkoutSetAssistsTableReferences
                            ._setIdTable(db),
                        referencedColumn: $$WorkoutSetAssistsTableReferences
                            ._setIdTable(db)
                            .id,
                      ) as T;
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

typedef $$WorkoutSetAssistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetAssistsTable,
      WorkoutSetAssist,
      $$WorkoutSetAssistsTableFilterComposer,
      $$WorkoutSetAssistsTableOrderingComposer,
      $$WorkoutSetAssistsTableAnnotationComposer,
      $$WorkoutSetAssistsTableCreateCompanionBuilder,
      $$WorkoutSetAssistsTableUpdateCompanionBuilder,
      (WorkoutSetAssist, $$WorkoutSetAssistsTableReferences),
      WorkoutSetAssist,
      PrefetchHooks Function({bool setId})
    >;
typedef $$MyTrainingListsTableCreateCompanionBuilder =
    MyTrainingListsCompanion Function({Value<int> id, required String name});
typedef $$MyTrainingListsTableUpdateCompanionBuilder =
    MyTrainingListsCompanion Function({Value<int> id, Value<String> name});

final class $$MyTrainingListsTableReferences
    extends
        BaseReferences<_$AppDatabase, $MyTrainingListsTable, MyTrainingList> {
  $$MyTrainingListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $MyTrainingListItemsTable,
    List<MyTrainingListItem>
  >
  _myTrainingListItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.myTrainingListItems,
        aliasName: 'my_training_lists__id__my_training_list_items__list_id',
      );

  $$MyTrainingListItemsTableProcessedTableManager get myTrainingListItemsRefs {
    final manager = $$MyTrainingListItemsTableTableManager(
      $_db,
      $_db.myTrainingListItems,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _myTrainingListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MyTrainingListsTableFilterComposer
    extends Composer<_$AppDatabase, $MyTrainingListsTable> {
  $$MyTrainingListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> myTrainingListItemsRefs(
    Expression<bool> Function($$MyTrainingListItemsTableFilterComposer f) f,
  ) {
    final $$MyTrainingListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.myTrainingListItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MyTrainingListItemsTableFilterComposer(
            $db: $db,
            $table: $db.myTrainingListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MyTrainingListsTableOrderingComposer
    extends Composer<_$AppDatabase, $MyTrainingListsTable> {
  $$MyTrainingListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MyTrainingListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MyTrainingListsTable> {
  $$MyTrainingListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> myTrainingListItemsRefs<T extends Object>(
    Expression<T> Function($$MyTrainingListItemsTableAnnotationComposer a) f,
  ) {
    final $$MyTrainingListItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.myTrainingListItems,
          getReferencedColumn: (t) => t.listId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MyTrainingListItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.myTrainingListItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MyTrainingListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MyTrainingListsTable,
          MyTrainingList,
          $$MyTrainingListsTableFilterComposer,
          $$MyTrainingListsTableOrderingComposer,
          $$MyTrainingListsTableAnnotationComposer,
          $$MyTrainingListsTableCreateCompanionBuilder,
          $$MyTrainingListsTableUpdateCompanionBuilder,
          (MyTrainingList, $$MyTrainingListsTableReferences),
          MyTrainingList,
          PrefetchHooks Function({bool myTrainingListItemsRefs})
        > {
  $$MyTrainingListsTableTableManager(
    _$AppDatabase db,
    $MyTrainingListsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MyTrainingListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MyTrainingListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MyTrainingListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) => MyTrainingListsCompanion(id: id, name: name),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) => MyTrainingListsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MyTrainingListsTable, MyTrainingList>(table),
                  $$MyTrainingListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({myTrainingListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (myTrainingListItemsRefs) db.myTrainingListItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (myTrainingListItemsRefs)
                    await $_getPrefetchedData<
                      MyTrainingList,
                      $MyTrainingListsTable,
                      MyTrainingListItem
                    >(
                      currentTable: table,
                      referencedTable: $$MyTrainingListsTableReferences
                          ._myTrainingListItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MyTrainingListsTableReferences(
                            db,
                            table,
                            p0,
                          ).myTrainingListItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MyTrainingListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MyTrainingListsTable,
      MyTrainingList,
      $$MyTrainingListsTableFilterComposer,
      $$MyTrainingListsTableOrderingComposer,
      $$MyTrainingListsTableAnnotationComposer,
      $$MyTrainingListsTableCreateCompanionBuilder,
      $$MyTrainingListsTableUpdateCompanionBuilder,
      (MyTrainingList, $$MyTrainingListsTableReferences),
      MyTrainingList,
      PrefetchHooks Function({bool myTrainingListItemsRefs})
    >;
typedef $$MyTrainingListItemsTableCreateCompanionBuilder =
    MyTrainingListItemsCompanion Function({
      Value<int> id,
      required int listId,
      required int exerciseId,
      required int targetSets,
      required String targetReps,
      required int orderIndex,
      Value<String> setType,
    });
typedef $$MyTrainingListItemsTableUpdateCompanionBuilder =
    MyTrainingListItemsCompanion Function({
      Value<int> id,
      Value<int> listId,
      Value<int> exerciseId,
      Value<int> targetSets,
      Value<String> targetReps,
      Value<int> orderIndex,
      Value<String> setType,
    });

final class $$MyTrainingListItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MyTrainingListItemsTable,
          MyTrainingListItem
        > {
  $$MyTrainingListItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MyTrainingListsTable _listIdTable(_$AppDatabase db) => db
      .myTrainingLists
      .createAlias('my_training_list_items__list_id__my_training_lists__id');

  $$MyTrainingListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$MyTrainingListsTableTableManager(
      $_db,
      $_db.myTrainingLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias('my_training_list_items__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MyTrainingListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MyTrainingListItemsTable> {
  $$MyTrainingListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  $$MyTrainingListsTableFilterComposer get listId {
    final $$MyTrainingListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.myTrainingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MyTrainingListsTableFilterComposer(
            $db: $db,
            $table: $db.myTrainingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MyTrainingListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MyTrainingListItemsTable> {
  $$MyTrainingListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  $$MyTrainingListsTableOrderingComposer get listId {
    final $$MyTrainingListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.myTrainingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MyTrainingListsTableOrderingComposer(
            $db: $db,
            $table: $db.myTrainingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MyTrainingListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MyTrainingListItemsTable> {
  $$MyTrainingListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  $$MyTrainingListsTableAnnotationComposer get listId {
    final $$MyTrainingListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.myTrainingLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MyTrainingListsTableAnnotationComposer(
            $db: $db,
            $table: $db.myTrainingLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MyTrainingListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MyTrainingListItemsTable,
          MyTrainingListItem,
          $$MyTrainingListItemsTableFilterComposer,
          $$MyTrainingListItemsTableOrderingComposer,
          $$MyTrainingListItemsTableAnnotationComposer,
          $$MyTrainingListItemsTableCreateCompanionBuilder,
          $$MyTrainingListItemsTableUpdateCompanionBuilder,
          (MyTrainingListItem, $$MyTrainingListItemsTableReferences),
          MyTrainingListItem,
          PrefetchHooks Function({bool listId, bool exerciseId})
        > {
  $$MyTrainingListItemsTableTableManager(
    _$AppDatabase db,
    $MyTrainingListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MyTrainingListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MyTrainingListItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MyTrainingListItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<String> targetReps = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> setType = const Value.absent(),
              }) => MyTrainingListItemsCompanion(
                id: id,
                listId: listId,
                exerciseId: exerciseId,
                targetSets: targetSets,
                targetReps: targetReps,
                orderIndex: orderIndex,
                setType: setType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listId,
                required int exerciseId,
                required int targetSets,
                required String targetReps,
                required int orderIndex,
                Value<String> setType = const Value.absent(),
              }) => MyTrainingListItemsCompanion.insert(
                id: id,
                listId: listId,
                exerciseId: exerciseId,
                targetSets: targetSets,
                targetReps: targetReps,
                orderIndex: orderIndex,
                setType: setType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MyTrainingListItemsTable, MyTrainingListItem>(
                    table,
                  ),
                  $$MyTrainingListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false, exerciseId = false}) {
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
                    if (listId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.listId,
                        referencedTable: $$MyTrainingListItemsTableReferences
                            ._listIdTable(db),
                        referencedColumn: $$MyTrainingListItemsTableReferences
                            ._listIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$MyTrainingListItemsTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$MyTrainingListItemsTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MyTrainingListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MyTrainingListItemsTable,
      MyTrainingListItem,
      $$MyTrainingListItemsTableFilterComposer,
      $$MyTrainingListItemsTableOrderingComposer,
      $$MyTrainingListItemsTableAnnotationComposer,
      $$MyTrainingListItemsTableCreateCompanionBuilder,
      $$MyTrainingListItemsTableUpdateCompanionBuilder,
      (MyTrainingListItem, $$MyTrainingListItemsTableReferences),
      MyTrainingListItem,
      PrefetchHooks Function({bool listId, bool exerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BodyMeasurementsTableTableManager get bodyMeasurements =>
      $$BodyMeasurementsTableTableManager(_db, _db.bodyMeasurements);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSetGroupsTableTableManager get workoutSetGroups =>
      $$WorkoutSetGroupsTableTableManager(_db, _db.workoutSetGroups);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$WorkoutSetAssistsTableTableManager get workoutSetAssists =>
      $$WorkoutSetAssistsTableTableManager(_db, _db.workoutSetAssists);
  $$MyTrainingListsTableTableManager get myTrainingLists =>
      $$MyTrainingListsTableTableManager(_db, _db.myTrainingLists);
  $$MyTrainingListItemsTableTableManager get myTrainingListItems =>
      $$MyTrainingListItemsTableTableManager(_db, _db.myTrainingListItems);
}
