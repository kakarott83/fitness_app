import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../models/exercise_option.dart';

class ExerciseCardEditor extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const ExerciseCardEditor({
    super.key,
    required this.exercise,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Dropdown & Delete
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue:
                        commonExercises.any((e) => e.name == exercise.name)
                        ? exercise.name
                        : null,
                    hint: const Text("Übung wählen"),
                    items: commonExercises
                        .map(
                          (opt) => DropdownMenuItem(
                            value: opt.name,
                            child: Row(
                              children: [
                                Icon(opt.icon, size: 18),
                                const SizedBox(width: 8),
                                Text(opt.name),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      exercise.name = val ?? '';
                      onUpdate();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Typ-Auswahl
            SegmentedButton<ExerciseType>(
              segments: const [
                ButtonSegment(
                  value: ExerciseType.reps,
                  label: Text('Wdh.'),
                  icon: Icon(Icons.repeat),
                ),
                ButtonSegment(
                  value: ExerciseType.time,
                  label: Text('Zeit'),
                  icon: Icon(Icons.timer_outlined),
                ),
              ],
              selected: {exercise.type},
              onSelectionChanged: (newVal) {
                exercise.type = newVal.first;
                onUpdate();
              },
            ),
            const SizedBox(height: 12),
            // Eingaben — Zeile 1: Sätze & Pause
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: exercise.sets.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sätze',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      exercise.sets = int.tryParse(val) ?? 1;
                      onUpdate();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: exercise.restSeconds > 0
                        ? exercise.restSeconds.toString()
                        : null,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Pause (sek)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      exercise.restSeconds = int.tryParse(val) ?? 0;
                      onUpdate();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Eingaben — Zeile 2: Wdh./sek & kg
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: exercise.type == ExerciseType.reps
                        ? exercise.reps?.toString()
                        : exercise.durationSeconds?.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: exercise.type == ExerciseType.reps
                          ? 'Wdh.'
                          : 'sek',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      if (exercise.type == ExerciseType.reps) {
                        exercise.reps = int.tryParse(val);
                      } else {
                        exercise.durationSeconds = int.tryParse(val);
                      }
                      onUpdate();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: exercise.weight > 0
                        ? exercise.weight.toString()
                        : null,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'kg',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      exercise.weight = double.tryParse(val) ?? 0;
                      onUpdate();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
