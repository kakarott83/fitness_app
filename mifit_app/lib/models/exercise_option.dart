import 'package:flutter/material.dart';

class ExerciseOption {
  final String name;
  final IconData icon;
  const ExerciseOption(this.name, this.icon);
}

const List<ExerciseOption> commonExercises = [
  // KRAFTÜBUNGEN (Icons, die Kraft/Gewichte symbolisieren)
  ExerciseOption('Bankdrücken', Icons.fitness_center),
  ExerciseOption('Kniebeugen', Icons.downhill_skiing), // Gute Hocke-Symbolik
  ExerciseOption('Kreuzheben', Icons.layers), // Symbolisiert das Stapeln/Heben
  ExerciseOption('Schulterdrücken', Icons.unfold_more), // Vertikale Bewegung
  ExerciseOption('Klimmzüge', Icons.keyboard_double_arrow_up),
  ExerciseOption('Liegestütze', Icons.reorder), // Flache, parallele Linien
  // CORE & BAUCH
  ExerciseOption('Plank', Icons.remove), // Statische Linie
  ExerciseOption('Crunches', Icons.rounded_corner), // Beugung
  ExerciseOption('Leg Raises', Icons.vertical_align_top),

  // CARDIO / ZEIT-BASIERT
  ExerciseOption('Laufen', Icons.directions_run),
  ExerciseOption('Radfahren', Icons.directions_bike),
  ExerciseOption(
    'Seilspringen',
    Icons.gesture,
  ), // Symbolisiert das schwingende Seil
  ExerciseOption('Rudern', Icons.rowing),

  // SONSTIGES
  ExerciseOption('Dehnen', Icons.accessibility_new),
  ExerciseOption('Eigene Übung', Icons.add_task),
];
