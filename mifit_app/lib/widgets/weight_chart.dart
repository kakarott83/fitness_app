import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeightChart extends StatefulWidget {
  const WeightChart({super.key});

  @override
  State<WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  final _supabase = Supabase.instance.client;

  // Standardmäßig selektiertes Feld (DB-Spaltenname)
  String _selectedField = 'weight';

  // Mapping: Einstellungs-Key zu Datenbank-Spalte und Label
  // Mapping: Einstellungs-Key zu Datenbank-Spalte und Label
  final Map<String, Map<String, String>> _config = {
    'show_weight': {'column': 'weight', 'label': 'Gewicht'},
    'show_fat': {'column': 'body_fat', 'label': 'Fett %'},
    'show_muscle': {'column': 'muscle_mass', 'label': 'Muskel'},
    'show_brust': {'column': 'chest', 'label': 'Brust'},
    'show_oberarm': {'column': 'upper_arm', 'label': 'Arm'},
    'show_bauch': {'column': 'waist', 'label': 'Bauch'},
    'show_oberschenkel': {'column': 'thigh', 'label': 'Bein'},
    'show_waden': {'column': 'calf', 'label': 'Wade'},
    // HIER DIE ERGÄNZUNGEN:
    'show_hals': {'column': 'neck', 'label': 'Hals'},
    'show_tailie': {'column': 'waist_custom', 'label': 'Taille'},
    'show_huefte': {'column': 'hip', 'label': 'Hüfte'},
  };

  @override
  Widget build(BuildContext context) {
    final userId = _supabase.auth.currentUser!.id;

    return Column(
      children: [
        // 1. DYNAMISCHE BUTTONS (aus den User Settings)
        StreamBuilder<Map<String, dynamic>>(
          stream: _supabase
              .from('user_settings')
              .stream(primaryKey: ['user_id'])
              .eq('user_id', userId)
              .map((list) => list.first),
          builder: (context, settingsSnapshot) {
            if (!settingsSnapshot.hasData) return const SizedBox(height: 50);

            final settings = settingsSnapshot.data!;
            List<ButtonSegment<String>> segments = [];

            _config.forEach((key, info) {
              if (settings[key] == true) {
                segments.add(
                  ButtonSegment(
                    value: info['column']!,
                    label: Text(
                      info['label']!,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                );
              }
            });

            if (segments.isEmpty) return const Text("Keine Felder aktiviert");

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: SegmentedButton<String>(
                  segments: segments,
                  selected: {_selectedField},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedField = newSelection.first;
                    });
                  },
                ),
              ),
            );
          },
        ),

        // 2. DAS CHART
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _supabase
                .from('body_stats')
                .stream(primaryKey: ['id'])
                .order('created_at', ascending: true),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Keine Daten vorhanden'));
              }

              // Filtere Daten, die einen Wert für das gewählte Feld haben
              final filteredData = snapshot.data!
                  .where((e) => e[_selectedField] != null)
                  .toList();
              if (filteredData.isEmpty) {
                return const Center(child: Text('Keine Daten vorhanden'));
              }

              List<FlSpot> spots = [];
              for (int i = 0; i < filteredData.length; i++) {
                double val = (filteredData[i][_selectedField] as num)
                    .toDouble();
                spots.add(FlSpot(i.toDouble(), val));
              }

              return LineChart(
                LineChartData(
                  clipData: const FlClipData.all(),
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
                        getTitlesWidget: (val, meta) => Text(
                          val.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx >= 0 && idx < filteredData.length) {
                            final date = DateTime.parse(
                              filteredData[idx]['created_at'],
                            );
                            return Text(
                              '${date.day}.${date.month}.',
                              style: const TextStyle(fontSize: 9),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blueAccent,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blueAccent.withValues(alpha: 0.2),
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
