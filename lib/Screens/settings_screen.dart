import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../Utilities/sound_manager.dart';
import '../Services/user_profile_service.dart';
import 'WordListScreen.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) updateUserName;

  final Function(bool) toggleTheme;
  final bool isDarkTheme;

  const SettingsScreen({
    super.key,
    required this.updateUserName,
    required this.toggleTheme,
    required this.isDarkTheme,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();

    _soundEnabled = SoundManager.isSoundOn;
    _vibrationEnabled = SoundManager.isVibrationOn;

    /// dışarıdan gelen değere senkronize et
    _isDarkMode = widget.isDarkTheme;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleSound(bool value) {
    setState(() => _soundEnabled = value);
    SoundManager.toggleSound(value);
    if (value) SoundManager.playClickSound();
  }

  void _toggleVibration(bool value) {
    setState(() => _vibrationEnabled = value);
    SoundManager.toggleVibration(value);
    if (value) SoundManager.playClickHaptic();
  }

  void _toggleTheme(bool value) {
    setState(() => _isDarkMode = value);
    widget.toggleTheme(value);
  }

  Future<void> _openDictionary() async {
    SoundManager.playClickHaptic();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Kelimeler
      final wordJson =
          await rootBundle.rootBundle.loadString('assets/words.json');
      final List<dynamic> wordData = json.decode(wordJson);

      final Map<String, Map<String, String>> words = {
        for (var item in wordData)
          item['word']: {
            'Anlam': item['Anlam'] ?? '',
            'Anlam1': item['Anlam1'] ?? '',
            'Anlam2': item['Anlam2'] ?? '',
            'level': item['level'] ?? ''
          }
      };

      // Deyimler
      final idiomJson =
          await rootBundle.rootBundle.loadString('assets/idioms.json');
      final List<dynamic> idiomData = json.decode(idiomJson);

      final Map<String, Map<String, String>> idioms = {
        for (var item in idiomData) item['word']: {'Anlam': item['Anlam'] ?? ''}
      };

      // Atasözleri
      final proverbJson =
          await rootBundle.rootBundle.loadString('assets/proverbs.json');
      final List<dynamic> proverbData = json.decode(proverbJson);

      final Map<String, Map<String, String>> proverbs = {
        for (var item in proverbData)
          item['word']: {'Anlam': item['Anlam'] ?? ''}
      };

      if (mounted) Navigator.pop(context);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WordListScreen(
            wordList: words,
            idiomsList: idioms,
            proverbsList: proverbs,
          ),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sözlük yüklenirken hata oluştu: $e"),
        ),
      );
    }
  }

  void _resetProgress() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text(
          "Dikkat! ⚠️",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Tüm ilerlemen, puanların ve favorilerin SİLİNECEK.\n\nBu işlem geri alınamaz.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İPTAL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await UserProfileService.resetProgress();
              widget.updateUserName("Misafir");

              if (mounted) Navigator.pop(context);
              if (mounted) Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tüm veriler sıfırlandı. Temiz sayfa! 📄"),
                ),
              );
            },
            child:
                const Text("EVET, SİL", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text("Genel",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            ),

            /// AYARLAR KARTI
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _soundEnabled,
                    onChanged: _toggleSound,
                    title: const Text("Ses Efektleri",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    secondary: Icon(Icons.volume_up, color: primaryColor),
                  ),
                  SwitchListTile(
                    value: _vibrationEnabled,
                    onChanged: _toggleVibration,
                    title: const Text("Titreşim",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    secondary: Icon(Icons.vibration, color: primaryColor),
                  ),
                  SwitchListTile(
                    value: _isDarkMode,
                    onChanged: _toggleTheme,
                    title: const Text("Karanlık Mod",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Gözlerini yorma 🌙"),
                    secondary: Icon(Icons.dark_mode, color: primaryColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text("Araçlar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            ),

            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.menu_book, color: Colors.orangeAccent),
                title: const Text("Sözlük",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Tüm kelime ve deyimler"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _openDictionary,
              ),
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text("Veri",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "İlerlemeyi Sıfırla",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("XP, Rütbe ve Favoriler silinir."),
                onTap: _resetProgress,
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                "Versiyon 1.1.0",
                style: TextStyle(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
