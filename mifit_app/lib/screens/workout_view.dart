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
  final _dbService = DatabaseService();
  final _planNameController = TextEditingController();

  bool _isEditing = false;
  String? _editingPlanId;
  final List<ExerciseModel> _exercises = [];

  @override
  void initState() {
    super.initState();
    _planNameController.addListener(() => setState(() {}));
  }

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
    final loadedExercises = await _dbService.getExercisesForPlan(plan['id']);
    setState(() {
      _isEditing = true;
      _editingPlanId = plan['id'];
      _planNameController.text = plan['name'];
      _exercises.clear();
      _exercises.addAll(loadedExercises);
    });
  }

  void _startWorkout(Map<String, dynamic> plan) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ActiveWorkoutView(plan: plan)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Plan bearbeiten" : "Meine Workouts"),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: _prepareNewPlan,
              icon: const Icon(Icons.add_circle_outline, size: 26),
            ),
        ],
      ),
      body: _isEditing ? _buildEditor() : _buildList(),
      bottomNavigationBar: _isEditing ? _buildBottomBar() : null,
    );
  }

  Widget _buildList() {
    final cs = Theme.of(context).colorScheme;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _dbService.workoutPlansStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final plans = snapshot.data!;

        if (plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 72,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 16),
                Text(
                  "Noch keine Pläne vorhanden.",
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _prepareNewPlan,
                  icon: const Icon(Icons.add),
                  label: const Text("Ersten Plan erstellen"),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: plans.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final plan = plans[index];
            return Dismissible(
              key: Key(plan['id']),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: cs.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.delete_outline, color: cs.onError),
              ),
              onDismissed: (_) => _dbService.deletePlan(plan['id']),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: cs.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    plan['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  onTap: () => _startWorkout(plan),
                  trailing: IconButton(
                    icon: Icon(Icons.edit_outlined, color: cs.onSurfaceVariant),
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _planNameController,
            decoration: const InputDecoration(labelText: "Name des Plans"),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemCount: _exercises.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
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
        const SizedBox(height: 4),
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
