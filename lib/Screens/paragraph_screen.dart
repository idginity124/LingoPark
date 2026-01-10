import 'package:flutter/material.dart';
import '../Models/paragraph_data.dart';
import '../Models/paragraph_dictionary.dart';
import '../Utilities/sound_manager.dart';

class ParagraphListScreen extends StatelessWidget {
  final Map<String, Map<String, String>> wordList;

  const ParagraphListScreen({super.key, required this.wordList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Okuma Parçaları")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: storyList.length,
        itemBuilder: (context, index) {
          final story = storyList[index];

          Color levelColor;
          switch (story.level) {
            case "A1":
              levelColor = Colors.green;
              break;
            case "A2":
              levelColor = Colors.teal;
              break;
            case "B1":
              levelColor = Colors.blue;
              break;
            case "B2":
              levelColor = Colors.orange;
              break;
            case "C1":
              levelColor = Colors.red;
              break;
            default:
              levelColor = Colors.grey;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: Theme.of(context).cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: levelColor,
                child: Text(
                  story.level,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                story.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "${story.content.substring(0, 50)}...",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadingScreen(
                      story: story,
                      wordList: wordList,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ReadingScreen extends StatefulWidget {
  final Paragraph story;
  final Map<String, Map<String, String>> wordList;

  const ReadingScreen({
    super.key,
    required this.story,
    required this.wordList,
  });

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  bool _isTranslationVisible = false;

  /// ⭐ Yeni eklenen vurgu değişkeni
  String? _highlightedWord;

  String _cleanWord(String word) {
    return word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
  }

  String? _findKeyInDictionary(
      String searchWord, Map<String, dynamic> dictionary) {
    if (dictionary.containsKey(searchWord)) return searchWord;

    if (searchWord.isNotEmpty) {
      String capitalized =
          searchWord[0].toUpperCase() + searchWord.substring(1);
      if (dictionary.containsKey(capitalized)) return capitalized;
    }

    for (var key in dictionary.keys) {
      if (key.toLowerCase() == searchWord) return key;
    }
    return null;
  }

  String? _findMeaningSmartly(String word, Map<String, dynamic> dictionary,
      {bool isComplexMap = false}) {
    String? foundKey = _findKeyInDictionary(word, dictionary);
    if (foundKey != null) {
      return isComplexMap
          ? dictionary[foundKey]['Anlam']
          : dictionary[foundKey];
    }

    List<String> variations = [];
    if (word.endsWith('s')) variations.add(word.substring(0, word.length - 1));
    if (word.endsWith('es')) variations.add(word.substring(0, word.length - 2));
    if (word.endsWith('ed')) variations.add(word.substring(0, word.length - 2));
    if (word.endsWith('d')) variations.add(word.substring(0, word.length - 1));
    if (word.endsWith('ing'))
      variations.add(word.substring(0, word.length - 3));
    if (word.endsWith('ies'))
      variations.add(word.substring(0, word.length - 3) + 'y');

    for (String root in variations) {
      String? rootKey = _findKeyInDictionary(root, dictionary);
      if (rootKey != null) {
        return isComplexMap
            ? dictionary[rootKey]['Anlam']
            : dictionary[rootKey];
      }
    }

    return null;
  }

  void _showWordMeaning(BuildContext context, String rawWord) {
    final cleanWord = _cleanWord(rawWord);

    /// ⭐ tıklanan kelimeyi sarı yap
    setState(() {
      _highlightedWord = cleanWord;
    });

    /// ⏳ 1.2sn sonra otomatik sil
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _highlightedWord = null;
        });
      }
    });

    String meaning = "Anlam bulunamadı";
    bool found = false;
    String source = "";

    if (widget.story.specificMeanings != null) {
      String? result =
          _findMeaningSmartly(cleanWord, widget.story.specificMeanings!);
      if (result != null) {
        meaning = result;
        found = true;
        source = "(Bağlama Özel)";
      }
    }

    if (!found) {
      String? result = _findMeaningSmartly(cleanWord, paragraphDictionary);
      if (result != null) {
        meaning = result;
        found = true;
      }
    }

    if (!found) {
      String? result =
          _findMeaningSmartly(cleanWord, widget.wordList, isComplexMap: true);
      if (result != null) {
        meaning = result;
        found = true;
      }
    }

    SoundManager.playClickHaptic();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cleanWord.toUpperCase(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                meaning,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              if (found && source.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    source,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.story.content.split(' ');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isTranslationVisible = !_isTranslationVisible;
              });
              SoundManager.playClickHaptic();
            },
            icon: Icon(
              _isTranslationVisible ? Icons.visibility_off : Icons.translate,
              color: Colors.white,
            ),
            label: Text(
              _isTranslationVisible ? "Gizle" : "Türkçe",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.story.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Seviye: ${widget.story.level}",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// ⭐⭐ VURGULU METİN ⭐⭐
              Wrap(
                spacing: 4,
                runSpacing: 6,
                children: words.map((word) {
                  final clean = _cleanWord(word);
                  final highlighted = _highlightedWord == clean;

                  return GestureDetector(
                    onTap: () => _showWordMeaning(context, word),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 2),
                      decoration: BoxDecoration(
                        color: highlighted
                            ? Colors.yellow.shade300
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontSize: 19,
                          height: 1.6,
                          fontWeight:
                              highlighted ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              if (_isTranslationVisible)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.translate, size: 20, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            "TÜRKÇE ÇEVİRİSİ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.orange),
                      const SizedBox(height: 5),
                      Text(
                        widget.story.translation,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
