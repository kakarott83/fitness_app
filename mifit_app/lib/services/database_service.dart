import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:mifit_app/services/local_database.dart';
import 'package:rxdart/rxdart.dart';

import '../models/exercise_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;
  final LocalDatabase _localDb = LocalDatabase();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  DatabaseService() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        _syncPendingOperations();
      }
    });
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }

  // Stream für die Trainingspläne
  Stream<List<Map<String, dynamic>>> get workoutPlansStream {
    final localStream = _localDb.select(_localDb.workoutPlans).watch();
    
    final supabaseStream = _supabase
        .from('workout_plans')
        .stream(primaryKey: ['id']).order('name');

    return Rx.combineLatest2(
        localStream.map((rows) => rows.map((row) {
          final j = row.toJson();
          return <String, dynamic>{
            'id': j['id'],
            'user_id': j['userId'],
            'name': j['name'],
          };
        }).toList()),
        supabaseStream,
        (localData, supabaseData) {
          // Einfache Merge-Strategie: Supabase hat Vorrang
          final localIds = localData.map((d) => d['id']).toSet();
          for (final row in supabaseData) {
            if (!localIds.contains(row['id'])) {
              localData.add(row);
            }
          }
          return localData;
        });
  }

  // Ruft die Historie ab (neueste zuerst)
  Stream<List<Map<String, dynamic>>> get completedWorkoutsStream {
    final localStream = (_localDb.select(_localDb.completedWorkouts)
          ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)]))
        .watch();

    final supabaseStream = _supabase
        .from('completed_workouts')
        .stream(primaryKey: ['id'])
        .order('completed_at', ascending: false);

     return Rx.combineLatest2(
        localStream.map((rows) => rows.map((row) {
          final j = row.toJson();
          return <String, dynamic>{
            'id': j['id'],
            'user_id': j['userId'],
            'plan_id': j['planId'],
            'plan_name': j['planName'],
            'exercise_data': j['exerciseData'],
            'completed_at': j['completedAt'],
          };
        }).toList()),
        supabaseStream,
        (localData, supabaseData) {
          // Einfache Merge-Strategie: Supabase hat Vorrang
          final localIds = localData.map((d) => d['id']).toSet();
          for (final row in supabaseData) {
            if (!localIds.contains(row['id'])) {
              localData.add(row);
            }
          }
          return localData;
        });
  }

  // Löschen eines Plans
  Future<void> deletePlan(String planId) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline: In lokaler DB als "zu löschen" markieren
      await _localDb.into(_localDb.pendingOperations).insert(
            PendingOperationsCompanion.insert(
              operationType: 'deletePlan',
              data: planId,
            ),
          );
      // Aus lokaler DB löschen
      await (_localDb.delete(_localDb.workoutPlans)..where((tbl) => tbl.id.equals(planId))).go();
      return;
    }
    await _supabase.from('workout_plans').delete().eq('id', planId);
    // Auch aus der lokalen DB löschen
    await (_localDb.delete(_localDb.workoutPlans)..where((tbl) => tbl.id.equals(planId))).go();
  }

  // Liefert die Anzahl der Trainings in der aktuellen Woche
  Future<int> getWorkoutsThisWeek() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline: Daten aus lokaler DB holen
      final now = DateTime.now();
      final lastMonday = now.subtract(Duration(days: now.weekday - 1));
      final completed = await (_localDb.select(_localDb.completedWorkouts)
            ..where((tbl) => tbl.completedAt.isBiggerOrEqualValue(lastMonday)))
          .get();
      return completed.length;
    }

    final now = DateTime.now();
    final lastMonday = now.subtract(Duration(days: now.weekday - 1));

    final response = await _supabase
        .from('completed_workouts')
        .select('id')
        .gte('completed_at', lastMonday.toIso8601String());

    return (response as List).length;
  }

  // Liefert das allerletzte Training
  Future<Map<String, dynamic>?> getLastWorkout() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline: Daten aus lokaler DB holen
      final last = await (_localDb.select(_localDb.completedWorkouts)
            ..orderBy([(t) => OrderingTerm(expression: t.completedAt, mode: OrderingMode.desc)])
            ..limit(1))
          .getSingleOrNull();
      if (last == null) return null;
      return {
        'id': last.id,
        'user_id': last.userId,
        'plan_id': last.planId,
        'plan_name': last.planName,
        'exercise_data': jsonDecode(last.exerciseData),
        'completed_at': last.completedAt.toIso8601String(),
      };
    }

    final response = await _supabase
        .from('completed_workouts')
        .select()
        .order('completed_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return response;
  }

  Future<void> saveCompletedWorkout({
    required String planId,
    required String planName,
    required List<Map<String, dynamic>> results,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final completedWorkout = CompletedWorkoutsCompanion(
      userId: Value(user.id),
      planId: Value(planId),
      planName: Value(planName),
      exerciseData: Value(jsonEncode(results)),
      completedAt: Value(DateTime.now()),
    );

    await _localDb.into(_localDb.completedWorkouts).insert(completedWorkout);

    final connectivityResult = await _connectivity.checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      await _supabase.from('completed_workouts').insert({
        'user_id': user.id,
        'plan_id': planId,
        'plan_name': planName,
        'exercise_data': results,
      });
    } else {
      // Offline: In Queue für späteren Upload
      await _localDb.into(_localDb.pendingOperations).insert(
            PendingOperationsCompanion.insert(
              operationType: 'saveCompletedWorkout',
              data: jsonEncode({
                'planId': planId,
                'planName': planName,
                'results': results,
              }),
            ),
          );
    }
  }

  Future<List<ExerciseModel>> getExercisesForPlan(String planId) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline: Daten aus lokaler DB holen
      final exercises = await (_localDb.select(_localDb.planExercises)
            ..where((tbl) => tbl.planId.equals(planId))
            ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
          .get();

      return exercises
          .map(
            (ex) => ExerciseModel(
              name: ex.exerciseName,
              type: ex.exerciseType == 'reps'
                  ? ExerciseType.reps
                  : ExerciseType.time,
              reps: ex.targetReps,
              durationSeconds: ex.targetDurationSec,
              weight: ex.targetWeight ?? 0.0,
              sets: ex.targetSets ?? 1,
              restSeconds: ex.targetRestSec ?? 0,
            ),
          )
          .toList();
    }

    final response = await _supabase
        .from('plan_exercises')
        .select()
        .eq('plan_id', planId)
        .order('order_index');

    // Umwandlung der Datenbank-Daten in deine ExerciseModel-Objekte
    return (response as List)
        .map(
          (ex) => ExerciseModel(
            name: ex['exercise_name'] ?? '',
            type: ex['exercise_type'] == 'reps'
                ? ExerciseType.reps
                : ExerciseType.time,
            reps: ex['target_reps'],
            durationSeconds: ex['target_duration_sec'],
            weight: (ex['target_weight'] as num?)?.toDouble() ?? 0.0,
            sets: (ex['target_sets'] as int?) ?? 1,
            restSeconds: (ex['target_rest_sec'] as int?) ?? 0,
          ),
        )
        .toList();
  }

  // Speichern (Insert oder Update)
  Future<void> savePlan({
    String? editingPlanId,
    required String name,
    required List<ExerciseModel> exercises,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // Offline: In lokaler DB speichern und für späteren Upload vormerken
      String planId = editingPlanId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final plan = WorkoutPlansCompanion(
        id: Value(planId),
        userId: Value(user.id),
        name: Value(name),
      );

      if (editingPlanId != null) {
        await (_localDb.update(_localDb.workoutPlans)..where((tbl) => tbl.id.equals(editingPlanId))).write(plan);
      } else {
        await _localDb.into(_localDb.workoutPlans).insert(plan);
      }

      // Übungen speichern
      await (_localDb.delete(_localDb.planExercises)..where((tbl) => tbl.planId.equals(planId))).go();
      for (var i = 0; i < exercises.length; i++) {
        final exercise = exercises[i];
        await _localDb.into(_localDb.planExercises).insert(
              PlanExercisesCompanion.insert(
                planId: planId,
                exerciseName: exercise.name,
                exerciseType: exercise.type.name,
                targetReps: Value(exercise.reps),
                targetDurationSec: Value(exercise.durationSeconds),
                targetWeight: Value(exercise.weight),
                targetSets: Value(exercise.sets),
                targetRestSec: Value(exercise.restSeconds),
                orderIndex: i,
              ),
            );
      }

      await _localDb.into(_localDb.pendingOperations).insert(
            PendingOperationsCompanion.insert(
              operationType: 'savePlan',
              data: jsonEncode({
                'editingPlanId': editingPlanId,
                'name': name,
                'exercises': exercises.map((e) => e.toJson()).toList(),
              }),
            ),
          );
      return;
    }

    String planId;
    if (editingPlanId != null) {
      planId = editingPlanId;
      await _supabase
          .from('workout_plans')
          .update({'name': name})
          .eq('id', planId);
      await _supabase.from('plan_exercises').delete().eq('plan_id', planId);
    } else {
      final res = await _supabase
          .from('workout_plans')
          .insert({'user_id': user.id, 'name': name})
          .select()
          .single();
      planId = res['id'];
    }

    final exercisesToInsert = exercises
        .asMap()
        .entries
        .map(
          (e) => {
            'plan_id': planId,
            'exercise_name': e.value.name,
            'exercise_type': e.value.type.name,
            'target_reps': e.value.reps,
            'target_duration_sec': e.value.durationSeconds,
            'target_weight': e.value.weight,
            'target_sets': e.value.sets,
            'target_rest_sec': e.value.restSeconds,
            'order_index': e.key,
          },
        )
        .toList();

    await _supabase.from('plan_exercises').insert(exercisesToInsert);
  }

  Future<void> _syncPendingOperations() async {
    final pending = await _localDb.select(_localDb.pendingOperations).get();
    if (pending.isEmpty) return;

    for (final op in pending) {
      try {
        switch (op.operationType) {
          case 'savePlan':
            final data = jsonDecode(op.data);
            await savePlan(
              editingPlanId: data['editingPlanId'],
              name: data['name'],
              exercises: (data['exercises'] as List)
                  .map((e) => ExerciseModel.fromJson(e))
                  .toList(),
            );
            break;
          case 'deletePlan':
            await deletePlan(op.data);
            break;
          case 'saveCompletedWorkout':
             final data = jsonDecode(op.data);
            await saveCompletedWorkout(
              planId: data['planId'],
              planName: data['planName'],
              results: (data['results'] as List).cast<Map<String, dynamic>>(),
            );
            break;
        }
        // Bei Erfolg aus der Queue löschen
        await (_localDb.delete(_localDb.pendingOperations)..where((tbl) => tbl.id.equals(op.id))).go();
      } catch (e) {
        // Fehlerbehandlung: Loggen oder für späteren Versuch in der Queue belassen
        print('Sync failed for operation ${op.id}: $e');
      }
    }
  }
}
