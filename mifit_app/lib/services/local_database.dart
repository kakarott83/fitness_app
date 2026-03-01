import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'local_database.g.dart';

// Define tables
class WorkoutPlans extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class PlanExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get planId => text()();
  TextColumn get exerciseName => text()();
  TextColumn get exerciseType => text()();
  IntColumn get targetReps => integer().nullable()();
  IntColumn get targetDurationSec => integer().nullable()();
  RealColumn get targetWeight => real().nullable()();
  IntColumn get targetSets => integer().nullable()();
  IntColumn get targetRestSec => integer().nullable()();
  IntColumn get orderIndex => integer()();
}

class CompletedWorkouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get planId => text()();
  TextColumn get planName => text()();
  TextColumn get exerciseData => text()();
  DateTimeColumn get completedAt => dateTime()();
}


class PendingOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationType => text()();
  TextColumn get data => text()();
}

@DriftDatabase(tables: [WorkoutPlans, PlanExercises, CompletedWorkouts, PendingOperations])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(planExercises, planExercises.targetSets);
      }
      if (from < 3) {
        await migrator.addColumn(planExercises, planExercises.targetRestSec);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
