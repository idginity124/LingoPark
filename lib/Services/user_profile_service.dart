import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/progress_service.dart';

/// -----------------------
///  🔑 PREF ANAHTARLARI
/// -----------------------
class PrefKeys {
  static const userName = "userName";
  static const theme = "theme";
  static const difficulty = "difficulty";
  static const favorites = "favorites";
  static const xp = "xp";
  static const streak = "streak";
  static const lastLoginDate = "lastLoginDate";

  static const savedQuizWords = "saved_quiz_words";
  static const savedQuizIndex = "saved_quiz_index";
  static const hasSavedQuiz = "has_saved_quiz";

  static const mistakes = "mistakes";
}

/// -----------------------
///  👤 KULLANICI PROFİL MODELİ
/// -----------------------
class UserProfile {
  final String currentThemeName;
  final String userName;
  final String difficulty;
  final List<String> favorites;
  final int xp;
  final int streak;
  final String lastLoginDate;

  UserProfile({
    required this.currentThemeName,
    required this.userName,
    required this.difficulty,
    required this.favorites,
    required this.xp,
    required this.streak,
    required this.lastLoginDate,
  });

  /// ⭐ copyWith (Reaktif kullanım için)
  UserProfile copyWith({
    String? currentThemeName,
    String? userName,
    String? difficulty,
    List<String>? favorites,
    int? xp,
    int? streak,
    String? lastLoginDate,
  }) {
    return UserProfile(
      currentThemeName: currentThemeName ?? this.currentThemeName,
      userName: userName ?? this.userName,
      difficulty: difficulty ?? this.difficulty,
      favorites: favorites ?? this.favorites,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
    );
  }

  /// ⭐ Map’e çevir
  Map<String, dynamic> toMap() {
    return {
      "currentThemeName": currentThemeName,
      "userName": userName,
      "difficulty": difficulty,
      "favorites": favorites,
      "xp": xp,
      "streak": streak,
      "lastLoginDate": lastLoginDate,
    };
  }

  /// ⭐ Map’ten Profil oluştur
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      currentThemeName: map["currentThemeName"] ?? "Sistem",
      userName: map["userName"] ?? "Misafir",
      difficulty: map["difficulty"] ?? "A1",
      favorites: List<String>.from(map["favorites"] ?? []),
      xp: map["xp"] ?? 0,
      streak: map["streak"] ?? 0,
      lastLoginDate: map["lastLoginDate"] ?? "",
    );
  }

  /// ⭐ JSON EXPORT – IMPORT
  String toJson() => jsonEncode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(jsonDecode(source));

  /// 🏆 Rütbe
  String get rankTitle {
    if (xp < 200) return "🐣 Çaylak";
    if (xp < 1000) return "🤓 Öğrenci";
    if (xp < 3000) return "📚 Bilgin";
    if (xp < 6000) return "🧠 Uzman";
    return "👑 Dil Üstadı";
  }

  int get nextRankTarget {
    if (xp < 200) return 200;
    if (xp < 1000) return 1000;
    if (xp < 3000) return 3000;
    if (xp < 6000) return 6000;
    return 10000;
  }

  /// 🏅 BAŞARIMLAR
  List<Map<String, dynamic>> get achievements {
    return [
      {
        'icon': '🌱',
        'title': 'Yeni Başlayan',
        'desc': 'Maceraya adım attın!',
        'locked': false,
      },
      {
        'icon': '🔥',
        'title': 'Alev Aldı',
        'desc': '3 gün üst üste girdin!',
        'locked': streak < 3,
      },
      {
        'icon': '🚀',
        'title': 'Roket',
        'desc': '1000 XP puanına ulaştın!',
        'locked': xp < 1000,
      },
      {
        'icon': '💎',
        'title': 'Elmas Zihin',
        'desc': '5000 XP puanına ulaştın!',
        'locked': xp < 5000,
      },
      {
        'icon': '📅',
        'title': 'İstikrarlı',
        'desc': '7 gün boyunca seri yaptın!',
        'locked': streak < 7,
      },
    ];
  }
}

/// -----------------------
///  🛠️ PROFIL SERVİSİ
/// -----------------------
class UserProfileService {
  static SharedPreferences? _prefs;

  /// güvenli başlatıcı
  static Future<void> _ensureInit() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> init() async => _ensureInit();

  /// ⭐ SADECE TARİH (YYYY-MM-DD)
  static String _dateOnly(DateTime d) => "${d.year.toString().padLeft(4, '0')}-"
      "${d.month.toString().padLeft(2, '0')}-"
      "${d.day.toString().padLeft(2, '0')}";

  /// 📥 PROFİL YÜKLE
  static Future<UserProfile> load() async {
    await _ensureInit();

    return UserProfile(
      currentThemeName: _prefs!.getString(PrefKeys.theme) ?? "Sistem",
      userName: _prefs!.getString(PrefKeys.userName) ?? "Misafir",
      difficulty: _prefs!.getString(PrefKeys.difficulty) ?? "A1",
      favorites: _prefs!.getStringList(PrefKeys.favorites) ?? [],
      xp: _prefs!.getInt(PrefKeys.xp) ?? 0,
      streak: _prefs!.getInt(PrefKeys.streak) ?? 0,
      lastLoginDate: _prefs!.getString(PrefKeys.lastLoginDate) ?? '',
    );
  }

  /// 💾 PROFİL KAYDET
  static Future<void> save({
    required String userName,
    required String currentThemeName,
    required String difficulty,
    List<String>? favorites,
    int? xp,
    int? streak,
    String? lastLoginDate,
  }) async {
    await _ensureInit();

    await _prefs!.setString(PrefKeys.userName, userName);
    await _prefs!.setString(PrefKeys.theme, currentThemeName);
    await _prefs!.setString(PrefKeys.difficulty, difficulty);

    if (favorites != null) {
      await _prefs!.setStringList(PrefKeys.favorites, favorites);
    }
    if (xp != null) await _prefs!.setInt(PrefKeys.xp, xp);
    if (streak != null) await _prefs!.setInt(PrefKeys.streak, streak);
    if (lastLoginDate != null) {
      await _prefs!.setString(PrefKeys.lastLoginDate, lastLoginDate);
    }
  }

  /// ⭐ FAVORİLER
  static Future<List<String>> getFavorites() async {
    await _ensureInit();
    return _prefs!.getStringList(PrefKeys.favorites) ?? [];
  }

  static Future<void> toggleFavorite(String word) async {
    await _ensureInit();
    final list = _prefs!.getStringList(PrefKeys.favorites) ?? [];

    list.contains(word) ? list.remove(word) : list.add(word);

    await _prefs!.setStringList(PrefKeys.favorites, list);
  }

  /// ⭐ XP GÜNCELLEME — güvenli
  static Future<int> addXp(int amount) async {
    await _ensureInit();

    final current = _prefs!.getInt(PrefKeys.xp) ?? 0;
    final updated = (current + amount).clamp(0, 1000000);

    await _prefs!.setInt(PrefKeys.xp, updated);
    return updated;
  }

  /// 🔥 STREAK KONTROL
  static Future<int> checkStreak() async {
    await _ensureInit();

    final today = DateTime.now();
    final todayClean = DateTime(today.year, today.month, today.day);

    final lastStr = _prefs!.getString(PrefKeys.lastLoginDate) ?? "";
    int streak = _prefs!.getInt(PrefKeys.streak) ?? 0;

    DateTime? lastDate;

    if (lastStr.isNotEmpty) {
      try {
        lastDate = DateTime.parse(lastStr);
      } catch (_) {
        final p = lastStr.split('-');
        if (p.length == 3) {
          lastDate = DateTime(
            int.tryParse(p[0]) ?? today.year,
            int.tryParse(p[1]) ?? today.month,
            int.tryParse(p[2]) ?? today.day,
          );
        }
      }
    }

    if (lastDate == null) {
      streak = 1;
    } else {
      final lastClean = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = todayClean.difference(lastClean).inDays;

      if (diff == 0) {
        // bugün girmişti → streak aynı
      } else if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        streak = 1;
      }
    }

    await _prefs!.setInt(PrefKeys.streak, streak);
    await _prefs!.setString(PrefKeys.lastLoginDate, _dateOnly(todayClean));

    return streak;
  }

  /// 🔄 İSİM GÜNCELLE
  static Future<void> updateUserName(String name) async {
    await _ensureInit();
    await _prefs!.setString(PrefKeys.userName, name);
  }

  /// 🧨 TAM RESET (Prefs + Isar progress)
  static Future<void> resetProgress() async {
    await _ensureInit();

    await _prefs!.remove(PrefKeys.xp);
    await _prefs!.remove(PrefKeys.streak);
    await _prefs!.remove(PrefKeys.favorites);
    await _prefs!.remove(PrefKeys.lastLoginDate);
    await _prefs!.remove(PrefKeys.mistakes);

    await clearQuizProgress();

    // ✅ Isar tarafını da temizle
    await ProgressService.clearAllProgress();
  }

  /// 🧠 TEST KAYIT SİSTEMİ
  static Future<void> saveQuizProgress(List<String> words, int index) async {
    await _ensureInit();

    await _prefs!.setStringList(PrefKeys.savedQuizWords, words);
    await _prefs!.setInt(PrefKeys.savedQuizIndex, index);
    await _prefs!.setBool(PrefKeys.hasSavedQuiz, true);
  }

  static Future<Map<String, dynamic>?> getQuizProgress() async {
    await _ensureInit();

    if (!(_prefs!.getBool(PrefKeys.hasSavedQuiz) ?? false)) return null;

    return {
      "words": _prefs!.getStringList(PrefKeys.savedQuizWords) ?? [],
      "index": _prefs!.getInt(PrefKeys.savedQuizIndex) ?? 0,
    };
  }

  static Future<void> clearQuizProgress() async {
    await _ensureInit();

    await _prefs!.remove(PrefKeys.savedQuizWords);
    await _prefs!.remove(PrefKeys.savedQuizIndex);
    await _prefs!.setBool(PrefKeys.hasSavedQuiz, false);
  }

  /// ❌ HATALI KELİME KUTUSU
  static Future<void> addMistake(String word) async {
    await _ensureInit();

    final list = _prefs!.getStringList(PrefKeys.mistakes) ?? [];
    if (!list.contains(word)) list.add(word);

    await _prefs!.setStringList(PrefKeys.mistakes, list);
  }

  static Future<void> removeMistake(String word) async {
    await _ensureInit();

    final list = _prefs!.getStringList(PrefKeys.mistakes) ?? [];
    list.remove(word);

    await _prefs!.setStringList(PrefKeys.mistakes, list);
  }

  static Future<List<String>> getMistakes() async {
    await _ensureInit();
    return _prefs!.getStringList(PrefKeys.mistakes) ?? [];
  }
}
