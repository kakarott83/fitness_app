import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../models/exercise_option.dart';
import '../services/database_service.dart';
import '../models/exercise_model.dart';
import '../theme/app_theme.dart';

class ActiveWorkoutView extends StatefulWidget {
  final Map<String, dynamic> plan;
  const ActiveWorkoutView({super.key, required this.plan});

  @override
  State<ActiveWorkoutView> createState() => _ActiveWorkoutViewState();
}

class _ActiveWorkoutViewState extends State<ActiveWorkoutView> {
  final _dbService = DatabaseService();

  List<ExerciseModel> _exercises = [];
  bool _isLoading = true;

  // Controllers für Reps-Modus
  final List<TextEditingController> _weightControllers = [];
  final List<TextEditingController> _valueControllers = [];

  // Timer-Modus
  bool _timerMode = false;
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _secondsRemaining = 0;
  bool _isPaused = true;
  Timer? _countdownTimer;

  // Auto-Start-Einstellung
  bool _autoStart = true;

  // Pause-Phase
  bool _isResting = false;
  int _restSecondsRemaining = 0;
  Timer? _restTimer;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  IconData _getIconForName(String name) {
    return commonExercises
        .firstWhere(
          (e) => e.name == name,
          orElse: () => const ExerciseOption('Unbekannt', Icons.fitness_center),
        )
        .icon;
  }

  Future<void> _fetchExercises() async {
    try {
      final data = await _dbService.getExercisesForPlan(widget.plan['id']);

      setState(() {
        _exercises = data;
        for (var ex in _exercises) {
          _weightControllers.add(
            TextEditingController(text: ex.weight.toString()),
          );
          _valueControllers.add(
            TextEditingController(
              text:
                  (ex.type == ExerciseType.reps ? ex.reps : ex.durationSeconds)
                      ?.toString() ??
                  '',
            ),
          );
        }
        _isLoading = false;

        if (_exercises.any((e) => e.type == ExerciseType.time)) {
          _timerMode = true;
          _initCurrentExercise();
        }
      });
    } catch (e) {
      debugPrint("Fehler beim Laden: $e");
    }
  }

  void _initCurrentExercise() {
    _countdownTimer?.cancel();
    _isPaused = true;
    _currentSet = 1;
    final ex = _exercises[_currentExerciseIndex];
    if (ex.type == ExerciseType.time) {
      _secondsRemaining = ex.durationSeconds ?? 0;
    }
  }

  void _initCurrentSet() {
    _countdownTimer?.cancel();
    _isPaused = true;
    final ex = _exercises[_currentExerciseIndex];
    if (ex.type == ExerciseType.time) {
      _secondsRemaining = ex.durationSeconds ?? 0;
    }
  }

  int get _maxSets =>
      _exercises.isEmpty ? 1 : _exercises.map((e) => e.sets).reduce(max);

  int get _totalSteps => _maxSets * _exercises.length;

  int get _currentStep =>
      (_currentSet - 1) * _exercises.length + _currentExerciseIndex + 1;

  ExerciseModel? get _nextExercise {
    if (_currentExerciseIndex < _exercises.length - 1) {
      return _exercises[_currentExerciseIndex + 1];
    } else if (_currentSet < _maxSets) {
      return _exercises[0];
    }
    return null;
  }

  // ── Übungs-Timer ──────────────────────────────────────────────────────────

  void _toggleTimer() {
    if (_isPaused) {
      setState(() => _isPaused = false);
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          timer.cancel();
          _advanceExercise();
        }
      });
    } else {
      _countdownTimer?.cancel();
      setState(() => _isPaused = true);
    }
  }

  void _resetTimer() => setState(_initCurrentSet);

  // ── Pause-Phase ────────────────────────────────────────────────────────────

  void _startRest(int seconds) {
    setState(() {
      _isResting = true;
      _restSecondsRemaining = seconds;
    });
    if (_autoStart) _startRestTimer();
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        setState(() => _restSecondsRemaining--);
      } else {
        timer.cancel();
        _doAdvance();
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    _doAdvance();
  }

  // ── Ablauf-Steuerung ───────────────────────────────────────────────────────

  void _advanceExercise() {
    _countdownTimer?.cancel();
    final ex = _exercises[_currentExerciseIndex];
    final hasNextStep = _currentExerciseIndex < _exercises.length - 1 ||
        _currentSet < _maxSets;

    if (hasNextStep && ex.restSeconds > 0) {
      _startRest(ex.restSeconds);
    } else {
      _doAdvance();
    }
  }

  void _doAdvance() {
    _restTimer?.cancel();
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _isResting = false;
        _currentExerciseIndex++;
        _initCurrentSet();
      });
    } else if (_currentSet < _maxSets) {
      setState(() {
        _isResting = false;
        _currentSet++;
        _currentExerciseIndex = 0;
        _initCurrentSet();
      });
    } else {
      setState(() => _isResting = false);
      _finishWorkout();
      return;
    }

    if (_autoStart &&
        _exercises[_currentExerciseIndex].type == ExerciseType.time) {
      _toggleTimer();
    }
  }

  // ── Workout beenden ────────────────────────────────────────────────────────

  Future<void> _finishWorkout() async {
    try {
      final List<Map<String, dynamic>> results = [];
      for (int i = 0; i < _exercises.length; i++) {
        results.add({
          'exercise_name': _exercises[i].name,
          'achieved_weight': double.tryParse(_weightControllers[i].text) ?? 0,
          'achieved_value': int.tryParse(_valueControllers[i].text) ?? 0,
          'type': _exercises[i].type.name,
        });
      }

      await _dbService.saveCompletedWorkout(
        planId: widget.plan['id'],
        planName: widget.plan['name'],
        results: results,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Training erfolgreich beendet!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      debugPrint("Fehler beim Speichern: $e");
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _restTimer?.cancel();
    for (var c in _weightControllers) {
      c.dispose();
    }
    for (var c in _valueControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan['name']),
        actions: _timerMode
            ? [
                Tooltip(
                  message: _autoStart ? 'Automatisch' : 'Manuell',
                  child: Row(
                    children: [
                      Icon(
                        _autoStart
                            ? Icons.play_circle_outline
                            : Icons.touch_app,
                        size: 18,
                        color: cs.onSurfaceVariant,
                      ),
                      Switch(
                        value: _autoStart,
                        onChanged: (v) => setState(() => _autoStart = v),
                        activeThumbColor: cs.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _timerMode
              ? (_isResting ? _buildRestView(cs) : _buildTimerView(cs))
              : _buildListView(cs),
      bottomNavigationBar: _timerMode ? null : _buildBottomButton(cs),
    );
  }

  // ── Timer-Ansicht ──────────────────────────────────────────────────────────

  Widget _buildTimerView(ColorScheme cs) {
    final ex = _exercises[_currentExerciseIndex];
    final isTimeExercise = ex.type == ExerciseType.time;
    final isLastSet = _currentSet == _maxSets;
    final isLastExercise = _currentExerciseIndex == _exercises.length - 1;
    final isLast = isLastExercise && isLastSet;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          // Fortschritt
          Text(
            'Schritt $_currentStep / $_totalSteps',
            style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const Spacer(),

          // Icon + Name
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIconForName(ex.name), size: 40, color: cs.primary),
          ),
          const SizedBox(height: 20),
          Text(
            ex.name,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Satz $_currentSet / $_maxSets',
            style: TextStyle(fontSize: 18, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 32),

          // Timer oder Wdh.-Anzeige
          if (isTimeExercise) ...[
            Text(
              _formatTime(_secondsRemaining),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              label: Text(_isPaused ? 'Starten' : 'Pause'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
            ),
          ] else ...[
            Text(
              '${ex.reps ?? "?"} Wdh.',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            if (ex.weight > 0) ...[
              const SizedBox(height: 8),
              Text(
                '${ex.weight} kg',
                style: TextStyle(fontSize: 22, color: cs.onSurfaceVariant),
              ),
            ],
          ],

          const Spacer(),

          // Aktionsbuttons
          Row(
            children: [
              if (isTimeExercise) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Neu starten'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: ElevatedButton(
                  onPressed: _advanceExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLast ? AppColors.success : cs.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isLast ? 'Workout beenden' : 'Weiter',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Pause-Ansicht ──────────────────────────────────────────────────────────

  Widget _buildRestView(ColorScheme cs) {
    final next = _nextExercise;
    final isTimerRunning = _restTimer?.isActive ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          Text(
            'Schritt $_currentStep / $_totalSteps',
            style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const Spacer(),

          Icon(Icons.self_improvement, size: 72, color: cs.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            'Pause',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 8),
            Text(
              'Als nächstes: ${next.name}',
              style: TextStyle(fontSize: 16, color: cs.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 32),

          Text(
            _formatTime(_restSecondsRemaining),
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: cs.onSurface,
            ),
          ),

          if (!_autoStart && !isTimerRunning) ...[
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startRestTimer,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Pause starten'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
            ),
          ],

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _skipRest,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Pause überspringen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Listen-Ansicht ─────────────────────────────────────────────────────────

  Widget _buildListView(ColorScheme cs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        final ex = _exercises[index];
        final isReps = ex.type == ExerciseType.reps;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForName(ex.name),
                        color: cs.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      ex.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                Divider(height: 28, color: cs.outline),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _weightControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Gewicht',
                          suffixText: 'kg',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _valueControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: isReps ? 'Wiederh.' : 'Sekunden',
                          suffixText: isReps ? 'Wdh' : 'sek',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _finishWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: const Text(
          'Workout beenden',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
