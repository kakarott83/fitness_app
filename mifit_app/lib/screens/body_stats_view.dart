import 'package:flutter/material.dart';

// Stelle sicher, dass "class" klein und "BodyStatsView" exakt so geschrieben ist
class BodyStatsView extends StatefulWidget {
  const BodyStatsView({super.key});

  @override
  State<BodyStatsView> createState() => _BodyStatsViewState();
}

class _BodyStatsViewState extends State<BodyStatsView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Hier landet dein alter Dashboard-Code"));
  }
}
