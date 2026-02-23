import 'widgets/weight_chart.dart';
import 'screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/weight_input_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _userSettings;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  // Lädt die Sichtbarkeits-Einstellungen aus der Datenbank
  Future<void> _loadUserSettings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final data = await _supabase
        .from('user_settings')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (mounted) {
      setState(() {
        _userSettings = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyFit Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              // Beim Zurückkommen aus den Settings laden wir die Ansicht neu
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              _loadUserSettings();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _supabase.auth.signOut(),
          ),
        ],
      ),
      body: _userSettings == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Eingabe-Bereich
                    WeightInputCard(key: UniqueKey()),

                    const SizedBox(height: 24),

                    // 2. Chart-Bereich
                    const Text(
                      'Fortschritt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                      height: 350, // Platz für Chart + Umschalt-Buttons
                      child: WeightChart(),
                    ),

                    const SizedBox(height: 24),

                    // 3. Historie-Bereich mit dynamischen Feldern
                    const Text(
                      'Historie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _supabase
                          .from('body_stats')
                          .stream(primaryKey: ['id'])
                          .order('created_at', ascending: false),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Noch keine Einträge vorhanden.'),
                          );
                        }

                        final logs = snapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final item = logs[index];
                            final id = item['id'];
                            final date = DateTime.parse(
                              item['created_at'],
                            ).toLocal();

                            // Dynamischen Subtitle basierend auf Settings bauen
                            List<String> details = [];
                            if (_userSettings?['show_fat'] == true &&
                                item['body_fat'] != null) {
                              details.add('Fett: ${item['body_fat']}%');
                            }
                            if (_userSettings?['show_muscle'] == true &&
                                item['muscle_mass'] != null) {
                              details.add('Muskel: ${item['muscle_mass']}kg');
                            }
                            if (_userSettings?['show_hals'] == true &&
                                item['neck'] != null) {
                              details.add('Hals: ${item['neck']}cm');
                            }
                            if (_userSettings?['show_tailie'] == true &&
                                item['waist_custom'] != null) {
                              details.add('Taille: ${item['waist_custom']}cm');
                            }
                            if (_userSettings?['show_huefte'] == true &&
                                item['hip'] != null) {
                              details.add('Hüfte: ${item['hip']}cm');
                            }

                            return Dismissible(
                              key: Key(id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Löschen?'),
                                    content: const Text(
                                      'Eintrag wirklich entfernen?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Abbrechen'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text(
                                          'Löschen',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) async {
                                await _supabase
                                    .from('body_stats')
                                    .delete()
                                    .eq('id', id);
                              },
                              child: ListTile(
                                leading: const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                title: Text('${item['weight']} kg'),
                                subtitle: Text(
                                  '${date.day}.${date.month}.${date.year}${details.isNotEmpty ? '  •  ${details.join('  •  ')}' : ''}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
