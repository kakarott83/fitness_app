import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

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

  Future<void> _loadSettings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (data == null) {
        final defaultSettings = {
          'user_id': user.id,
          'show_weight': true,
          'show_fat': false,
          'show_muscle': false,
        };
        await _supabase.from('user_settings').insert(defaultSettings);
        setState(() {
          _settings = defaultSettings;
          _isLoading = false;
        });
      } else {
        setState(() {
          _settings = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Fehler beim Laden der Settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    setState(() => _settings[key] = value);
    await _supabase
        .from('user_settings')
        .update({key: value})
        .eq('user_id', _supabase.auth.currentUser!.id)
        .maybeSingle();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        children: [
          // ── Erscheinungsbild ──────────────────────────────────────────────
          _sectionTitle(cs, 'Erscheinungsbild'),
          _buildThemeSelector(cs),
          const Divider(height: 1),

          // ── Persönliches Profil ───────────────────────────────────────────
          _sectionTitle(cs, 'Persönliches Profil'),
          ListTile(
            leading: const Icon(Icons.cake_outlined),
            title: const Text('Geburtsdatum'),
            subtitle: Text(_settings['birthday'] ?? 'Nicht gesetzt'),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime(1990),
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _updateSetting('birthday', picked.toIso8601String().split('T')[0]);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('Geschlecht'),
            trailing: DropdownButton<String>(
              value: _settings['gender'],
              underline: const SizedBox(),
              items: ['männlich', 'weiblich', 'divers']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (val) => _updateSetting('gender', val),
            ),
          ),
          const Divider(height: 1),

          // ── Sichtbare Felder ──────────────────────────────────────────────
          _sectionTitle(cs, 'Sichtbare Erfassungsfelder'),
          _buildSwitch('Gewicht', 'show_weight'),
          _buildSwitch('Körperfett %', 'show_fat'),
          _buildSwitch('Muskelmasse', 'show_muscle'),
          _buildSwitch('Brustumfang', 'show_brust'),
          _buildSwitch('Oberarm', 'show_oberarm'),
          _buildSwitch('Bauchumfang', 'show_bauch'),
          _buildSwitch('Oberschenkel', 'show_oberschenkel'),
          _buildSwitch('Waden', 'show_waden'),
          _buildSwitch('Halsumfang', 'show_hals'),
          _buildSwitch('Taillenumfang', 'show_tailie'),
          _buildSwitch('Hüftumfang', 'show_huefte'),
          const Divider(height: 1),

          // ── Account ───────────────────────────────────────────────────────
          _sectionTitle(cs, 'Account'),
          ListTile(
            leading: Icon(Icons.logout, color: cs.error),
            title: Text('Abmelden', style: TextStyle(color: cs.error)),
            onTap: () => Supabase.instance.client.auth.signOut(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionTitle(ColorScheme cs, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
    child: Text(
      title,
      style: TextStyle(
        color: cs.primary,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 0.8,
      ),
    ),
  );

  Widget _buildThemeSelector(ColorScheme cs) {
    final current = AppTheme.themeNotifier.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.palette_outlined, color: cs.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Theme',
              style: TextStyle(color: cs.onSurface, fontSize: 15),
            ),
          ),
          _themeChip(
            label: 'Hell',
            icon: Icons.light_mode_outlined,
            mode: ThemeMode.light,
            current: current,
            cs: cs,
          ),
          const SizedBox(width: 8),
          _themeChip(
            label: 'Dunkel',
            icon: Icons.dark_mode_outlined,
            mode: ThemeMode.dark,
            current: current,
            cs: cs,
          ),
          const SizedBox(width: 8),
          _themeChip(
            label: 'System',
            icon: Icons.settings_suggest_outlined,
            mode: ThemeMode.system,
            current: current,
            cs: cs,
          ),
        ],
      ),
    );
  }

  Widget _themeChip({
    required String label,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode current,
    required ColorScheme cs,
  }) {
    final selected = current == mode;
    return GestureDetector(
      onTap: () => setState(() => AppTheme.themeNotifier.value = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? cs.primary.withValues(alpha: 0.15)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? cs.primary : cs.outline,
            width: selected ? 1.5 : 0.8,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? cs.primary : cs.onSurfaceVariant),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, String key) => SwitchListTile(
    title: Text(title),
    value: _settings[key] ?? false,
    onChanged: (val) => _updateSetting(key, val),
  );
}
