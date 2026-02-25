import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart'; // Vergiss nicht: flutter pub add intl

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trainingsverlauf",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: dbService.completedWorkoutsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final workouts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              // Zeitstempel umwandeln
              final DateTime date = DateTime.parse(
                workout['completed_at'],
              ).toLocal();
              final List exerciseData = workout['exercise_data'] ?? [];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  shape:
                      const Border(), // Entfernt die Standard-Linien beim Aufklappen
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    workout['plan_name'] ?? 'Unbenanntes Workout',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('EEEE, dd. MMMM').format(date),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: exerciseData.map<Widget>((ex) {
                          final isReps = ex['type'] == 'reps';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.arrow_right,
                                  size: 18,
                                  color: Colors.blueGrey,
                                ),
                                Expanded(
                                  child: Text(
                                    ex['exercise_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${ex['achieved_weight']} kg",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "× ${ex['achieved_value']} ${isReps ? 'Wdh.' : 'sek'}",
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Noch keine Trainings aufgezeichnet.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
