import 'dart:convert';
import 'package:flutter/services.dart';

class WordRepository {
  Future<Map<String, Map<String, String>>> loadWords() async {
    return _loadJsonData('assets/words.json');
  }

  Future<Map<String, Map<String, String>>> loadIdioms() async {
    return _loadJsonData('assets/idioms.json');
  }

  Future<Map<String, Map<String, String>>> loadProverbs() async {
    return _loadJsonData('assets/proverbs.json');
  }

  Future<Map<String, Map<String, String>>> _loadJsonData(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final decoded = json.decode(jsonString);

      final Map<String, Map<String, String>> result = {};

      // 🔹 1) Eğer liste ise
      if (decoded is List) {
        for (final item in decoded) {
          if (item is! Map) continue;

          final key = (item['word'] ??
                  item['Word'] ??
                  item['kelime'] ??
                  item['Kelime'] ??
                  '')
              .toString()
              .trim();

          if (key.isEmpty) continue;

          String r(v) =>
              (v == null || v.toString() == 'null') ? '' : v.toString();

          result[key] = {
            'Anlam': r(item['Anlam']),
            'Anlam1': r(item['Anlam1']),
            'Anlam2': r(item['Anlam2']),
            'level': r(item['level']),
          };
        }

        return result;
      }

      // 🔹 2) Eğer MAP ise ( { "apple": {...}, ... } )
      if (decoded is Map) {
        decoded.forEach((k, v) {
          if (v is! Map) return;

          String r(v) =>
              (v == null || v.toString() == 'null') ? '' : v.toString();

          result[k.toString()] = {
            'Anlam': r(v['Anlam']),
            'Anlam1': r(v['Anlam1']),
            'Anlam2': r(v['Anlam2']),
            'level': r(v['level']),
          };
        });

        return result;
      }

      // 🔴 Buraya düşerse uyumsuz format
      print("❌ $path beklenen JSON formatında değil.");
      return {};
    } catch (e, s) {
      print('❌ JSON yükleme hatası ($path): $e');
      print(s);
      rethrow; // << önemli: artık MainMenu GERÇEK hatayı görecek
    }
  }
}
