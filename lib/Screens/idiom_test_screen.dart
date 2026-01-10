import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class IdiomTestScreen extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) toggleTheme;
  final String testType;
  final Map<String, Map<String, String>> dataList;

  const IdiomTestScreen({
    super.key,
    required this.isDarkTheme,
    required this.toggleTheme,
    required this.testType,
    required this.dataList,
  });

  @override
  _IdiomTestScreenState createState() => _IdiomTestScreenState();
}

class _IdiomTestScreenState extends State<IdiomTestScreen> {
  late List<Map<String, String>> items = [];
  late SharedPreferences prefs;

  String currentItem = '';
  String correctAnswer = '';
  List<String> options = [];

  bool isAnswered = false;
  bool isCorrect = false;
  String message = '';

  int askedCount = 0;

  /// 🟢 Yeni sayaçlar
  int correctCount = 0;
  int wrongCount = 0;

  String get _title =>
      widget.testType == 'proverb' ? 'Atasözü Testi' : 'Deyim Testi';

  @override
  void initState() {
    super.initState();
    _initQuiz();
  }

  Future<void> _initQuiz() async {
    prefs = await SharedPreferences.getInstance();

    items = widget.dataList.entries.map((entry) {
      return {
        'word': entry.key,
        'meaning': entry.value['Anlam'] ?? '',
      };
    }).toList();

    items.shuffle();

    _loadQuestion();
  }

  /// 🔥 RASTGELE SEÇ – LİSTEDEN SİL (TEKRAR YOK)
  void _loadQuestion() {
    if (items.isEmpty) {
      setState(() {
        currentItem = '';
        correctAnswer = '';
        options = [];
      });
      return;
    }

    setState(() {
      final randomIndex = Random().nextInt(items.length);
      final question = items[randomIndex];

      currentItem = question['word'] ?? '';
      correctAnswer = question['meaning'] ?? '';

      items.removeAt(randomIndex);

      askedCount++;

      List<String> wrongAnswers = widget.dataList.values
          .map((e) => e['Anlam'] ?? '')
          .where((m) => m.isNotEmpty && m != correctAnswer)
          .toList();

      wrongAnswers.shuffle();

      if (wrongAnswers.length < 3) {
        options = [correctAnswer, 'Yanlış 1', 'Yanlış 2', 'Yanlış 3'];
      } else {
        options = [correctAnswer, ...wrongAnswers.take(3)];
      }

      options.shuffle();

      isAnswered = false;
      isCorrect = false;
      message = '';
    });
  }

  void _checkAnswer(String answer) {
    setState(() {
      isAnswered = true;

      if (answer == correctAnswer) {
        isCorrect = true;
        correctCount++;
        message = 'Doğru ✔️';
      } else {
        isCorrect = false;
        wrongCount++;
        message = 'Yanlış ❌\nDoğru cevap:\n$correctAnswer';
      }
    });
  }

  void _nextQuestion() {
    _loadQuestion();
  }

  Future<void> _resetQuiz() async {
    setState(() {
      askedCount = 0;
      correctCount = 0;
      wrongCount = 0;

      items = widget.dataList.entries.map((entry) {
        return {
          'word': entry.key,
          'meaning': entry.value['Anlam'] ?? '',
        };
      }).toList();

      items.shuffle();
    });

    _loadQuestion();
  }

  double get _successPercent {
    final total = correctCount + wrongCount;
    if (total == 0) return 0;
    return (correctCount / total) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = items.isEmpty && currentItem == '';

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.toggleTheme(!widget.isDarkTheme),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetQuiz,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// 🧮 CANLI SAYAÇ GÖRÜNÜMÜ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _counterCard('Doğru', correctCount, Colors.green),
                    _counterCard('Yanlış', wrongCount, Colors.red),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  'Başarı Oranı: %${_successPercent.toStringAsFixed(1)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                if (!isFinished)
                  Text(
                    currentItem,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 20),

                if (!isFinished) ...options.map(_buildOptionButton),

                const SizedBox(height: 20),

                if (isAnswered && !isFinished) _buildNextButton(),

                /// 🎉 TEST BİTTİ SONUÇ EKRANI
                if (isFinished) _buildResultScreen(),

                const SizedBox(height: 20),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 küçük istatistik kartı
  Widget _counterCard(String title, int value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 16, color: color, fontWeight: FontWeight.bold)),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎯 sonuç ekranı
  Widget _buildResultScreen() {
    return Column(
      children: [
        const Text(
          'Test Tamamlandı 🎉',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Doğru: $correctCount'),
        Text('Yanlış: $wrongCount'),
        Text('Başarı: %${_successPercent.toStringAsFixed(1)}'),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: _resetQuiz,
          child: const Text('Baştan Başla'),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isAnswered ? null : () => _checkAnswer(option),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            backgroundColor: isAnswered
                ? (option == correctAnswer
                    ? Colors.green
                    : (isCorrect ? null : Colors.red))
                : null,
          ),
          child: Text(
            option,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _nextQuestion,
      child: const Text('Sonraki Soru'),
    );
  }
}
