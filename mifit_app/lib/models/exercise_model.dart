enum ExerciseType { reps, time }

class ExerciseModel {
  String name;
  ExerciseType type;
  int? reps;
  int? durationSeconds;
  double weight;

  ExerciseModel({
    required this.name,
    this.type = ExerciseType.reps,
    this.reps,
    this.durationSeconds,
    this.weight = 0.0,
  });
}
