import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/word_progress.dart';
import '../Models/user_stats.dart';

class DbService {
  DbService._();

  static late Isar isar;

  /// Uygulama başında **bir kere** çağrılır
  static Future<void> init() async {
    // Eğer zaten açık bir Isar instance varsa onu kullan
    if (Isar.instanceNames.isNotEmpty) {
      isar = Isar.getInstance()!;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [
        WordProgressSchema,
        UserStatsSchema,
      ],
      directory: dir.path,
      inspector: true, // debug için açık, release’te kapat
    );
  }
}
