import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_progress_card.dart';
import '../widgets/weight_input_card.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.onStartTraining});
  final VoidCallback onStartTraining;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _dbService = DatabaseService();
  final _supabase = Supabase.instance.client;

  int _workoutsThisWeek = 0;
  Map<String, dynamic>? _lastWorkout;

  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    final count = await _dbService.getWorkoutsThisWeek();
    final last = await _dbService.getLastWorkout();
    if (mounted) {
      setState(() {
        _workoutsThisWeek = count;
        _lastWorkout = last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final userId = _supabase.auth.currentUser?.id;

    return RefreshIndicator(
      onRefresh: _loadWorkoutData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          // ── Begrüßung ────────────────────────────────────────────────────
          _buildHeader(cs),
          const SizedBox(height: 20),

          // ── Workout-Statistiken ──────────────────────────────────────────
          _buildWorkoutStatRow(cs),
          const SizedBox(height: 12),

          if (_lastWorkout != null) ...[
            _buildLastWorkoutCard(cs),
            const SizedBox(height: 12),
          ],

          // ── Training starten ─────────────────────────────────────────────
          ElevatedButton.icon(
            onPressed: widget.onStartTraining,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text("Training starten"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),

          // ── Körperwerte erfassen ──────────────────────────────────────────
          if (userId != null) ...[
            const SizedBox(height: 28),
            _sectionHeader(cs, 'Körperwerte erfassen', Icons.edit_outlined),
            const SizedBox(height: 10),
            const WeightInputCard(),

            // ── Fortschritt je Feld ─────────────────────────────────────────
            const SizedBox(height: 28),
            _sectionHeader(cs, 'Mein Fortschritt', Icons.trending_up),
            const SizedBox(height: 10),
            _buildProgressSection(cs, userId),
          ],
        ],
      ),
    );
  }

  // ── Hilfsmethoden ──────────────────────────────────────────────────────────

  Widget _buildHeader(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hallo Champ!",
          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Text(
          "Bereit für dein Training?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutStatRow(ColorScheme cs) {
    return Row(
      children: [
        _statChip(
          cs,
          icon: Icons.calendar_today_outlined,
          label: 'Diese Woche',
          value: '$_workoutsThisWeek',
          color: AppColors.warning,
        ),
        const SizedBox(width: 12),
        _statChip(
          cs,
          icon: Icons.bolt_outlined,
          label: 'Status',
          value: _workoutsThisWeek > 0 ? 'Aktiv' : 'Pause',
          color: _workoutsThisWeek > 0
              ? AppColors.success
              : cs.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _statChip(
    ColorScheme cs, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastWorkoutCard(ColorScheme cs) {
    final raw = _lastWorkout!['completed_at'];
    final date =
        raw is String ? DateTime.parse(raw).toLocal() : DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history, color: cs.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Letztes Training',
                  style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                ),
                Text(
                  _lastWorkout!['plan_name'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('dd.MM.yy').format(date),
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(ColorScheme cs, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: cs.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(ColorScheme cs, String userId) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _supabase
          .from('user_settings')
          .stream(primaryKey: ['user_id'])
          .eq('user_id', userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final settings = snapshot.data!.first;
        final activeFields = kStatConfig.entries
            .where((e) => settings[e.key] == true)
            .toList();

        if (activeFields.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.tune_outlined,
                  color: cs.onSurfaceVariant,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Keine Felder aktiviert.',
                  style: TextStyle(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  'Aktiviere Felder in den Einstellungen.',
                  style:
                      TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: activeFields.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, index) {
            final cfg = activeFields[index].value;
            return StatProgressCard(
              column: cfg['column']!,
              label: cfg['label']!,
              unit: cfg['unit']!,
            );
          },
        );
      },
    );
  }
}
