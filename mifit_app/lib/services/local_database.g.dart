// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $WorkoutPlansTable extends WorkoutPlans
    with TableInfo<$WorkoutPlansTable, WorkoutPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
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
  @override
  List<GeneratedColumn> get $columns => [id, userId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
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
  WorkoutPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $WorkoutPlansTable createAlias(String alias) {
    return $WorkoutPlansTable(attachedDatabase, alias);
  }
}

class WorkoutPlan extends DataClass implements Insertable<WorkoutPlan> {
  final String id;
  final String userId;
  final String name;
  const WorkoutPlan({
    required this.id,
    required this.userId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    return map;
  }

  WorkoutPlansCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlansCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
    );
  }

  factory WorkoutPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlan(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
    };
  }

  WorkoutPlan copyWith({String? id, String? userId, String? name}) =>
      WorkoutPlan(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
      );
  WorkoutPlan copyWithCompanion(WorkoutPlansCompanion data) {
    return WorkoutPlan(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlan(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlan &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name);
}

class WorkoutPlansCompanion extends UpdateCompanion<WorkoutPlan> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<int> rowid;
  const WorkoutPlansCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutPlansCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name);
  static Insertable<WorkoutPlan> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return WorkoutPlansCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlansCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanExercisesTable extends PlanExercises
    with TableInfo<$PlanExercisesTable, PlanExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetRepsMeta = const VerificationMeta(
    'targetReps',
  );
  @override
  late final GeneratedColumn<int> targetReps = GeneratedColumn<int>(
    'target_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetDurationSecMeta = const VerificationMeta(
    'targetDurationSec',
  );
  @override
  late final GeneratedColumn<int> targetDurationSec = GeneratedColumn<int>(
    'target_duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetWeightMeta = const VerificationMeta(
    'targetWeight',
  );
  @override
  late final GeneratedColumn<double> targetWeight = GeneratedColumn<double>(
    'target_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRestSecMeta = const VerificationMeta(
    'targetRestSec',
  );
  @override
  late final GeneratedColumn<int> targetRestSec = GeneratedColumn<int>(
    'target_rest_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    exerciseName,
    exerciseType,
    targetReps,
    targetDurationSec,
    targetWeight,
    targetSets,
    targetRestSec,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseTypeMeta);
    }
    if (data.containsKey('target_reps')) {
      context.handle(
        _targetRepsMeta,
        targetReps.isAcceptableOrUnknown(data['target_reps']!, _targetRepsMeta),
      );
    }
    if (data.containsKey('target_duration_sec')) {
      context.handle(
        _targetDurationSecMeta,
        targetDurationSec.isAcceptableOrUnknown(
          data['target_duration_sec']!,
          _targetDurationSecMeta,
        ),
      );
    }
    if (data.containsKey('target_weight')) {
      context.handle(
        _targetWeightMeta,
        targetWeight.isAcceptableOrUnknown(
          data['target_weight']!,
          _targetWeightMeta,
        ),
      );
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('target_rest_sec')) {
      context.handle(
        _targetRestSecMeta,
        targetRestSec.isAcceptableOrUnknown(
          data['target_rest_sec']!,
          _targetRestSecMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      )!,
      targetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps'],
      ),
      targetDurationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_duration_sec'],
      ),
      targetWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight'],
      ),
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      ),
      targetRestSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_rest_sec'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $PlanExercisesTable createAlias(String alias) {
    return $PlanExercisesTable(attachedDatabase, alias);
  }
}

class PlanExercise extends DataClass implements Insertable<PlanExercise> {
  final int id;
  final String planId;
  final String exerciseName;
  final String exerciseType;
  final int? targetReps;
  final int? targetDurationSec;
  final double? targetWeight;
  final int? targetSets;
  final int? targetRestSec;
  final int orderIndex;
  const PlanExercise({
    required this.id,
    required this.planId,
    required this.exerciseName,
    required this.exerciseType,
    this.targetReps,
    this.targetDurationSec,
    this.targetWeight,
    this.targetSets,
    this.targetRestSec,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<String>(planId);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['exercise_type'] = Variable<String>(exerciseType);
    if (!nullToAbsent || targetReps != null) {
      map['target_reps'] = Variable<int>(targetReps);
    }
    if (!nullToAbsent || targetDurationSec != null) {
      map['target_duration_sec'] = Variable<int>(targetDurationSec);
    }
    if (!nullToAbsent || targetWeight != null) {
      map['target_weight'] = Variable<double>(targetWeight);
    }
    if (!nullToAbsent || targetSets != null) {
      map['target_sets'] = Variable<int>(targetSets);
    }
    if (!nullToAbsent || targetRestSec != null) {
      map['target_rest_sec'] = Variable<int>(targetRestSec);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  PlanExercisesCompanion toCompanion(bool nullToAbsent) {
    return PlanExercisesCompanion(
      id: Value(id),
      planId: Value(planId),
      exerciseName: Value(exerciseName),
      exerciseType: Value(exerciseType),
      targetReps: targetReps == null && nullToAbsent
          ? const Value.absent()
          : Value(targetReps),
      targetDurationSec: targetDurationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDurationSec),
      targetWeight: targetWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeight),
      targetSets: targetSets == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSets),
      targetRestSec: targetRestSec == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRestSec),
      orderIndex: Value(orderIndex),
    );
  }

  factory PlanExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExercise(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<String>(json['planId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      exerciseType: serializer.fromJson<String>(json['exerciseType']),
      targetReps: serializer.fromJson<int?>(json['targetReps']),
      targetDurationSec: serializer.fromJson<int?>(json['targetDurationSec']),
      targetWeight: serializer.fromJson<double?>(json['targetWeight']),
      targetSets: serializer.fromJson<int?>(json['targetSets']),
      targetRestSec: serializer.fromJson<int?>(json['targetRestSec']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<String>(planId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'exerciseType': serializer.toJson<String>(exerciseType),
      'targetReps': serializer.toJson<int?>(targetReps),
      'targetDurationSec': serializer.toJson<int?>(targetDurationSec),
      'targetWeight': serializer.toJson<double?>(targetWeight),
      'targetSets': serializer.toJson<int?>(targetSets),
      'targetRestSec': serializer.toJson<int?>(targetRestSec),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  PlanExercise copyWith({
    int? id,
    String? planId,
    String? exerciseName,
    String? exerciseType,
    Value<int?> targetReps = const Value.absent(),
    Value<int?> targetDurationSec = const Value.absent(),
    Value<double?> targetWeight = const Value.absent(),
    Value<int?> targetSets = const Value.absent(),
    Value<int?> targetRestSec = const Value.absent(),
    int? orderIndex,
  }) => PlanExercise(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    exerciseName: exerciseName ?? this.exerciseName,
    exerciseType: exerciseType ?? this.exerciseType,
    targetReps: targetReps.present ? targetReps.value : this.targetReps,
    targetDurationSec: targetDurationSec.present
        ? targetDurationSec.value
        : this.targetDurationSec,
    targetWeight: targetWeight.present ? targetWeight.value : this.targetWeight,
    targetSets: targetSets.present ? targetSets.value : this.targetSets,
    targetRestSec: targetRestSec.present
        ? targetRestSec.value
        : this.targetRestSec,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  PlanExercise copyWithCompanion(PlanExercisesCompanion data) {
    return PlanExercise(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      targetReps: data.targetReps.present
          ? data.targetReps.value
          : this.targetReps,
      targetDurationSec: data.targetDurationSec.present
          ? data.targetDurationSec.value
          : this.targetDurationSec,
      targetWeight: data.targetWeight.present
          ? data.targetWeight.value
          : this.targetWeight,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      targetRestSec: data.targetRestSec.present
          ? data.targetRestSec.value
          : this.targetRestSec,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanExercise(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetDurationSec: $targetDurationSec, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetRestSec: $targetRestSec, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    exerciseName,
    exerciseType,
    targetReps,
    targetDurationSec,
    targetWeight,
    targetSets,
    targetRestSec,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExercise &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.exerciseName == this.exerciseName &&
          other.exerciseType == this.exerciseType &&
          other.targetReps == this.targetReps &&
          other.targetDurationSec == this.targetDurationSec &&
          other.targetWeight == this.targetWeight &&
          other.targetSets == this.targetSets &&
          other.targetRestSec == this.targetRestSec &&
          other.orderIndex == this.orderIndex);
}

class PlanExercisesCompanion extends UpdateCompanion<PlanExercise> {
  final Value<int> id;
  final Value<String> planId;
  final Value<String> exerciseName;
  final Value<String> exerciseType;
  final Value<int?> targetReps;
  final Value<int?> targetDurationSec;
  final Value<double?> targetWeight;
  final Value<int?> targetSets;
  final Value<int?> targetRestSec;
  final Value<int> orderIndex;
  const PlanExercisesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.targetReps = const Value.absent(),
    this.targetDurationSec = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetRestSec = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  PlanExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String planId,
    required String exerciseName,
    required String exerciseType,
    this.targetReps = const Value.absent(),
    this.targetDurationSec = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.targetRestSec = const Value.absent(),
    required int orderIndex,
  }) : planId = Value(planId),
       exerciseName = Value(exerciseName),
       exerciseType = Value(exerciseType),
       orderIndex = Value(orderIndex);
  static Insertable<PlanExercise> custom({
    Expression<int>? id,
    Expression<String>? planId,
    Expression<String>? exerciseName,
    Expression<String>? exerciseType,
    Expression<int>? targetReps,
    Expression<int>? targetDurationSec,
    Expression<double>? targetWeight,
    Expression<int>? targetSets,
    Expression<int>? targetRestSec,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (targetReps != null) 'target_reps': targetReps,
      if (targetDurationSec != null) 'target_duration_sec': targetDurationSec,
      if (targetWeight != null) 'target_weight': targetWeight,
      if (targetSets != null) 'target_sets': targetSets,
      if (targetRestSec != null) 'target_rest_sec': targetRestSec,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  PlanExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? planId,
    Value<String>? exerciseName,
    Value<String>? exerciseType,
    Value<int?>? targetReps,
    Value<int?>? targetDurationSec,
    Value<double?>? targetWeight,
    Value<int?>? targetSets,
    Value<int?>? targetRestSec,
    Value<int>? orderIndex,
  }) {
    return PlanExercisesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseType: exerciseType ?? this.exerciseType,
      targetReps: targetReps ?? this.targetReps,
      targetDurationSec: targetDurationSec ?? this.targetDurationSec,
      targetWeight: targetWeight ?? this.targetWeight,
      targetSets: targetSets ?? this.targetSets,
      targetRestSec: targetRestSec ?? this.targetRestSec,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (targetReps.present) {
      map['target_reps'] = Variable<int>(targetReps.value);
    }
    if (targetDurationSec.present) {
      map['target_duration_sec'] = Variable<int>(targetDurationSec.value);
    }
    if (targetWeight.present) {
      map['target_weight'] = Variable<double>(targetWeight.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (targetRestSec.present) {
      map['target_rest_sec'] = Variable<int>(targetRestSec.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanExercisesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('targetReps: $targetReps, ')
          ..write('targetDurationSec: $targetDurationSec, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('targetSets: $targetSets, ')
          ..write('targetRestSec: $targetRestSec, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $CompletedWorkoutsTable extends CompletedWorkouts
    with TableInfo<$CompletedWorkoutsTable, CompletedWorkout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletedWorkoutsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planNameMeta = const VerificationMeta(
    'planName',
  );
  @override
  late final GeneratedColumn<String> planName = GeneratedColumn<String>(
    'plan_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseDataMeta = const VerificationMeta(
    'exerciseData',
  );
  @override
  late final GeneratedColumn<String> exerciseData = GeneratedColumn<String>(
    'exercise_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    planId,
    planName,
    exerciseData,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completed_workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletedWorkout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('plan_name')) {
      context.handle(
        _planNameMeta,
        planName.isAcceptableOrUnknown(data['plan_name']!, _planNameMeta),
      );
    } else if (isInserting) {
      context.missing(_planNameMeta);
    }
    if (data.containsKey('exercise_data')) {
      context.handle(
        _exerciseDataMeta,
        exerciseData.isAcceptableOrUnknown(
          data['exercise_data']!,
          _exerciseDataMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseDataMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletedWorkout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletedWorkout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      planName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_name'],
      )!,
      exerciseData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_data'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $CompletedWorkoutsTable createAlias(String alias) {
    return $CompletedWorkoutsTable(attachedDatabase, alias);
  }
}

class CompletedWorkout extends DataClass
    implements Insertable<CompletedWorkout> {
  final int id;
  final String userId;
  final String planId;
  final String planName;
  final String exerciseData;
  final DateTime completedAt;
  const CompletedWorkout({
    required this.id,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.exerciseData,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['plan_id'] = Variable<String>(planId);
    map['plan_name'] = Variable<String>(planName);
    map['exercise_data'] = Variable<String>(exerciseData);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  CompletedWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return CompletedWorkoutsCompanion(
      id: Value(id),
      userId: Value(userId),
      planId: Value(planId),
      planName: Value(planName),
      exerciseData: Value(exerciseData),
      completedAt: Value(completedAt),
    );
  }

  factory CompletedWorkout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletedWorkout(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      planId: serializer.fromJson<String>(json['planId']),
      planName: serializer.fromJson<String>(json['planName']),
      exerciseData: serializer.fromJson<String>(json['exerciseData']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'planId': serializer.toJson<String>(planId),
      'planName': serializer.toJson<String>(planName),
      'exerciseData': serializer.toJson<String>(exerciseData),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  CompletedWorkout copyWith({
    int? id,
    String? userId,
    String? planId,
    String? planName,
    String? exerciseData,
    DateTime? completedAt,
  }) => CompletedWorkout(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    planId: planId ?? this.planId,
    planName: planName ?? this.planName,
    exerciseData: exerciseData ?? this.exerciseData,
    completedAt: completedAt ?? this.completedAt,
  );
  CompletedWorkout copyWithCompanion(CompletedWorkoutsCompanion data) {
    return CompletedWorkout(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      planId: data.planId.present ? data.planId.value : this.planId,
      planName: data.planName.present ? data.planName.value : this.planName,
      exerciseData: data.exerciseData.present
          ? data.exerciseData.value
          : this.exerciseData,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkout(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('planId: $planId, ')
          ..write('planName: $planName, ')
          ..write('exerciseData: $exerciseData, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, planId, planName, exerciseData, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletedWorkout &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.planId == this.planId &&
          other.planName == this.planName &&
          other.exerciseData == this.exerciseData &&
          other.completedAt == this.completedAt);
}

class CompletedWorkoutsCompanion extends UpdateCompanion<CompletedWorkout> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> planId;
  final Value<String> planName;
  final Value<String> exerciseData;
  final Value<DateTime> completedAt;
  const CompletedWorkoutsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.planId = const Value.absent(),
    this.planName = const Value.absent(),
    this.exerciseData = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  CompletedWorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String planId,
    required String planName,
    required String exerciseData,
    required DateTime completedAt,
  }) : userId = Value(userId),
       planId = Value(planId),
       planName = Value(planName),
       exerciseData = Value(exerciseData),
       completedAt = Value(completedAt);
  static Insertable<CompletedWorkout> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? planId,
    Expression<String>? planName,
    Expression<String>? exerciseData,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (planId != null) 'plan_id': planId,
      if (planName != null) 'plan_name': planName,
      if (exerciseData != null) 'exercise_data': exerciseData,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  CompletedWorkoutsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String>? planId,
    Value<String>? planName,
    Value<String>? exerciseData,
    Value<DateTime>? completedAt,
  }) {
    return CompletedWorkoutsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      exerciseData: exerciseData ?? this.exerciseData,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (planName.present) {
      map['plan_name'] = Variable<String>(planName.value);
    }
    if (exerciseData.present) {
      map['exercise_data'] = Variable<String>(exerciseData.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('planId: $planId, ')
          ..write('planName: $planName, ')
          ..write('exerciseData: $exerciseData, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $PendingOperationsTable extends PendingOperations
    with TableInfo<$PendingOperationsTable, PendingOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOperationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, operationType, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $PendingOperationsTable createAlias(String alias) {
    return $PendingOperationsTable(attachedDatabase, alias);
  }
}

class PendingOperation extends DataClass
    implements Insertable<PendingOperation> {
  final int id;
  final String operationType;
  final String data;
  const PendingOperation({
    required this.id,
    required this.operationType,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation_type'] = Variable<String>(operationType);
    map['data'] = Variable<String>(data);
    return map;
  }

  PendingOperationsCompanion toCompanion(bool nullToAbsent) {
    return PendingOperationsCompanion(
      id: Value(id),
      operationType: Value(operationType),
      data: Value(data),
    );
  }

  factory PendingOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOperation(
      id: serializer.fromJson<int>(json['id']),
      operationType: serializer.fromJson<String>(json['operationType']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operationType': serializer.toJson<String>(operationType),
      'data': serializer.toJson<String>(data),
    };
  }

  PendingOperation copyWith({int? id, String? operationType, String? data}) =>
      PendingOperation(
        id: id ?? this.id,
        operationType: operationType ?? this.operationType,
        data: data ?? this.data,
      );
  PendingOperation copyWithCompanion(PendingOperationsCompanion data) {
    return PendingOperation(
      id: data.id.present ? data.id.value : this.id,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperation(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operationType, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOperation &&
          other.id == this.id &&
          other.operationType == this.operationType &&
          other.data == this.data);
}

class PendingOperationsCompanion extends UpdateCompanion<PendingOperation> {
  final Value<int> id;
  final Value<String> operationType;
  final Value<String> data;
  const PendingOperationsCompanion({
    this.id = const Value.absent(),
    this.operationType = const Value.absent(),
    this.data = const Value.absent(),
  });
  PendingOperationsCompanion.insert({
    this.id = const Value.absent(),
    required String operationType,
    required String data,
  }) : operationType = Value(operationType),
       data = Value(data);
  static Insertable<PendingOperation> custom({
    Expression<int>? id,
    Expression<String>? operationType,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationType != null) 'operation_type': operationType,
      if (data != null) 'data': data,
    });
  }

  PendingOperationsCompanion copyWith({
    Value<int>? id,
    Value<String>? operationType,
    Value<String>? data,
  }) {
    return PendingOperationsCompanion(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOperationsCompanion(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $WorkoutPlansTable workoutPlans = $WorkoutPlansTable(this);
  late final $PlanExercisesTable planExercises = $PlanExercisesTable(this);
  late final $CompletedWorkoutsTable completedWorkouts =
      $CompletedWorkoutsTable(this);
  late final $PendingOperationsTable pendingOperations =
      $PendingOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutPlans,
    planExercises,
    completedWorkouts,
    pendingOperations,
  ];
}

typedef $$WorkoutPlansTableCreateCompanionBuilder =
    WorkoutPlansCompanion Function({
      required String id,
      required String userId,
      required String name,
      Value<int> rowid,
    });
typedef $$WorkoutPlansTableUpdateCompanionBuilder =
    WorkoutPlansCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<int> rowid,
    });

class $$WorkoutPlansTableFilterComposer
    extends Composer<_$LocalDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutPlansTableOrderingComposer
    extends Composer<_$LocalDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutPlansTableAnnotationComposer
    extends Composer<_$LocalDatabase, $WorkoutPlansTable> {
  $$WorkoutPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$WorkoutPlansTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $WorkoutPlansTable,
          WorkoutPlan,
          $$WorkoutPlansTableFilterComposer,
          $$WorkoutPlansTableOrderingComposer,
          $$WorkoutPlansTableAnnotationComposer,
          $$WorkoutPlansTableCreateCompanionBuilder,
          $$WorkoutPlansTableUpdateCompanionBuilder,
          (
            WorkoutPlan,
            BaseReferences<_$LocalDatabase, $WorkoutPlansTable, WorkoutPlan>,
          ),
          WorkoutPlan,
          PrefetchHooks Function()
        > {
  $$WorkoutPlansTableTableManager(_$LocalDatabase db, $WorkoutPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion(
                id: id,
                userId: userId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutPlansCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $WorkoutPlansTable,
      WorkoutPlan,
      $$WorkoutPlansTableFilterComposer,
      $$WorkoutPlansTableOrderingComposer,
      $$WorkoutPlansTableAnnotationComposer,
      $$WorkoutPlansTableCreateCompanionBuilder,
      $$WorkoutPlansTableUpdateCompanionBuilder,
      (
        WorkoutPlan,
        BaseReferences<_$LocalDatabase, $WorkoutPlansTable, WorkoutPlan>,
      ),
      WorkoutPlan,
      PrefetchHooks Function()
    >;
typedef $$PlanExercisesTableCreateCompanionBuilder =
    PlanExercisesCompanion Function({
      Value<int> id,
      required String planId,
      required String exerciseName,
      required String exerciseType,
      Value<int?> targetReps,
      Value<int?> targetDurationSec,
      Value<double?> targetWeight,
      Value<int?> targetSets,
      Value<int?> targetRestSec,
      required int orderIndex,
    });
typedef $$PlanExercisesTableUpdateCompanionBuilder =
    PlanExercisesCompanion Function({
      Value<int> id,
      Value<String> planId,
      Value<String> exerciseName,
      Value<String> exerciseType,
      Value<int?> targetReps,
      Value<int?> targetDurationSec,
      Value<double?> targetWeight,
      Value<int?> targetSets,
      Value<int?> targetRestSec,
      Value<int> orderIndex,
    });

class $$PlanExercisesTableFilterComposer
    extends Composer<_$LocalDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableFilterComposer({
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

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDurationSec => $composableBuilder(
    column: $table.targetDurationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRestSec => $composableBuilder(
    column: $table.targetRestSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanExercisesTableOrderingComposer
    extends Composer<_$LocalDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDurationSec => $composableBuilder(
    column: $table.targetDurationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRestSec => $composableBuilder(
    column: $table.targetRestSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanExercisesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetReps => $composableBuilder(
    column: $table.targetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDurationSec => $composableBuilder(
    column: $table.targetDurationSec,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRestSec => $composableBuilder(
    column: $table.targetRestSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );
}

class $$PlanExercisesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $PlanExercisesTable,
          PlanExercise,
          $$PlanExercisesTableFilterComposer,
          $$PlanExercisesTableOrderingComposer,
          $$PlanExercisesTableAnnotationComposer,
          $$PlanExercisesTableCreateCompanionBuilder,
          $$PlanExercisesTableUpdateCompanionBuilder,
          (
            PlanExercise,
            BaseReferences<_$LocalDatabase, $PlanExercisesTable, PlanExercise>,
          ),
          PlanExercise,
          PrefetchHooks Function()
        > {
  $$PlanExercisesTableTableManager(
    _$LocalDatabase db,
    $PlanExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String> exerciseType = const Value.absent(),
                Value<int?> targetReps = const Value.absent(),
                Value<int?> targetDurationSec = const Value.absent(),
                Value<double?> targetWeight = const Value.absent(),
                Value<int?> targetSets = const Value.absent(),
                Value<int?> targetRestSec = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => PlanExercisesCompanion(
                id: id,
                planId: planId,
                exerciseName: exerciseName,
                exerciseType: exerciseType,
                targetReps: targetReps,
                targetDurationSec: targetDurationSec,
                targetWeight: targetWeight,
                targetSets: targetSets,
                targetRestSec: targetRestSec,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String planId,
                required String exerciseName,
                required String exerciseType,
                Value<int?> targetReps = const Value.absent(),
                Value<int?> targetDurationSec = const Value.absent(),
                Value<double?> targetWeight = const Value.absent(),
                Value<int?> targetSets = const Value.absent(),
                Value<int?> targetRestSec = const Value.absent(),
                required int orderIndex,
              }) => PlanExercisesCompanion.insert(
                id: id,
                planId: planId,
                exerciseName: exerciseName,
                exerciseType: exerciseType,
                targetReps: targetReps,
                targetDurationSec: targetDurationSec,
                targetWeight: targetWeight,
                targetSets: targetSets,
                targetRestSec: targetRestSec,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $PlanExercisesTable,
      PlanExercise,
      $$PlanExercisesTableFilterComposer,
      $$PlanExercisesTableOrderingComposer,
      $$PlanExercisesTableAnnotationComposer,
      $$PlanExercisesTableCreateCompanionBuilder,
      $$PlanExercisesTableUpdateCompanionBuilder,
      (
        PlanExercise,
        BaseReferences<_$LocalDatabase, $PlanExercisesTable, PlanExercise>,
      ),
      PlanExercise,
      PrefetchHooks Function()
    >;
typedef $$CompletedWorkoutsTableCreateCompanionBuilder =
    CompletedWorkoutsCompanion Function({
      Value<int> id,
      required String userId,
      required String planId,
      required String planName,
      required String exerciseData,
      required DateTime completedAt,
    });
typedef $$CompletedWorkoutsTableUpdateCompanionBuilder =
    CompletedWorkoutsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String> planId,
      Value<String> planName,
      Value<String> exerciseData,
      Value<DateTime> completedAt,
    });

class $$CompletedWorkoutsTableFilterComposer
    extends Composer<_$LocalDatabase, $CompletedWorkoutsTable> {
  $$CompletedWorkoutsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseData => $composableBuilder(
    column: $table.exerciseData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompletedWorkoutsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CompletedWorkoutsTable> {
  $$CompletedWorkoutsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseData => $composableBuilder(
    column: $table.exerciseData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompletedWorkoutsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CompletedWorkoutsTable> {
  $$CompletedWorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get planName =>
      $composableBuilder(column: $table.planName, builder: (column) => column);

  GeneratedColumn<String> get exerciseData => $composableBuilder(
    column: $table.exerciseData,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$CompletedWorkoutsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $CompletedWorkoutsTable,
          CompletedWorkout,
          $$CompletedWorkoutsTableFilterComposer,
          $$CompletedWorkoutsTableOrderingComposer,
          $$CompletedWorkoutsTableAnnotationComposer,
          $$CompletedWorkoutsTableCreateCompanionBuilder,
          $$CompletedWorkoutsTableUpdateCompanionBuilder,
          (
            CompletedWorkout,
            BaseReferences<
              _$LocalDatabase,
              $CompletedWorkoutsTable,
              CompletedWorkout
            >,
          ),
          CompletedWorkout,
          PrefetchHooks Function()
        > {
  $$CompletedWorkoutsTableTableManager(
    _$LocalDatabase db,
    $CompletedWorkoutsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletedWorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletedWorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletedWorkoutsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> planName = const Value.absent(),
                Value<String> exerciseData = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => CompletedWorkoutsCompanion(
                id: id,
                userId: userId,
                planId: planId,
                planName: planName,
                exerciseData: exerciseData,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required String planId,
                required String planName,
                required String exerciseData,
                required DateTime completedAt,
              }) => CompletedWorkoutsCompanion.insert(
                id: id,
                userId: userId,
                planId: planId,
                planName: planName,
                exerciseData: exerciseData,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompletedWorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $CompletedWorkoutsTable,
      CompletedWorkout,
      $$CompletedWorkoutsTableFilterComposer,
      $$CompletedWorkoutsTableOrderingComposer,
      $$CompletedWorkoutsTableAnnotationComposer,
      $$CompletedWorkoutsTableCreateCompanionBuilder,
      $$CompletedWorkoutsTableUpdateCompanionBuilder,
      (
        CompletedWorkout,
        BaseReferences<
          _$LocalDatabase,
          $CompletedWorkoutsTable,
          CompletedWorkout
        >,
      ),
      CompletedWorkout,
      PrefetchHooks Function()
    >;
typedef $$PendingOperationsTableCreateCompanionBuilder =
    PendingOperationsCompanion Function({
      Value<int> id,
      required String operationType,
      required String data,
    });
typedef $$PendingOperationsTableUpdateCompanionBuilder =
    PendingOperationsCompanion Function({
      Value<int> id,
      Value<String> operationType,
      Value<String> data,
    });

class $$PendingOperationsTableFilterComposer
    extends Composer<_$LocalDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableFilterComposer({
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

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOperationsTableOrderingComposer
    extends Composer<_$LocalDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableOrderingComposer({
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

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOperationsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $PendingOperationsTable> {
  $$PendingOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$PendingOperationsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $PendingOperationsTable,
          PendingOperation,
          $$PendingOperationsTableFilterComposer,
          $$PendingOperationsTableOrderingComposer,
          $$PendingOperationsTableAnnotationComposer,
          $$PendingOperationsTableCreateCompanionBuilder,
          $$PendingOperationsTableUpdateCompanionBuilder,
          (
            PendingOperation,
            BaseReferences<
              _$LocalDatabase,
              $PendingOperationsTable,
              PendingOperation
            >,
          ),
          PendingOperation,
          PrefetchHooks Function()
        > {
  $$PendingOperationsTableTableManager(
    _$LocalDatabase db,
    $PendingOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> data = const Value.absent(),
              }) => PendingOperationsCompanion(
                id: id,
                operationType: operationType,
                data: data,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operationType,
                required String data,
              }) => PendingOperationsCompanion.insert(
                id: id,
                operationType: operationType,
                data: data,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $PendingOperationsTable,
      PendingOperation,
      $$PendingOperationsTableFilterComposer,
      $$PendingOperationsTableOrderingComposer,
      $$PendingOperationsTableAnnotationComposer,
      $$PendingOperationsTableCreateCompanionBuilder,
      $$PendingOperationsTableUpdateCompanionBuilder,
      (
        PendingOperation,
        BaseReferences<
          _$LocalDatabase,
          $PendingOperationsTable,
          PendingOperation
        >,
      ),
      PendingOperation,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$WorkoutPlansTableTableManager get workoutPlans =>
      $$WorkoutPlansTableTableManager(_db, _db.workoutPlans);
  $$PlanExercisesTableTableManager get planExercises =>
      $$PlanExercisesTableTableManager(_db, _db.planExercises);
  $$CompletedWorkoutsTableTableManager get completedWorkouts =>
      $$CompletedWorkoutsTableTableManager(_db, _db.completedWorkouts);
  $$PendingOperationsTableTableManager get pendingOperations =>
      $$PendingOperationsTableTableManager(_db, _db.pendingOperations);
}
