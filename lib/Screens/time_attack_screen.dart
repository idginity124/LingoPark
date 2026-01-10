import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../Services/user_profile_service.dart';
import '../Utilities/sound_manager.dart';

class TimeAttackScreen extends StatefulWidget {
  final Map<String, Map<String, String>> wordList;

  const TimeAttackScreen({super.key, required this.wordList});

  @override
  _TimeAttackScreenState createState() => _TimeAttackScreenState();
}

class _TimeAttackScreenState extends State<TimeAttackScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<String> words = [];
  String currentWord = '';
  String correctAnswer = '';
  List<String> options = [];

  String? lastWord;

  Timer? _timer;
  int _remainingTime = 60;
  int _totalMaxTime = 60;

  int _score = 0;
  int bestScore = 0;

  int correctCount = 0;
  int wrongCount = 0;

  String? selectedAnswer;
  bool showResult = false;

  late AnimationController _animController;

  int wrongStreak = 0;

  final List<String> panicMessages = [
    "Kaplumbağa deden daha hızlıydı! 🐢",
    "Süre bitiyor, panik yapabilirsin! 😱",
    "Atma Ziyaaa! 🎲",
    "Bugün formunda değilsin sanki? 📉",
    "Hızlan biraz, akşam oldu! 🌙",
    "Salladın ama tutmadı... ❌",
    "Heyecan yapma elim ayağım titredi! 🥶",
    "Gitti güzelim puanlar... 💸",
    "Google'a bakmak yok! 👁️",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBindingObserver;
    WidgetsBinding.instance.addObserver(this);

    words = widget.wordList.keys.toList();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _startGame();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  double get successRate => (correctCount + wrongCount) == 0
      ? 0
      : (correctCount / (correctCount + wrongCount)) * 100;

  void _startGame() {
    _score = 0;
    _remainingTime = 60;
    correctCount = 0;
    wrongCount = 0;
    wrongStreak = 0;
    selectedAnswer = null;
    showResult = false;

    words.shuffle(Random());

    _loadQuestion();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);

        if (_remainingTime == 10) {
          _showSnack("SON 10 SANİYE! KOŞ! 🏃‍♂️", Colors.red);
        }
      } else {
        _gameOver();
      }
    });
  }

  void _loadQuestion() {
    if (words.isEmpty) return;

    String newWord;

    do {
      newWord = words[Random().nextInt(words.length)];
    } while (newWord == lastWord);

    lastWord = newWord;
    currentWord = newWord;

    correctAnswer = widget.wordList[currentWord]?['Anlam'] ?? '';

    List<String> wrongMeanings = widget.wordList.values
        .map((e) => e['Anlam'] ?? '')
        .where((e) => e.isNotEmpty && e != correctAnswer)
        .toList();

    wrongMeanings.shuffle();

    options = wrongMeanings.take(3).toList();
    options.add(correctAnswer);

    options = options.toSet().toList();
    options.shuffle();

    selectedAnswer = null;
    showResult = false;
  }

  void _checkAnswer(String selected) {
    if (showResult) return;

    selectedAnswer = selected;
    bool isCorrect = selected == correctAnswer;

    setState(() {
      showResult = true;

      if (isCorrect) {
        correctCount++;
        _score += 10;
        _remainingTime = (_remainingTime + 3).clamp(0, _totalMaxTime);

        wrongStreak = 0;
        SoundManager.playSuccessHaptic();
        SoundManager.playCorrectSound();
      } else {
        wrongCount++;
        _remainingTime = (_remainingTime - 5).clamp(0, 999);

        wrongStreak++;
        SoundManager.playErrorHaptic();
        SoundManager.playWrongSound();

        if (wrongStreak % 2 == 0) {
          final msg = panicMessages[Random().nextInt(panicMessages.length)];
          _showSnack(msg, Colors.orangeAccent);
        } else {
          _showSnack("-5 Saniye! ⚠️", Colors.red);
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (_remainingTime > 0) {
        setState(() {
          showResult = false;
          _loadQuestion();
        });
      } else {
        _gameOver();
      }
    });
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: color,
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 180,
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  void _gameOver() {
    _timer?.cancel();

    if (_score > bestScore) {
      bestScore = _score;
    }

    UserProfileService.addXp(_score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("SÜRE BİTTİ! ⏰", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Skor: $_score"),
            Text("En yüksek skor: $bestScore"),
            Text("✔ Doğru: $correctCount"),
            Text("❌ Yanlış: $wrongCount"),
            Text("🎯 Başarı: ${successRate.toStringAsFixed(1)}%"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("ÇIKIŞ"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text("TEKRAR OYNA"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Skor: $_score"),
                  Text("Doğru: $correctCount  Yanlış: $wrongCount"),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _timer?.cancel();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              Text("Başarı: ${successRate.toStringAsFixed(1)}%"),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: (_remainingTime / _totalMaxTime).clamp(0, 1),
                      strokeWidth: 8,
                      color: _remainingTime > 20 ? primaryColor : Colors.red,
                    ),
                  ),
                  Text("$_remainingTime", style: const TextStyle(fontSize: 36)),
                ],
              ),
              const Spacer(),
              Text(
                currentWord,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ...options.map((o) {
                Color? bg;

                if (showResult) {
                  if (o == correctAnswer)
                    bg = Colors.green;
                  else if (o == selectedAnswer) bg = Colors.red;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: (_remainingTime == 0 || showResult)
                        ? null
                        : () => _checkAnswer(o),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bg,
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: Text(o, textAlign: TextAlign.center),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
