import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeightInputCard extends StatefulWidget {
  const WeightInputCard({super.key});

  @override
  State<WeightInputCard> createState() => _WeightInputCardState();
}

class _WeightInputCardState extends State<WeightInputCard> {
  final Map<String, TextEditingController> _controllers = {
    'show_weight': TextEditingController(),
    'show_fat': TextEditingController(),
    'show_muscle': TextEditingController(),
    'show_brust': TextEditingController(),
    'show_oberarm': TextEditingController(),
    'show_bauch': TextEditingController(),
    'show_oberschenkel': TextEditingController(),
    'show_waden': TextEditingController(),
  };

  final Map<String, String> _labels = {
    'show_weight': 'Gewicht', 'show_fat': 'Fett %', 'show_muscle': 'Muskel',
    'show_brust': 'Brust', 'show_oberarm': 'Arm', 'show_bauch': 'Bauch',
    'show_oberschenkel': 'Bein', 'show_waden': 'Wade',
    'show_hals': 'Hals', 'show_tailie': 'Taille', 'show_huefte': 'Hüfte', // NEU
  };

  final Map<String, String> _dbMapping = {
    'show_weight': 'weight',
    'show_fat': 'body_fat',
    'show_muscle': 'muscle_mass',
    'show_brust': 'chest', 'show_oberarm': 'upper_arm', 'show_bauch': 'waist',
    'show_oberschenkel': 'thigh', 'show_waden': 'calf',
    'show_hals': 'neck',
    'show_tailie': 'waist_custom',
    'show_huefte': 'hip', // NEU
  };

  Future<void> _save() async {
    final user = Supabase.instance.client.auth.currentUser;
    final Map<String, dynamic> toSave = {'user_id': user!.id};

    _controllers.forEach((key, ctrl) {
      if (ctrl.text.isNotEmpty) {
        toSave[_dbMapping[key]!] = double.parse(
          ctrl.text.replaceFirst(',', '.'),
        );
      }
    });

    try {
      // Hier ist der asynchrone Aufruf (das Warten auf die Datenbank)
      await Supabase.instance.client.from('body_stats').insert(toSave);

      // --- HIER MUSS ES HIN ---
      if (!mounted) return;
      // Ab hier ist sichergestellt, dass das Widget noch existiert

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Daten gespeichert! ✅')));

      // Felder leeren
      for (var c in _controllers.values) {
        c.clear();
      }
      FocusScope.of(context).unfocus();
    } catch (e) {
      // Auch hier nach dem catch sicherheitshalber prüfen
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('user_settings')
          .stream(primaryKey: ['user_id'])
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }
        final settings = snapshot.data!.first;
        final activeKeys = _labels.keys
            .where((k) => settings[k] == true)
            .toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: activeKeys
                      .map(
                        (k) => SizedBox(
                          width: (MediaQuery.of(context).size.width / 2) - 35,
                          child: TextField(
                            controller: _controllers[k],
                            decoration: InputDecoration(
                              labelText: _labels[k],
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text("Speichern"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
