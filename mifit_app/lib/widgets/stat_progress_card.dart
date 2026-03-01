import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

// Mapping: settings-key → DB-Spalte, Label, Einheit
const Map<String, Map<String, String>> kStatConfig = {
  'show_weight':       {'column': 'weight',       'label': 'Gewicht',      'unit': 'kg'},
  'show_fat':          {'column': 'body_fat',      'label': 'Körperfett',   'unit': '%'},
  'show_muscle':       {'column': 'muscle_mass',   'label': 'Muskelmasse',  'unit': '%'},
  'show_brust':        {'column': 'chest',         'label': 'Brustumfang',  'unit': 'cm'},
  'show_oberarm':      {'column': 'upper_arm',     'label': 'Oberarm',      'unit': 'cm'},
  'show_bauch':        {'column': 'waist',         'label': 'Bauch',        'unit': 'cm'},
  'show_oberschenkel': {'column': 'thigh',         'label': 'Oberschenkel', 'unit': 'cm'},
  'show_waden':        {'column': 'calf',          'label': 'Waden',        'unit': 'cm'},
  'show_hals':         {'column': 'neck',          'label': 'Halsumfang',   'unit': 'cm'},
  'show_tailie':       {'column': 'waist_custom',  'label': 'Taille',       'unit': 'cm'},
  'show_huefte':       {'column': 'hip',           'label': 'Hüftumfang',   'unit': 'cm'},
};

/// Zeigt eine einzelne Kennzahl mit Verlaufschart.
class StatProgressCard extends StatelessWidget {
  final String column; // DB-Spaltenname, z.B. 'weight'
  final String label;  // Anzeigename, z.B. 'Gewicht'
  final String unit;   // Einheit, z.B. 'kg'

  const StatProgressCard({
    super.key,
    required this.column,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('body_stats')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('created_at', ascending: true),
      builder: (context, snapshot) {
        final all = snapshot.data ?? [];
        final data = all.where((e) => e[column] != null).toList();

        final latest = data.isNotEmpty
            ? (data.last[column] as num).toDouble()
            : null;
        final previous = data.length >= 2
            ? (data[data.length - 2][column] as num).toDouble()
            : null;
        final delta =
            (latest != null && previous != null) ? latest - previous : null;

        final spots = data
            .asMap()
            .entries
            .map((e) =>
                FlSpot(e.key.toDouble(), (e.value[column] as num).toDouble()))
            .toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (delta != null) _DeltaBadge(delta: delta),
                  ],
                ),
                const SizedBox(height: 6),

                // ── Aktueller Wert ──────────────────────────────────────────
                latest != null
                    ? RichText(
                        text: TextSpan(
                          text:
                              latest % 1 == 0
                                  ? latest.toStringAsFixed(0)
                                  : latest.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: ' $unit',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        '– $unit',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurfaceVariant,
                        ),
                      ),

                // ── Datum letzter Eintrag ────────────────────────────────────
                if (data.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Zuletzt: ${DateFormat('dd.MM.yy').format(DateTime.parse(data.last['created_at']))}',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],

                const SizedBox(height: 14),

                // ── Chart ───────────────────────────────────────────────────
                SizedBox(
                  height: 90,
                  child: spots.length >= 2
                      ? _buildChart(cs, isDark, spots)
                      : Center(
                          child: Text(
                            'Noch keine Verlaufsdaten',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(ColorScheme cs, bool isDark, List<FlSpot> spots) {
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) < 0.5 ? 0.5 : (maxY - minY) * 0.2;

    return LineChart(
      LineChartData(
        minY: minY - padding,
        maxY: maxY + padding,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: ((maxY - minY) / 3).clamp(0.1, double.infinity),
          getDrawingHorizontalLine: (_) => FlLine(
            color: cs.outline.withValues(alpha: 0.3),
            strokeWidth: 0.5,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (val, _) => Text(
                val.toStringAsFixed(
                  val % 1 == 0 ? 0 : 1,
                ),
                style: TextStyle(
                  fontSize: 9,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: cs.primary,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, _, index) => FlDotCirclePainter(
                radius: index == spots.length - 1 ? 4 : 2.5,
                color: index == spots.length - 1
                    ? cs.primary
                    : cs.primary.withValues(alpha: 0.6),
                strokeWidth: 0,
                strokeColor: Colors.transparent,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  cs.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                  cs.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => cs.surfaceContainerHighest,
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      s.y.toStringAsFixed(1),
                      TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  final double delta;
  const _DeltaBadge({required this.delta});

  @override
  Widget build(BuildContext context) {
    final isZero = delta.abs() < 0.05;
    final color = isZero
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : (delta > 0 ? AppColors.warning : AppColors.success);
    final icon = isZero
        ? Icons.remove
        : (delta > 0 ? Icons.arrow_upward : Icons.arrow_downward);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            delta.abs().toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
