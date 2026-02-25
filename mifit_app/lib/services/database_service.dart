import '../models/exercise_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // Stream für die Trainingspläne
  Stream<List<Map<String, dynamic>>> get workoutPlansStream =>
      _supabase.from('workout_plans').stream(primaryKey: ['id']).order('name');

  // Ruft die Historie ab (neueste zuerst)
  Stream<List<Map<String, dynamic>>> get completedWorkoutsStream => _supabase
      .from('completed_workouts')
      .stream(primaryKey: ['id'])
      .order('completed_at', ascending: false);

  // Löschen eines Plans
  Future<void> deletePlan(String planId) async {
    await _supabase.from('workout_plans').delete().eq('id', planId);
  }

  // Liefert die Anzahl der Trainings in der aktuellen Woche
  Future<int> getWorkoutsThisWeek() async {
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

    await _supabase.from('completed_workouts').insert({
      'user_id': user.id,
      'plan_id': planId,
      'plan_name': planName,
      'exercise_data': results,
    });
  }

  Future<List<ExerciseModel>> getExercisesForPlan(String planId) async {
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
            'order_index': e.key,
          },
        )
        .toList();

    await _supabase.from('plan_exercises').insert(exercisesToInsert);
  }
}
