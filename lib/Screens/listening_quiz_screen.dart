import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

import '../Services/progress_service.dart';
import '../Services/user_profile_service.dart';
import '../Utilities/sound_manager.dart';

class ListeningQuizScreen extends StatefulWidget {
  final Map<String, Map<String, String>> wordList;

  const ListeningQuizScreen({super.key, required this.wordList});

  @override
  State<ListeningQuizScreen> createState() => _ListeningQuizScreenState();
}

class _ListeningQuizScreenState extends State<ListeningQuizScreen> {
  late final FlutterTts flutterTts;
  final AudioPlayer audioPlayer = AudioPlayer();

  // Oyun
  List<String> words = [];
  String currentWord = '';
  String correctAnswer = '';
  List<String> options = [];

  // Durum
  bool isAnswered = false;
  bool isCorrect = false;
  bool isLoadingSound = false;
  bool wrongRecordedForThisWord = false;
  String feedbackMessage = '';
  String? selectedOption;

  // Ses kaynağı
  String? currentOnlineAudioUrl;
  final Map<String, String> _audioCache = {};

  late final ConfettiController _confettiController;

  // ✅ stream dinleme
  StreamSubscription<PlayerState>? _playerStateSub;
  PlayerState _playerState = PlayerState.stopped;

  // ✅ takılma önlemek için: aynı anda 2 play çalışmasın
  int _audioRequestId = 0;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    words = widget.wordList.keys.toList()..shuffle();

    _initTts();

    // ✅ audioplayers state dinle (playerStateStream değil, bu var)
    _playerStateSub = audioPlayer.onPlayerStateChanged.listen((s) {
      _playerState = s;
    });

    Future.delayed(const Duration(milliseconds: 300), _loadQuestion);
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-GB");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);

    try {
      await flutterTts.awaitSpeakCompletion(true);
    } catch (_) {}
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    try {
      flutterTts.stop();
    } catch (_) {}
    audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // --- SES ---
  Future<void> _playWordAudio({bool slow = false}) async {
    if (currentWord.isEmpty) return;

    final int reqId = ++_audioRequestId;

    // Çakışma olmasın
    try {
      await audioPlayer.stop();
    } catch (_) {}
    try {
      await flutterTts.stop();
    } catch (_) {}

    if (mounted) setState(() => isLoadingSound = true);

    final double playbackRate = slow ? 0.5 : 1.0;

    try {
      // ✅ Cache kontrol
      final cached = _audioCache[currentWord];
      if (cached != null && cached.isNotEmpty) {
        currentOnlineAudioUrl = cached;
      }

      // URL varsa direkt dene
      if (currentOnlineAudioUrl != null && currentOnlineAudioUrl!.isNotEmpty) {
        final ok = await _playUrlWithFallback(
          reqId: reqId,
          url: currentOnlineAudioUrl!,
          playbackRate: playbackRate,
          slow: slow,
        );
        if (!ok) await _speakWithTTS(slow);
        return;
      }

      // Online audio bul (timeout)
      final uri = Uri.parse(
          'https://api.dictionaryapi.dev/api/v2/entries/en/$currentWord');

      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        if (decoded is List) {
          String foundUrl = "";

          for (final entry in decoded) {
            if (entry is! Map) continue;

            final phonetics = entry['phonetics'];
            if (phonetics is! List) continue;

            for (final p in phonetics) {
              if (p is! Map) continue;

              final audioStr = (p['audio'] ?? '').toString().trim();
              if (audioStr.isEmpty) continue;

              // UK önceliği
              if (audioStr.contains("uk")) {
                foundUrl = audioStr;
                break;
              }

              if (foundUrl.isEmpty) foundUrl = audioStr;
            }

            if (foundUrl.contains("uk")) break;
          }

          if (foundUrl.isNotEmpty) {
            currentOnlineAudioUrl = foundUrl;
            _audioCache[currentWord] = foundUrl;
          }
        }
      }

      // Çal veya TTS
      if (currentOnlineAudioUrl != null && currentOnlineAudioUrl!.isNotEmpty) {
        final ok = await _playUrlWithFallback(
          reqId: reqId,
          url: currentOnlineAudioUrl!,
          playbackRate: playbackRate,
          slow: slow,
        );
        if (!ok) await _speakWithTTS(slow);
      } else {
        await _speakWithTTS(slow);
      }
    } catch (e) {
      debugPrint("Ses hatası: $e");
      await _speakWithTTS(slow);
    } finally {
      if (!mounted) return;
      if (reqId == _audioRequestId) {
        setState(() => isLoadingSound = false);
      }
    }
  }

  /// ✅ URL oynat, 2sn içinde gerçekten playing olmazsa false
  Future<bool> _playUrlWithFallback({
    required int reqId,
    required String url,
    required double playbackRate,
    required bool slow,
  }) async {
    try {
      await audioPlayer.setPlaybackRate(playbackRate);

      // play çağrısı takılmasın
      await audioPlayer
          .play(UrlSource(url))
          .timeout(const Duration(seconds: 2));

      // 2sn bekle: hala playing değilse "takıldı" say
      await Future.delayed(const Duration(milliseconds: 800));

      if (reqId != _audioRequestId) return false; // başka istek geldi

      if (_playerState != PlayerState.playing) {
        try {
          await audioPlayer.stop();
        } catch (_) {}
        return false;
      }

      return true;
    } catch (_) {
      try {
        await audioPlayer.stop();
      } catch (_) {}
      return false;
    }
  }

  Future<void> _speakWithTTS(bool slow) async {
    try {
      await flutterTts.setSpeechRate(slow ? 0.3 : 0.5);
      await flutterTts.speak(currentWord);
    } catch (e) {
      debugPrint("TTS hatası: $e");
    }
  }

  // --- SORU YÜKLE ---
  void _loadQuestion() {
    if (!mounted) return;

    wrongRecordedForThisWord = false;

    if (words.isEmpty) {
      setState(() {
        currentWord = '';
        options = [];
        feedbackMessage = "🎉 Tüm kelimeleri bitirdin!";
        isAnswered = true;
        isCorrect = true;
        selectedOption = null;
      });
      return;
    }

    final randomIndex = Random().nextInt(words.length);
    currentWord = words.removeAt(randomIndex);

    correctAnswer = widget.wordList[currentWord]?['Anlam'] ?? '';

    final wrongMeanings = widget.wordList.values
        .map((e) => e['Anlam'] ?? '')
        .where((e) => e.isNotEmpty && e != correctAnswer)
        .toList()
      ..shuffle();

    final wrongCount = min(3, wrongMeanings.length);

    options = [
      ...wrongMeanings.take(wrongCount),
      correctAnswer,
    ]..shuffle();

    currentOnlineAudioUrl = null;

    setState(() {
      isAnswered = false;
      isCorrect = false;
      selectedOption = null;
      feedbackMessage = '';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _playWordAudio(slow: false);
    });
  }

  // --- CEVAP ---
  Future<void> _checkAnswer(String option) async {
    if (isAnswered) return;

    SoundManager.playClickHaptic();

    setState(() {
      isAnswered = true;
      selectedOption = option;
    });

    final bool correct = option == correctAnswer;

    if (correct) {
      setState(() {
        isCorrect = true;
        feedbackMessage = "Doğru! 🎉\nKelime: $currentWord";
      });

      await ProgressService.recordAnswer(wordKey: currentWord, correct: true);

      _confettiController.play();
      UserProfileService.addXp(15);
      SoundManager.playSuccessHaptic();
      SoundManager.playCorrectSound();

      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _loadQuestion();
      });
    } else {
      setState(() {
        isCorrect = false;
        feedbackMessage =
            "Yanlış!\nDoğrusu: $correctAnswer\nKelime: $currentWord";
      });

      if (!wrongRecordedForThisWord) {
        wrongRecordedForThisWord = true;
        await ProgressService.recordAnswer(
            wordKey: currentWord, correct: false);
      }

      SoundManager.playErrorHaptic();
      SoundManager.playWrongSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color cardColor = Theme.of(context).cardColor;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Dinle ve Bul 🎧")),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (words.isEmpty && currentWord.isEmpty) ...[
                  const Text(
                    "🎉 Oyun Bitti",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text("Tüm kelimeleri çözdün 👏"),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: isLoadingSound
                            ? null
                            : () => _playWordAudio(slow: false),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryColor, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: isLoadingSound
                              ? const Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: CircularProgressIndicator(),
                                )
                              : Icon(
                                  Icons.volume_up_rounded,
                                  size: 70,
                                  color: primaryColor,
                                ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isLoadingSound
                              ? null
                              : () {
                                  SoundManager.playClickHaptic();
                                  _playWordAudio(slow: true);
                                },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ],
                            ),
                            child: const Icon(
                              Icons.speed,
                              size: 30,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Büyük: Normal | Küçük: Yavaş (0.5x)",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 40),
                  ...options.map((option) {
                    Color? btnColor;

                    if (isAnswered) {
                      if (option == correctAnswer) {
                        btnColor = Colors.green;
                      } else if (option == selectedOption) {
                        btnColor = Colors.red;
                      }
                    }

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      height: 55,
                      child: ElevatedButton(
                        onPressed:
                            isAnswered ? null : () => _checkAnswer(option),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor ?? cardColor,
                          foregroundColor: btnColor != null
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                            Text(option, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  if (isAnswered && !isCorrect)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Text(
                            feedbackMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _loadQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: const Text(
                              "SONRAKİ SORU 👉",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
        ),
      ],
    );
  }
}
