import 'package:isar/isar.dart';

part 'word_progress.g.dart';

@collection
class WordProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String wordKey; // kelimenin benzersiz anahtarı: word string'i yeter

  int seenCount = 0;
  int correctCount = 0;
  int wrongCount = 0;

  DateTime? lastSeenAt;

  // SRS
  double ease = 2.5;
  int intervalDays = 0;
  DateTime? nextReviewAt;
}
