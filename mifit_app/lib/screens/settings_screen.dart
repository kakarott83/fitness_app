import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Einstellungen laden
  Future<void> _loadSettings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Versuch: Daten laden
      final data = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', user.id)
          .maybeSingle(); // maybeSingle verhindert den Crash bei 0 Zeilen

      if (data == null) {
        // 2. Falls keine Daten da sind: Standard-Einstellungen anlegen
        final defaultSettings = {
          'user_id': user.id,
          'show_weight': true,
          'show_fat': false,
          'show_muscle': false,
          // ... alle anderen auf false
        };

        await _supabase.from('user_settings').insert(defaultSettings);

        setState(() {
          _settings = defaultSettings;
          _isLoading = false;
        });
      } else {
        // 3. Daten waren da, einfach setzen
        setState(() {
          _settings = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Fehler beim Laden der Settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }

  // Einzelne Einstellung speichern
  Future<void> _updateSetting(String key, dynamic value) async {
    setState(() => _settings[key] = value);
    await _supabase
        .from('user_settings')
        .update({key: value})
        .eq('user_id', _supabase.auth.currentUser!.id)
        .maybeSingle(); // Verhindert den Crash, wenn nichts gefunden wird;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          _buildSectionTitle('Persönliches Profil'),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Geburtsdatum'),
            subtitle: Text(_settings['birthday'] ?? 'Nicht gesetzt'),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1990),
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _updateSetting(
                  'birthday',
                  picked.toIso8601String().split('T')[0],
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Geschlecht'),
            trailing: DropdownButton<String>(
              value: _settings['gender'],
              items: [
                'männlich',
                'weiblich',
                'divers',
              ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) => _updateSetting('gender', val),
            ),
          ),
          const Divider(),
          _buildSectionTitle('Sichtbare Erfassungsfelder'),
          _buildSwitch('Gewicht', 'show_weight'),
          _buildSwitch('Körperfett %', 'show_fat'),
          _buildSwitch('Muskelmasse', 'show_muscle'),
          _buildSwitch('Brustumfang', 'show_brust'),
          _buildSwitch('Oberarm', 'show_oberarm'),
          _buildSwitch('Bauchumfang', 'show_bauch'),
          _buildSwitch('Oberschenkel', 'show_oberschenkel'),
          _buildSwitch('Waden', 'show_waden'),
          _buildSwitch("Halsumfang", "show_hals"),
          _buildSwitch("Taillenumfang", "show_tailie"),
          _buildSwitch("Hüftumfang", "show_huefte"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      title,
      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildSwitch(String title, String key) => SwitchListTile(
    title: Text(title),
    value: _settings[key] ?? false,
    onChanged: (val) => _updateSetting(key, val),
  );
}
