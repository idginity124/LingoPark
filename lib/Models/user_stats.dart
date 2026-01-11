import 'package:isar/isar.dart';

part 'user_stats.g.dart';

@collection
class UserStats {
  Id id = 1; // tek kayıt gibi kullanacağız

  int dailyGoal = 20;
  int streak = 0;
  DateTime? lastStudyDate;

  int totalCorrect = 0;
  int totalWrong = 0;
}
