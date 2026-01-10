import 'dart:math';
import 'package:isar/isar.dart';

import '../Models/user_stats.dart';
import '../Models/word_progress.dart';
import 'db_service.dart';

class ProgressService {
  static DateTime _now() => DateTime.now();

  /// SRS güncelleme
  static void _applySrs(WordProgress p, {required bool correct}) {
    final now = _now();

    p.lastSeenAt = now;
    p.seenCount++;

    if (correct) {
      p.correctCount++;
      p.ease = (p.ease + 0.05).clamp(1.3, 3.0);
      final next = p.intervalDays == 0 ? 1 : (p.intervalDays * p.ease).round();
      p.intervalDays = max(1, next); // 0 olmasın
    } else {
      p.wrongCount++;
      p.ease = (p.ease - 0.2).clamp(1.3, 3.0);
      p.intervalDays = 1;
    }

    p.nextReviewAt = now.add(Duration(days: p.intervalDays));
  }

  /// ✅ Var olan progress'i getir (yoksa null)
  /// findFirst bazı projelerde "görünmüyor" gibi olabiliyor.
  /// Bu yüzden önce findFirst deniyoruz, yoksa findAll fallback.
  static Future<WordProgress?> _getProgressByKey(
    Isar isar,
    String wordKey,
  ) async {
    // 1) En hızlı yol (varsa)
    try {
      return await isar.wordProgress
          .filter()
          .wordKeyEqualTo(wordKey)
          .findFirst();
    } catch (_) {
      // 2) Fallback: findAll + first
      final list =
          await isar.wordProgress.where().wordKeyEqualTo(wordKey).findAll();
      if (list.isEmpty) return null;
      return list.first;
    }
  }

  /// ✅ Doğru/Yanlış cevabı kaydet
  static Future<void> recordAnswer({
    required String wordKey,
    required bool correct,
  }) async {
    final isar = DbService.isar;

    await isar.writeTxn(() async {
      // WordProgress getir veya oluştur
      var p = await _getProgressByKey(isar, wordKey);
      p ??= (WordProgress()..wordKey = wordKey);

      _applySrs(p, correct: correct);
      await isar.wordProgress.put(p);

      // UserStats tek kayıt
      var stats = await isar.userStats.get(1);
      stats ??= UserStats();

      if (correct) {
        stats.totalCorrect++;
      } else {
        stats.totalWrong++;
      }

      await isar.userStats.put(stats);
    });
  }

  /// ✅ Tüm progress'i sıfırla (reset butonu için)
  static Future<void> clearAllProgress() async {
    final isar = DbService.isar;

    await isar.writeTxn(() async {
      await isar.wordProgress.clear();
      await isar.userStats.clear();
    });
  }

  /// ✅ Kelimeyi "göründü" olarak işaretle (skip vb.)
  static Future<void> markSeen({
    required String wordKey,
  }) async {
    final isar = DbService.isar;

    await isar.writeTxn(() async {
      var p = await _getProgressByKey(isar, wordKey);
      p ??= (WordProgress()..wordKey = wordKey);

      final now = _now();
      p.lastSeenAt = now;
      p.seenCount++;

      // Skip sonrası çok uzağa atmasın
      p.intervalDays = 1;
      p.nextReviewAt = now.add(const Duration(days: 1));

      await isar.wordProgress.put(p);
    });
  }
}
