import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/stat_progress_card.dart';

class WeightInputCard extends StatefulWidget {
  const WeightInputCard({super.key});

  @override
  State<WeightInputCard> createState() => _WeightInputCardState();
}

class _WeightInputCardState extends State<WeightInputCard> {
  final Map<String, TextEditingController> _controllers = {
    for (final key in kStatConfig.keys) key: TextEditingController(),
  };

  Future<void> _save() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final Map<String, dynamic> toSave = {'user_id': user.id};
    for (final entry in kStatConfig.entries) {
      final ctrl = _controllers[entry.key];
      if (ctrl != null && ctrl.text.isNotEmpty) {
        toSave[entry.value['column']!] =
            double.tryParse(ctrl.text.replaceFirst(',', '.'));
      }
    }

    if (toSave.length <= 1) return; // nur user_id, nichts eingegeben

    try {
      await Supabase.instance.client.from('body_stats').insert(toSave);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daten gespeichert!')),
      );
      for (var c in _controllers.values) {
        c.clear();
      }
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return const SizedBox();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('user_settings')
          .stream(primaryKey: ['user_id'])
          .eq('user_id', userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final settings = snapshot.data!.first;
        final activeKeys =
            kStatConfig.keys.where((k) => settings[k] == true).toList();

        if (activeKeys.isEmpty) return const SizedBox();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: activeKeys.map((k) {
                    final cfg = kStatConfig[k]!;
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width / 2) - 37,
                      child: TextField(
                        controller: _controllers[k],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: cfg['label'],
                          suffixText: cfg['unit'],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Speichern'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
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
}
