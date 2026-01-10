import 'package:flutter/material.dart';
import 'dart:async';

class WordListScreen extends StatefulWidget {
  final Map<String, Map<String, String>> wordList;
  final Map<String, Map<String, String>> idiomsList;
  final Map<String, Map<String, String>> proverbsList;

  const WordListScreen({
    super.key,
    required this.wordList,
    required this.idiomsList,
    required this.proverbsList,
  });

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchType = 'Kelime';

  Map<String, Map<String, String>> _filteredList = {};

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filteredList = {...widget.wordList};
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// ⏳ Debounce – hızlı yazarken her harfte filtreleme yapmaz
  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _filterWords();
    });
  }

  void _filterWords() {
    final query = _searchController.text.toLowerCase().trim();

    Map<String, Map<String, String>> sourceList;

    switch (_searchType) {
      case 'Kelime':
        sourceList = widget.wordList;
        break;
      case 'Deyim':
        sourceList = widget.idiomsList;
        break;
      default:
        sourceList = widget.proverbsList;
    }

    if (query.isEmpty) {
      setState(() {
        _filteredList = {...sourceList};
      });
      return;
    }

    final Map<String, Map<String, String>> filtered = {};

    sourceList.forEach((key, attributes) {
      final keyLower = key.toLowerCase();

      final inMeaning = _checkIfMatchesInMeaning(attributes, query);

      if (keyLower.contains(query) || inMeaning) {
        filtered[key] = attributes;
      }
    });

    // 🔠 alfabetik sırala
    final sortedKeys = filtered.keys.toList()..sort((a, b) => a.compareTo(b));
    final sortedMap = {for (var k in sortedKeys) k: filtered[k]!};

    setState(() => _filteredList = sortedMap);
  }

  bool _checkIfMatchesInMeaning(Map<String, String> attributes, String query) {
    for (var field in ['Anlam', 'Anlam1', 'Anlam2']) {
      if ((attributes[field] ?? '').toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  /// 🔍 eşleşen metni kalın vurgula
  TextSpan _highlightQuery(String text) {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return TextSpan(text: text);

    final lower = text.toLowerCase();

    final start = lower.indexOf(query);
    if (start == -1) return TextSpan(text: text);

    final end = start + query.length;

    return TextSpan(children: [
      TextSpan(text: text.substring(0, start)),
      TextSpan(
        text: text.substring(start, end),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: text.substring(end)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // klavyeyi kapat
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sözlük"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    value: _searchType,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _searchType = value;
                        _searchController.clear();
                      });
                      _filterWords();
                    },
                    items: const [
                      'Kelime',
                      'Deyim',
                      'Atasözü',
                    ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Arama',
                        hintText: '$_searchType ara...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: _filteredList.isEmpty
                    ? const Center(
                        child: Text(
                          "Sonuç bulunamadı",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : Scrollbar(
                        child: ListView.builder(
                          itemCount: _filteredList.length,
                          itemBuilder: (context, index) {
                            final key = _filteredList.keys.elementAt(index);
                            final data = _filteredList[key]!;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ExpansionTile(
                                title: RichText(
                                  text: _highlightQuery(key),
                                ),
                                subtitle: Text(_searchType),
                                childrenPadding: const EdgeInsets.all(8),
                                children: [
                                  if ((data['Anlam'] ?? '').isNotEmpty)
                                    ListTile(
                                      title: const Text("Anlam"),
                                      subtitle: Text(data['Anlam']!),
                                    ),
                                  if ((data['Anlam1'] ?? '').isNotEmpty)
                                    ListTile(
                                      title: const Text("Alternatif 1"),
                                      subtitle: Text(data['Anlam1']!),
                                    ),
                                  if ((data['Anlam2'] ?? '').isNotEmpty)
                                    ListTile(
                                      title: const Text("Alternatif 2"),
                                      subtitle: Text(data['Anlam2']!),
                                    ),
                                  if ((data['level'] ?? '').isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Chip(
                                        label: Text("Seviye: ${data['level']}"),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
