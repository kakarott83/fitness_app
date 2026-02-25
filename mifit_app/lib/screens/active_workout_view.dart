import 'package:flutter/material.dart';
import '../models/exercise_option.dart';
import '../services/database_service.dart';
import '../models/exercise_model.dart'; // Wichtig: ExerciseModel importieren

class ActiveWorkoutView extends StatefulWidget {
  final Map<String, dynamic> plan;
  const ActiveWorkoutView({super.key, required this.plan});

  @override
  State<ActiveWorkoutView> createState() => _ActiveWorkoutViewState();
}

class _ActiveWorkoutViewState extends State<ActiveWorkoutView> {
  final _dbService = DatabaseService();

  // Wir nutzen jetzt die Liste der Modelle statt Maps
  List<ExerciseModel> _exercises = [];
  bool _isLoading = true;

  // Controller Mapping: Wir nutzen den Index, da unsere Modelle keine DB-ID im Objekt halten müssen
  final List<TextEditingController> _weightControllers = [];
  final List<TextEditingController> _valueControllers = [];

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  IconData _getIconForName(String name) {
    return commonExercises
        .firstWhere(
          (e) => e.name == name,
          orElse: () => const ExerciseOption('Unbekannt', Icons.fitness_center),
        )
        .icon;
  }

  Future<void> _fetchExercises() async {
    try {
      // Nutzt jetzt den zentralen Service
      final data = await _dbService.getExercisesForPlan(widget.plan['id']);

      setState(() {
        _exercises = data;
        for (var ex in _exercises) {
          _weightControllers.add(
            TextEditingController(text: ex.weight.toString()),
          );
          _valueControllers.add(
            TextEditingController(
              text:
                  (ex.type == ExerciseType.reps ? ex.reps : ex.durationSeconds)
                      ?.toString() ??
                  '',
            ),
          );
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Fehler beim Laden: $e");
    }
  }

  Future<void> _finishWorkout() async {
    try {
      final List<Map<String, dynamic>> results = [];

      for (int i = 0; i < _exercises.length; i++) {
        results.add({
          'exercise_name': _exercises[i].name,
          'achieved_weight': double.tryParse(_weightControllers[i].text) ?? 0,
          'achieved_value': int.tryParse(_valueControllers[i].text) ?? 0,
          'type': _exercises[i].type.name,
        });
      }

      await _dbService.saveCompletedWorkout(
        planId: widget.plan['id'],
        planName: widget.plan['name'],
        results: results,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Training erfolgreich beendet!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Fehler beim Speichern: $e");
    }
  }

  @override
  void dispose() {
    for (var c in _weightControllers) {
      c.dispose();
    }
    for (var c in _valueControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan['name']),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final ex = _exercises[index];
                final isReps = ex.type == ExerciseType.reps;

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.withValues(
                                alpha: 0.1,
                              ),
                              child: Icon(
                                _getIconForName(ex.name),
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              ex.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _weightControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Gewicht',
                                  suffixText: 'kg',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _valueControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: isReps ? 'Wiederh.' : 'Sekunden',
                                  suffixText: isReps ? 'Wdh' : 'sek',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _finishWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Workout beenden',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
