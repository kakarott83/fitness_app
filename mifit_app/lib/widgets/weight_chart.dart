import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/stat_progress_card.dart';

/// Vollbild-Chart mit Feldauswahl — wird nicht mehr im Dashboard verwendet,
/// kann aber separat eingebunden werden.
class WeightChart extends StatefulWidget {
  const WeightChart({super.key});

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  final _supabase = Supabase.instance.client;
  String _selectedField = 'weight';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final userId = _supabase.auth.currentUser!.id;

    return Column(
      children: [
        // ── Feld-Auswahl ──────────────────────────────────────────────────
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _supabase
              .from('user_settings')
              .stream(primaryKey: ['user_id'])
              .eq('user_id', userId),
          builder: (context, snap) {
            if (!snap.hasData || snap.data!.isEmpty) {
              return const SizedBox(height: 50);
            }
            final settings = snap.data!.first;
            final segments = kStatConfig.entries
                .where((e) => settings[e.key] == true)
                .map((e) => ButtonSegment<String>(
                      value: e.value['column']!,
                      label: Text(
                        e.value['label']!,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ))
                .toList();

            if (segments.isEmpty) {
              return Text(
                'Keine Felder aktiviert',
                style: TextStyle(color: cs.onSurfaceVariant),
              );
            }

            // Sicherstellen dass _selectedField gültig ist
            final validValues = segments.map((s) => s.value).toSet();
            if (!validValues.contains(_selectedField)) {
              _selectedField = segments.first.value;
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 12),
              child: SegmentedButton<String>(
                segments: segments,
                selected: {_selectedField},
                onSelectionChanged: (s) =>
                    setState(() => _selectedField = s.first),
              ),
            );
          },
        ),

        // ── Chart ─────────────────────────────────────────────────────────
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _supabase
                .from('body_stats')
                .stream(primaryKey: ['id'])
                .eq('user_id', userId)
                .order('created_at', ascending: true),
            builder: (context, snapshot) {
              final data = (snapshot.data ?? [])
                  .where((e) => e[_selectedField] != null)
                  .toList();

              if (data.isEmpty) {
                return Center(
                  child: Text(
                    'Keine Daten vorhanden',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                );
              }

              final spots = data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(
                        e.key.toDouble(),
                        (e.value[_selectedField] as num).toDouble(),
                      ))
                  .toList();

              return LineChart(
                LineChartData(
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: cs.outline.withValues(alpha: 0.3),
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: cs.outline, width: 0.5),
                      left: BorderSide(color: cs.outline, width: 0.5),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (val, _) => Text(
                          val.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 10,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) {
                            return const SizedBox();
                          }
                          final date =
                              DateTime.parse(data[idx]['created_at']);
                          return Text(
                            '${date.day}.${date.month}.',
                            style: TextStyle(
                              fontSize: 9,
                              color: cs.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: cs.primary,
                      barWidth: 2.5,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: cs.primary.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
