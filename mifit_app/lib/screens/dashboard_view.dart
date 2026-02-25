import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.onStartTraining});
  final VoidCallback onStartTraining;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _dbService = DatabaseService();
  int _workoutsThisWeek = 0;
  Map<String, dynamic>? _lastWorkout;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final count = await _dbService.getWorkoutsThisWeek();
    final last = await _dbService.getLastWorkout();
    if (mounted) {
      setState(() {
        _workoutsThisWeek = count;
        _lastWorkout = last;
        _isLoading = false;
      });
    }
  }

  void refresh() {
    _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildStatCards(),
                  const SizedBox(height: 30),
                  _buildLastWorkoutCard(),
                  const SizedBox(height: 30),
                  _buildQuickActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hallo Champ! 👋",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const Text(
          "Bereit für dein Training?",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _statCard(
          "Diese Woche",
          "$_workoutsThisWeek",
          Icons.calendar_today,
          Colors.orange,
        ),
        const SizedBox(width: 15),
        _statCard(
          "Status",
          _workoutsThisWeek > 0 ? "Aktiv" : "Pause",
          Icons.bolt,
          Colors.green,
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastWorkoutCard() {
    if (_lastWorkout == null) return const SizedBox();

    final date = DateTime.parse(_lastWorkout!['completed_at']).toLocal();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Letztes Training",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_lastWorkout!['plan_name']),
            subtitle: Text(DateFormat('dd.MM.yyyy').format(date)),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: widget.onStartTraining,
          icon: const Icon(Icons.play_arrow),
          label: const Text("Training starten"),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
