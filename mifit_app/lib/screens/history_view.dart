import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dbService = DatabaseService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: dbService.completedWorkoutsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(cs);
        }

        final workouts = snapshot.data!;

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: workouts.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final workout = workouts[index];

            final dynamic rawDate = workout['completed_at'];
            final DateTime date = rawDate is int
                ? DateTime.fromMillisecondsSinceEpoch(rawDate).toLocal()
                : rawDate is String
                    ? DateTime.parse(rawDate).toLocal()
                    : DateTime.now();

            final dynamic rawData = workout['exercise_data'];
            final List exerciseData = rawData is String
                ? (jsonDecode(rawData) as List)
                : rawData is List
                    ? rawData
                    : [];

            return Card(
              child: ExpansionTile(
                shape: const Border(),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: cs.primary,
                    size: 22,
                  ),
                ),
                title: Text(
                  workout['plan_name'] ?? 'Unbenanntes Workout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                subtitle: Text(
                  DateFormat('EEEE, dd. MMMM').format(date),
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        Divider(color: cs.outline, height: 20),
                        ...exerciseData.map<Widget>((ex) {
                          final isReps = ex['type'] == 'reps';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_right,
                                  size: 18,
                                  color: cs.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    ex['exercise_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${ex['achieved_weight']} kg",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: cs.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "× ${ex['achieved_value']} ${isReps ? 'Wdh.' : 'sek'}",
                                  style: TextStyle(color: cs.onSurfaceVariant),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 80,
            color: cs.onSurfaceVariant.withValues(alpha: 0.35),
          ),
          const SizedBox(height: 16),
          Text(
            "Noch keine Trainings aufgezeichnet.",
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
