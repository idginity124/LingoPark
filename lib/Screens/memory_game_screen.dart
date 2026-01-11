import 'dart:async';
import 'package:flutter/material.dart';
import '../Services/user_profile_service.dart';
import '../Utilities/sound_manager.dart';
import 'package:confetti/confetti.dart';

class MemoryGameScreen extends StatefulWidget {
  final Map<String, Map<String, String>> wordList;

  const MemoryGameScreen({super.key, required this.wordList});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _CardItem {
  final String id;
  final String text;
  final String pairId;

  bool isFlipped;
  bool isMatched;

  _CardItem({
    required this.id,
    required this.text,
    required this.pairId,
  })  : isFlipped = false,
        isMatched = false;
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<_CardItem> cards = [];
  List<_CardItem> selectedCards = [];
  bool isProcessing = false;

  int score = 0;
  int moves = 0;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _setupGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  /// 🔥 OYUNU KUR
  void _setupGame() {
    List<String> keys = widget.wordList.keys.toList();

    // en az 6 kelime yoksa → mevcut ile oyna
    keys.shuffle();
    List<String> gameWords =
        keys.length >= 6 ? keys.take(6).toList() : keys.toList();

    List<_CardItem> tempCards = [];

    for (var word in gameWords) {
      final meaning = widget.wordList[word]?['Anlam'] ?? '';

      // boş anlamları ekleme – UI kırılmaz
      if (meaning.trim().isEmpty) continue;

      tempCards.add(_CardItem(id: "${word}_en", text: word, pairId: word));
      tempCards.add(_CardItem(id: "${word}_tr", text: meaning, pairId: word));
    }

    tempCards.shuffle();

    setState(() {
      cards = tempCards;
      selectedCards.clear();
      score = 0;
      moves = 0;
      isProcessing = false;
    });
  }

  /// 🟢 KARTA TIKLANDI
  void _onCardTap(int index) {
    if (isProcessing) return;

    final card = cards[index];

    if (card.isMatched || card.isFlipped) return;

    setState(() {
      card.isFlipped = true;
      selectedCards.add(card);
      SoundManager.playClickHaptic();
    });

    if (selectedCards.length == 2) {
      isProcessing = true;
      moves++;
      _checkForMatch();
    }
  }

  /// 🎯 EŞLEŞME DENETİMİ
  Future<void> _checkForMatch() async {
    final card1 = selectedCards[0];
    final card2 = selectedCards[1];

    if (card1.pairId == card2.pairId) {
      // eşleşti
      SoundManager.playSuccessHaptic();
      SoundManager.playCorrectSound();

      setState(() {
        card1.isMatched = true;
        card2.isMatched = true;
        score += 20;
      });

      UserProfileService.addXp(20);

      selectedCards.clear();
      isProcessing = false;

      // 🎉 oyun bitti mi?
      if (cards.every((c) => c.isMatched)) {
        _confettiController.play();
        await Future.delayed(const Duration(milliseconds: 400));
        _showWinDialog();
      }
    } else {
      // eşleşmedi
      SoundManager.playErrorHaptic();

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() {
        card1.isFlipped = false;
        card2.isFlipped = false;
      });

      selectedCards.clear();
      isProcessing = false;
    }
  }

  /// 🏆 KAZANMA PENCERESİ
  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Center(
          child: Text(
            "TEBRİKLER! 🎉",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Tüm kartları $moves hamlede eşleştirdin!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "+$score XP Kazandın",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ÇIKIŞ"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _setupGame();
            },
            child: const Text("TEKRAR OYNA"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Hafıza Oyunu"),
            actions: [
              IconButton(
                onPressed: _setupGame,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Hamle: $moves",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "XP: $score",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (_, index) => _buildCard(index),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// 🎉 confetti üstte çalışsın
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.05,
          numberOfParticles: 25,
        ),
      ],
    );
  }

  /// 🧩 TEK KART
  Widget _buildCard(int index) {
    final card = cards[index];
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched ? cardColor : primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                card.isMatched ? Colors.green : primaryColor.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    card.text,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: card.isMatched
                          ? Colors.green
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                )
              : Icon(
                  Icons.help_outline,
                  size: 40,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
        ),
      ),
    );
  }
}
