enum ExerciseType { reps, time }

class ExerciseModel {
  String name;
  ExerciseType type;
  int? reps;
  int? durationSeconds;
  double weight;
  int sets;
  int restSeconds;

  ExerciseModel({
    required this.name,
    this.type = ExerciseType.reps,
    this.reps,
    this.durationSeconds,
    this.weight = 0.0,
    this.sets = 1,
    this.restSeconds = 0,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] as String,
      type: ExerciseType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ExerciseType.reps,
      ),
      reps: json['reps'] as int?,
      durationSeconds: json['durationSeconds'] as int?,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      sets: (json['sets'] as int?) ?? 1,
      restSeconds: (json['restSeconds'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'reps': reps,
      'durationSeconds': durationSeconds,
      'weight': weight,
      'sets': sets,
      'restSeconds': restSeconds,
    };
  }
}
