import 'active_workout_view.dart';
import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../services/database_service.dart';
import '../widgets/exercise_card_editor.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  final _dbService = DatabaseService(); // Unser neuer Logik-Spezialist
  final _planNameController = TextEditingController();

  bool _isEditing = false;
  String? _editingPlanId;
  final List<ExerciseModel> _exercises = [];

  @override
  void initState() {
    super.initState();
    _planNameController.addListener(() => setState(() {}));
  }

  // LOGIK-WRAPPER
  void _prepareNewPlan() {
    setState(() {
      _isEditing = true;
      _editingPlanId = null;
      _planNameController.clear();
      _exercises.clear();
      _exercises.add(ExerciseModel(name: ''));
    });
  }

  void _editExistingPlan(Map<String, dynamic> plan) async {
    // 1. Übungen über den Service aus Supabase laden
    final loadedExercises = await _dbService.getExercisesForPlan(plan['id']);

    setState(() {
      _isEditing = true;
      _editingPlanId = plan['id'];
      _planNameController.text = plan['name'];

      // 2. Die Liste der Übungen im Editor mit den geladenen Daten füllen
      _exercises.clear();
      _exercises.addAll(loadedExercises);
    });
  }

  void _startWorkout(Map<String, dynamic> plan) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActiveWorkoutView(plan: plan)),
    );
  }

  Future<void> _handleSave() async {
    await _dbService.savePlan(
      editingPlanId: _editingPlanId,
      name: _planNameController.text.trim(),
      exercises: _exercises,
    );
    setState(() => _isEditing = false);
  }

  // HAUPT-UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Plan bearbeiten" : "Meine Workouts"),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: _prepareNewPlan,
              icon: const Icon(Icons.add_circle_outline, size: 28),
            ),
        ],
      ),
      body: _isEditing ? _buildEditor() : _buildList(),
      bottomNavigationBar: _isEditing ? _buildBottomBar() : null,
    );
  }

  Widget _buildList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _dbService.workoutPlansStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final plans = snapshot.data!;

        return ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Dismissible(
              key: Key(plan['id']),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              // HIER DIE LÖSCH-FUNKTION ANKNÜPFEN:
              onDismissed: (direction) => _dbService.deletePlan(plan['id']),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    plan['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // HIER STARTEN:
                  onTap: () => _startWorkout(plan),
                  // HIER BEARBEITEN:
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_note),
                    onPressed: () => _editExistingPlan(plan),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditor() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _planNameController,
            decoration: const InputDecoration(
              labelText: "Name des Plans",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _exercises.length,
            itemBuilder: (context, index) => ExerciseCardEditor(
              exercise: _exercises[index],
              onDelete: () => setState(() => _exercises.removeAt(index)),
              onUpdate: () => setState(() {}),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () =>
              setState(() => _exercises.add(ExerciseModel(name: ''))),
          icon: const Icon(Icons.add),
          label: const Text("Übung hinzufügen"),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              child: const Text("Abbrechen"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  (_planNameController.text.isNotEmpty && _exercises.isNotEmpty)
                  ? _handleSave
                  : null,
              child: const Text("Speichern"),
            ),
          ),
        ],
      ),
    );
  }
}
