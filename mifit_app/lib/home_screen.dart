import 'screens/workout_view.dart';
import 'screens/history_view.dart';
import 'screens/dashboard_view.dart';
import 'screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Diese Liste steuert, was angezeigt wird
    final List<Widget> screens = [
      DashboardView(onStartTraining: () => _changeTab(1)), // Index 0
      const WorkoutView(), // Index 1
      const HistoryView(), // Index 2 (früher BodyStats)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Körper' : 'Training'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      // IndexedStack hält den Zustand beider Tabs im Speicher
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Status'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Pläne',
          ),
        ],
      ),
    );
  }
}
