import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../Services/user_profile_service.dart';
import '../Utilities/sound_manager.dart';

class MultipleChoiceQuizScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkTheme;
  final String difficulty;
  final Map<String, Map<String, String>> wordList;

  // Bu test "Hata Kutusu" testi mi?
  final bool isMistakeMode;

  const MultipleChoiceQuizScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkTheme,
    required this.difficulty,
    required this.wordList,
    this.isMistakeMode = false,
  });

  @override
  _MultipleChoiceQuizScreenState createState() =>
      _MultipleChoiceQuizScreenState();
}

class _MultipleChoiceQuizScreenState extends State<MultipleChoiceQuizScreen> {
  // Değişkenler
  List<String> words = [];
  String currentWord = '';
  String correctAnswer = '';
  List<String> options = [];
  int currentIndex = 0;

  // Durum Kontrolü
  bool isAnswered = false;
  bool isCorrect = false;
  String feedbackMessage = '';
  String? selectedOption;
  bool isLoading = true;
  bool isTestFinished = false;

  // 🔥 YENİ: Eğlence Değişkenleri
  int consecutiveWrongCount = 0; // Üst üste yanlış sayacı
  final List<String> sarcasticMessages = [
    "Bugün gününde değilsin galiba? 😅",
    "Attın ama tutmadı... 🎯",
    "Bu gidişle sabaha kadar buradayız ☕",
    "Gözlüklerini taktın mı? 🤓",
    "Sallama yeteneğini biraz daha geliştirmen lazım 🎲",
    "Destek almalı mıyız? 🚑",
    "Telefonu ters tutuyor olabilir misin? 📱",
    "Pes etmek yok... ama biraz dinlensek mi? 🛌",
    "Google'a bakmak yok, görüyorum! 👁️",
    "Hocam naptın, elin mi kaydı? 🤷‍♂️",
  ];

  // Favori ve Efektler
  bool isFavorite = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    if (widget.isMistakeMode) {
      _startNewGame();
    } else {
      _checkForSavedGame();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkForSavedGame() async {
    final savedData = await UserProfileService.getQuizProgress();

    if (savedData != null && mounted) {
      _showResumeDialog(savedData);
    } else {
      _startNewGame();
    }
  }

  void _showResumeDialog(Map<String, dynamic> savedData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Devam Et?"),
        content: const Text(
            "Yarım bıraktığın bir test bulundu. Devam etmek ister misin?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              UserProfileService.clearQuizProgress();
              _startNewGame();
            },
            child: const Text("Hayır, Baştan Başla"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resumeGame(savedData);
            },
            child: const Text("Evet, Devam Et"),
          ),
        ],
      ),
    );
  }

  void _resumeGame(Map<String, dynamic> savedData) {
    setState(() {
      words = List<String>.from(savedData['words']);
      currentIndex = savedData['index'];

      if (words.isEmpty || currentIndex >= words.length) {
        _startNewGame();
        return;
      }

      isLoading = false;
      _loadQuestion();
      _checkFavoriteStatus();
    });
  }

  void _startNewGame() {
    setState(() {
      words = widget.wordList.keys.toList();
      words.shuffle(Random());
      currentIndex = 0;
      isLoading = false;
      isTestFinished = false;
      consecutiveWrongCount = 0; // Sayacı sıfırla
      _loadQuestion();

      if (!widget.isMistakeMode) {
        UserProfileService.saveQuizProgress(words, currentIndex);
      }
    });
  }

  void _loadQuestion() {
    if (words.isEmpty) return;

    currentWord = words[currentIndex];
    correctAnswer = widget.wordList[currentWord]?['Anlam'] ?? '';

    List<String> wrongMeanings = widget.wordList.values
        .map((e) => e['Anlam'] ?? '')
        .where((e) => e.isNotEmpty && e != correctAnswer)
        .toList();

    wrongMeanings.shuffle();

    options = wrongMeanings.take(3).toList();
    options.add(correctAnswer);
    options.shuffle();

    isAnswered = false;
    selectedOption = null;
    feedbackMessage = '';
  }

  // 🔥 YENİ: İronik Mesaj Gösterme Fonksiyonu
  void _showSarcasticFeedback() {
    final random = Random();
    final message = sarcasticMessages[random.nextInt(sarcasticMessages.length)];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.sentiment_dissatisfied, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
                child: Text(message,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: Colors.orangeAccent[700],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _checkAnswer(String option) {
    if (isAnswered) return;

    SoundManager.playClickHaptic();

    setState(() {
      isAnswered = true;
      selectedOption = option;

      if (option == correctAnswer) {
        // --- DOĞRU CEVAP ---
        isCorrect = true;
        feedbackMessage = "Doğru! 🎉 (+10 XP)";
        consecutiveWrongCount = 0; // 🔥 Doğru bilince seriyi sıfırla

        _confettiController.play();
        UserProfileService.addXp(10);
        SoundManager.playSuccessHaptic();
        SoundManager.playCorrectSound();

        if (widget.isMistakeMode) {
          UserProfileService.removeMistake(currentWord);
        }
      } else {
        // --- YANLIŞ CEVAP ---
        isCorrect = false;
        feedbackMessage = "Yanlış! Doğru cevap:\n$correctAnswer";
        consecutiveWrongCount++; // 🔥 Yanlış sayacını artır

        SoundManager.playErrorHaptic();
        SoundManager.playWrongSound();

        UserProfileService.addMistake(currentWord);

        if (widget.isMistakeMode) {
          words.add(currentWord);
          feedbackMessage += "\n(Tekrar sorulacak ↺)";
        }

        // 🔥 Her 3 yanlışta bir dalga geç
        if (consecutiveWrongCount % 3 == 0) {
          _showSarcasticFeedback();
        }
      }
    });
  }

  void _handleNextButton() {
    if (isTestFinished) {
      if (!widget.isMistakeMode) {
        UserProfileService.clearQuizProgress();
      }
      Navigator.pop(context);
      return;
    }

    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        _loadQuestion();
        _checkFavoriteStatus();
      });
      if (!widget.isMistakeMode) {
        UserProfileService.saveQuizProgress(words, currentIndex);
      }
    } else {
      setState(() {
        isTestFinished = true;
        feedbackMessage = "Tebrikler! Test Tamamlandı.";
        isAnswered = true;
        _confettiController.play();
      });
      if (!widget.isMistakeMode) {
        UserProfileService.clearQuizProgress();
      }
    }
  }

  void _checkFavoriteStatus() async {
    final favs = await UserProfileService.getFavorites();
    if (mounted) {
      setState(() {
        isFavorite = favs.contains(currentWord);
      });
    }
  }

  void _toggleFavorite() async {
    await UserProfileService.toggleFavorite(currentWord);
    List<String> updatedList = await UserProfileService.getFavorites();

    if (mounted) {
      setState(() {
        isFavorite = updatedList.contains(currentWord);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite
              ? 'Favorilere Eklendi ❤️'
              : 'Favorilerden Çıkarıldı 💔'),
          duration: const Duration(milliseconds: 800),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Yükleniyor...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.isMistakeMode
                ? 'Hata Telafisi (${currentIndex + 1}/${words.length})'
                : 'Test (${currentIndex + 1}/${words.length})'),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isTestFinished) ...[
                      // KELİME KARTI
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 5))
                            ]),
                        child: Text(
                          currentWord,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ŞIKLAR
                      ...options.map((option) {
                        Color? bgColor;
                        Color? textColor;

                        if (isAnswered) {
                          if (option == correctAnswer) {
                            bgColor = Colors.green;
                            textColor = Colors.white;
                          } else if (option == selectedOption && !isCorrect) {
                            bgColor = Colors.red;
                            textColor = Colors.white;
                          }
                        }

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              SoundManager.playClickHaptic();
                              _checkAnswer(option);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: bgColor,
                                foregroundColor: textColor,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ] else ...[
                      // TEST BİTİNCE
                      const Icon(Icons.check_circle_outline,
                          size: 100, color: Colors.green),
                      const SizedBox(height: 20),
                      const Text("Tebrikler!\nBu oturumu tamamladın.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],

                    const SizedBox(height: 20),

                    // SONUÇ / GEÇİŞ BUTONU
                    if (isAnswered || isTestFinished)
                      Column(
                        children: [
                          if (!isTestFinished)
                            Text(
                              feedbackMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect ? Colors.green : Colors.red),
                            ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handleNextButton,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: cardColor,
                                  foregroundColor: primaryColor,
                                  side: BorderSide(
                                      color: primaryColor, width: 2)),
                              child: Text(
                                isTestFinished
                                    ? "ÇIKIŞ YAP 🏁"
                                    : "Sonraki Soru 👉",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ],
        ),
      ],
    );
  }
}
