import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Services/word_repository.dart';
import '../Services/user_profile_service.dart';
import '../Utilities/sound_manager.dart';

// Diğer ekran importları
import 'quiz_screen.dart';
import 'multiple_choice_quiz_screen.dart';
import 'time_attack_screen.dart';
import 'Profile_Screen.dart';
import 'settings_screen.dart';
import 'idiom_test_screen.dart';
import 'listening_quiz_screen.dart';
import 'memory_game_screen.dart';
import 'paragraph_screen.dart';
import 'WordListScreen.dart';

class MainMenu extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkTheme;

  const MainMenu({
    super.key,
    required this.toggleTheme,
    required this.isDarkTheme,
  });

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Veriler
  Map<String, Map<String, String>> wordList = {};
  Map<String, Map<String, String>> idioms = {};
  Map<String, Map<String, String>> proverbs = {};

  // Kullanıcı Bilgileri
  String _userName = "Misafir";
  String _difficulty = "A1";
  int _streak = 0;

  // 🔥 GÜNÜN KELİMESİ DEĞİŞKENLERİ
  String dailyWord = "Loading...";
  String dailyMeaning = "";
  String dailyLevel = "";
  LinearGradient cardGradient =
      const LinearGradient(colors: [Colors.grey, Colors.black]);

  final FlutterTts flutterTts = FlutterTts();

  // Zorluk Etiketleri
  final Map<String, String> difficultyLabels = {
    'A1': 'A1',
    'A2': 'A2',
    'B1': 'B1',
    'B2': 'B2',
    'C1': 'C1',
  };

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    await UserProfileService.init();
    await _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final repo = WordRepository();

      final words = await repo.loadWords();
      final loadedIdioms = await repo.loadIdioms();
      final loadedProverbs = await repo.loadProverbs();

      final profile = await UserProfileService.load();
      final streak = await UserProfileService.checkStreak();

      if (!mounted) return;

      setState(() {
        wordList = words;
        idioms = loadedIdioms;
        proverbs = loadedProverbs;
        _userName = profile.userName;
        _difficulty = profile.difficulty;
        _streak = streak;
      });

      _pickDailyWord();
    } catch (e, s) {
      debugPrint("❌ _loadAllData HATASI: $e");
      debugPrint("📌 STACKTRACE: $s");
      _showErrorDialog("Veriler yüklenirken hata oluştu.");
    }
  }

  // 🦎 BUKALEMUN RENGİ SEÇİCİ
  LinearGradient _getGradientByLevel(String level) {
    String cleanLevel = level.toUpperCase().trim();

    if (cleanLevel.contains("A1") || cleanLevel.contains("A2")) {
      return const LinearGradient(
        colors: [Color(0xFF43cea2), Color(0xFF185a9d)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (cleanLevel.contains("B1") || cleanLevel.contains("B2")) {
      return const LinearGradient(
        colors: [Color(0xFFFF8008), Color(0xFFFFC837)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (cleanLevel.contains("C1") || cleanLevel.contains("C2")) {
      return const LinearGradient(
        colors: [Color(0xFFEB3349), Color(0xFFF45C43)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  void _pickDailyWord() {
    if (wordList.isEmpty) return;

    final random = Random();
    final keys = wordList.keys.toList();
    final randomKey = keys[random.nextInt(keys.length)];
    final data = wordList[randomKey];

    final level = data?['level'] ?? "??";

    setState(() {
      dailyWord = randomKey;
      dailyMeaning = data?['Anlam'] ?? "Anlam yok";
      dailyLevel = level;
      cardGradient = _getGradientByLevel(level);
    });
  }

  void _speakDailyWord() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(dailyWord);
  }

  void _updateUserName(String newName) async {
    await UserProfileService.updateUserName(newName);
    setState(() => _userName = newName);
  }

  Future<void> _updateDifficulty(String newDifficulty) async {
    final profile = await UserProfileService.load();
    await UserProfileService.save(
      userName: profile.userName,
      currentThemeName: profile.currentThemeName,
      difficulty: newDifficulty,
    );
    setState(() => _difficulty = newDifficulty);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Bilgi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Tamam"),
          )
        ],
      ),
    );
  }

  Map<String, Map<String, String>> getFilteredWords() {
    final filtered = <String, Map<String, String>>{};
    wordList.forEach((key, value) {
      if (value['level'] == _difficulty) filtered[key] = value;
    });
    return filtered.isNotEmpty ? filtered : wordList;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    var bgColor = Theme.of(context).scaffoldBackgroundColor;
    var textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Lingo Park",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.toggleTheme(!isDark),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    updateUserName: _updateUserName,
                    toggleTheme: widget.toggleTheme,
                    isDarkTheme: isDark,
                  ),
                ),
              );
              await _loadAllData();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userName: _userName,
                      updateUserName: _updateUserName,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: const Icon(Icons.person, color: Colors.teal),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ÜST BİLGİ ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sol: selamlama + streak
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Merhaba,",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // ✅ streak kullanımı (uyarı da biter)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.25)),
                      ),
                      child: Text(
                        "🔥 Seri: $_streak gün",
                        style: TextStyle(
                          color: isDark ? Colors.orangeAccent : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Sağ: difficulty seçimi
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: difficultyLabels.containsKey(_difficulty)
                          ? _difficulty
                          : 'A1',
                      icon: const Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      onChanged: (String? val) {
                        if (val != null) _updateDifficulty(val);
                      },
                      items: difficultyLabels.keys.map((String key) {
                        return DropdownMenuItem(
                          value: key,
                          child: Text(difficultyLabels[key]!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- 🦎 BUKALEMUN KART ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: cardGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cardGradient.colors.first.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Seviye: $dailyLevel",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          dailyWord,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          dailyMeaning,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.volume_up, color: Colors.white),
                          onPressed: _speakDailyWord,
                        ),
                      ),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.refresh,
                            size: 24, color: Colors.white60),
                        onPressed: _pickDailyWord,
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "Oyun Modları",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),

            // --- MENÜ IZGARASI ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [
                  _buildMenuCard("Kelime Avı", Icons.search, Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(
                          toggleTheme: widget.toggleTheme,
                          isDarkTheme: isDark,
                          difficulty: _difficulty,
                          wordList: getFilteredWords(),
                        ),
                      ),
                    );
                  }),
                  _buildMenuCard("Test Çöz", Icons.checklist, Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultipleChoiceQuizScreen(
                          toggleTheme: widget.toggleTheme,
                          isDarkTheme: isDark,
                          difficulty: _difficulty,
                          wordList: getFilteredWords(),
                        ),
                      ),
                    );
                  }),
                  _buildMenuCard("Zamana Karşı", Icons.timer, Colors.red, () {
                    final list = getFilteredWords();
                    if (list.length < 5) {
                      return _showErrorDialog(
                          "Bu seviyede yeterli kelime yok.");
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeAttackScreen(wordList: list),
                      ),
                    );
                  }),
                  _buildMenuCard("Deyimler", Icons.format_quote, Colors.purple,
                      () {
                    if (idioms.isEmpty)
                      return _showErrorDialog("Deyimler yüklenemedi.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IdiomTestScreen(
                          isDarkTheme: isDark,
                          toggleTheme: widget.toggleTheme,
                          testType: 'idiom',
                          dataList: idioms,
                        ),
                      ),
                    );
                  }),
                  _buildMenuCard(
                      "Atasözleri", Icons.lightbulb, Colors.amber.shade700, () {
                    if (proverbs.isEmpty)
                      return _showErrorDialog("Atasözleri yüklenemedi.");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IdiomTestScreen(
                          isDarkTheme: isDark,
                          toggleTheme: widget.toggleTheme,
                          testType: 'proverb',
                          dataList: proverbs,
                        ),
                      ),
                    );
                  }),
                  _buildMenuCard("Dinleme Testi", Icons.headphones, Colors.teal,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ListeningQuizScreen(wordList: getFilteredWords()),
                      ),
                    );
                  }),
                  _buildMenuCard(
                      "Hafıza Oyunu", Icons.memory, Colors.deepPurple, () {
                    final list = getFilteredWords();
                    if (list.length < 6) {
                      return _showErrorDialog(
                          "Bu seviyede yeterli kelime yok.");
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemoryGameScreen(wordList: list),
                      ),
                    );
                  }),
                  _buildMenuCard("Hikaye Oku", Icons.menu_book, Colors.brown,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ParagraphListScreen(wordList: getFilteredWords()),
                      ),
                    );
                  }),
                  _buildMenuCard(
                      "Hatalarımla Yüzleş", Icons.healing, Colors.pink,
                      () async {
                    final mistakes = await UserProfileService.getMistakes();
                    if (mistakes.isEmpty) {
                      return _showErrorDialog(
                          "Harika! Hiç hatan yok veya hepsi temizlendi. 🎉");
                    }

                    final mistakeMap = <String, Map<String, String>>{};
                    for (final word in mistakes) {
                      if (wordList.containsKey(word)) {
                        mistakeMap[word] = wordList[word]!;
                      }
                    }

                    if (mistakeMap.isEmpty)
                      return _showErrorDialog("Veri hatası.");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultipleChoiceQuizScreen(
                          toggleTheme: widget.toggleTheme,
                          isDarkTheme: isDark,
                          difficulty: _difficulty,
                          wordList: mistakeMap,
                          isMistakeMode: true,
                        ),
                      ),
                    );
                  }),
                  _buildMenuCard(
                      "Favorilerim", Icons.favorite, Colors.redAccent,
                      () async {
                    final profile = await UserProfileService.load();

                    final favMap = <String, Map<String, String>>{};
                    final allData = <String, Map<String, String>>{}
                      ..addAll(wordList)
                      ..addAll(idioms)
                      ..addAll(proverbs);

                    for (final key in profile.favorites) {
                      if (allData.containsKey(key)) favMap[key] = allData[key]!;
                    }

                    if (favMap.isEmpty)
                      return _showErrorDialog("Favori listen boş.");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordListScreen(
                          wordList: favMap,
                          idiomsList: {},
                          proverbsList: {},
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        SoundManager.playClickSound();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
