import 'dart:math'; // Random için gerekli
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:confetti/confetti.dart';
import '../Services/user_profile_service.dart';
import '../Utilities/sound_manager.dart';
import '../Services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  // Eski parametreleri uyumluluk için tutuyoruz
  final Function toggleTheme;
  final bool isDarkTheme;
  final String difficulty;
  final Map<String, Map<String, String>> wordList;

  const QuizScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkTheme,
    required this.difficulty,
    required this.wordList,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Temel Değişkenler
  List<String> words = [];
  String currentWord = '';
  String currentMeaning = '';
  int currentIndex = 0;

  // Yeni Sistem Değişkenleri (Harf Kutucukları)
  List<String> scrambledLetters = []; // Karışık harf havuzu
  List<String?> userAnswerSlots = []; // Kullanıcının doldurduğu kutular
  List<bool> isLetterUsed = []; // Hangi harf butonu kullanıldı?

  // Durum Yönetimi
  String message = '';
  bool isCorrect = false;
  bool isAnswered = false; // Cevap kontrol edildi mi?
  bool wrongRecordedForThisWord = false;

  // Favori ve Efektler
  bool isFavorite = false;
  late ConfettiController _confettiController;
  final FlutterTts flutterTts = FlutterTts();

  // 🔥 EĞLENCE LİSTESİ (Öğretmen Şakaları)
  final List<String> teacherJokes = [
    "Klavye ile imtihanın zorlu geçiyor... ⌨️",
    "O harfin orada ne işi var? 🤔",
    "Sözlük karıştırmak yok! 📚",
    "Biraz daha dikkatli baksak? 👀",
    "Bu kelimeyi geçen hafta işlemiştik... şaka şaka. 😂",
    "Pes etme, ama biraz zorluyor galiba? 💪",
    "Harflerle aran iyi değil bugün. 🔤",
    "Attın ama tutmadı... 🎲",
    "Birdahakine tutturucan inanıyorum! 🐦"
  ];

  // Renkler
  final Color primaryColor = Colors.tealAccent;
  final Color cardColor = const Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _initTts();

    // Kelimeleri karıştır ve ilk soruyu hazırla
    words = widget.wordList.keys.toList()..shuffle();
    if (words.isNotEmpty) {
      _loadQuestion();
    }
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  // --- SORU YÜKLEME ---
  void _loadQuestion() {
    setState(() {
      currentWord = words[currentIndex];
      // Anlam verisini al
      currentMeaning =
          widget.wordList[currentWord]?['Anlam'] ?? "Anlam Bulunamadı";

      isCorrect = false;
      isAnswered = false;
      wrongRecordedForThisWord = false;
      message = '';

      // Favori kontrolü
      _checkIfFavorite();

      // --- YENİ SİSTEM: Harfleri Hazırla ---
      // 1. Cevap uzunluğu kadar boş slot aç
      userAnswerSlots = List.filled(currentWord.length, null);

      // 2. Harfleri parçala ve karıştır
      scrambledLetters = currentWord.split('')..shuffle();

      // 3. Kullanılan harfleri takip etmek için liste (hepsi false başlar)
      isLetterUsed = List.filled(scrambledLetters.length, false);
    });
  }

  // --- HARF SEÇME MANTIĞI ---
  void _onLetterTap(int index, String letter) {
    if (isAnswered) return; // Cevap verildiyse işlem yapma

    SoundManager.playClickHaptic(); // Titreşim

    setState(() {
      // 1. İlk boş slotu bul
      int emptyIndex = userAnswerSlots.indexOf(null);

      if (emptyIndex != -1) {
        // Boş yere harfi koy
        userAnswerSlots[emptyIndex] = letter;
        // Havuzdaki harfi 'kullanıldı' olarak işaretle (Görünmez yap)
        isLetterUsed[index] = true;

        // EĞER SON SLOT DA DOLDUYSA OTOMATİK KONTROL ET
        if (!userAnswerSlots.contains(null)) {
          _checkFullWord();
        }
      }
    });
  }

  // --- HARFİ GERİ ALMA ---
  void _onSlotTap(int index) {
    if (isAnswered || userAnswerSlots[index] == null) return;

    SoundManager.playClickHaptic();

    setState(() {
      String charToRemove = userAnswerSlots[index]!;

      // Slotu boşalt
      userAnswerSlots[index] = null;

      // Havuzda bu harfe ait olan ve 'kullanıldı' (true) olan İLK harfi bul ve geri aç (false yap)
      for (int i = 0; i < scrambledLetters.length; i++) {
        if (scrambledLetters[i] == charToRemove && isLetterUsed[i] == true) {
          isLetterUsed[i] = false;
          break; // Sadece bir tanesini geri aç
        }
      }

      // Mesajı temizle (kullanıcı düzeltmeye çalışıyor)
      message = "";
    });
  }

  // --- CEVAP KONTROLÜ (Otomatik Çağrılır) ---
  // --- CEVAP KONTROLÜ (Otomatik Çağrılır) ---
  Future<void> _checkFullWord() async {
    String userGuess = userAnswerSlots.join('');

    if (userGuess.toLowerCase() == currentWord.toLowerCase()) {
      // --- DOĞRU ---
      setState(() {
        isAnswered = true;
        isCorrect = true;
        message = "👏 Harika! Doğru Cevap (+15 XP)";
      });

      // ✅ Progress kaydı (DOĞRU)
      await ProgressService.recordAnswer(
        wordKey: currentWord,
        correct: true,
      );

      SoundManager.playCorrectSound();
      SoundManager.playSuccessHaptic();
      _confettiController.play();
      _speakWord();

      UserProfileService.addXp(15);
      UserProfileService.checkStreak();
    } else {
      // --- YANLIŞ ---
      SoundManager.playErrorHaptic();
      SoundManager.playWrongSound();

      // ✅ Progress kaydı (YANLIŞ) - sadece 1 kez
      if (!wrongRecordedForThisWord) {
        wrongRecordedForThisWord = true;
        await ProgressService.recordAnswer(
          wordKey: currentWord,
          correct: false,
        );
      }

      final random = Random();
      String joke = teacherJokes[random.nextInt(teacherJokes.length)];

      setState(() {
        message = "Yanlış! $joke";
      });
    }
  }

  void _nextQuestion() {
    SoundManager.playClickSound();
    setState(() {
      if (currentIndex < words.length - 1) {
        currentIndex++;
        _loadQuestion();
      } else {
        // Oyun Bitti
        _showFinishDialog();
      }
    });
  }

  void _speakWord() async {
    await flutterTts.speak(currentWord);
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        title:
            const Text("Tebrikler! 🎉", style: TextStyle(color: Colors.white)),
        content: const Text("Tüm kelimeleri tamamladın.",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Dialog kapa
              Navigator.of(ctx).pop(); // Menüye dön
            },
            child: Text("Menüye Dön", style: TextStyle(color: primaryColor)),
          )
        ],
      ),
    );
  }

  // --- FAVORİ İŞLEMLERİ ---
  Future<void> _checkIfFavorite() async {
    List<String> favs = await UserProfileService.getFavorites();
    setState(() {
      isFavorite = favs.contains(currentWord);
    });
  }

  Future<void> _toggleFavorite() async {
    await UserProfileService.toggleFavorite(currentWord);
    _checkIfFavorite();
    SoundManager.playClickHaptic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Koyu arka plan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Kelime Avı (${currentIndex + 1}/${words.length})"),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: _speakWord,
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // --- ÜST KISIM: SORU KARTI ---
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bu Kelimenin İngilizcesi Ne?",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 15),
                      Text(
                        currentMeaning, // Türkçe Anlam
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // GERİ BİLDİRİM MESAJI
                      if (message.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: isCorrect
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: isCorrect
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),

              // --- ORTA KISIM: CEVAP SLOTLARI ---
              Expanded(
                flex: 1,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(userAnswerSlots.length, (index) {
                      String? char = userAnswerSlots[index];

                      // Slot rengi durumu
                      Color borderColor = primaryColor;
                      if (char != null) {
                        // Eğer cevap doluysa ve yanlışsa kırmızı
                        if (!userAnswerSlots.contains(null) && !isCorrect) {
                          borderColor = Colors.red;
                        } else if (isCorrect) {
                          borderColor = Colors.green;
                        }
                      }

                      return GestureDetector(
                        onTap: () => _onSlotTap(index),
                        child: Container(
                          width: 45,
                          height: 50,
                          decoration: BoxDecoration(
                            color: char != null
                                ? Colors.white.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border(
                                bottom:
                                    BorderSide(color: borderColor, width: 3)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            char ?? "",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // --- ALT KISIM: HARF HAVUZU ---
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Harf Butonları
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.center,
                        children:
                            List.generate(scrambledLetters.length, (index) {
                          // Eğer harf kullanıldıysa görünmez bir yer tutucu (SizedBox) koy
                          if (isLetterUsed[index]) {
                            return const SizedBox(width: 50, height: 50);
                          }

                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _onLetterTap(index, scrambledLetters[index]),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.teal.shade800,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 5,
                              ),
                              child: Text(
                                scrambledLetters[index],
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }),
                      ),

                      const Spacer(),

                      // Geç / Sonraki Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAnswered
                                ? Colors.white
                                : Colors.grey.shade800,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(
                            isAnswered ? "SONRAKİ KELİME 👉" : "Pas Geç",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Konfeti Efekti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange
              ],
            ),
          ),
        ],
      ),
    );
  }
}
