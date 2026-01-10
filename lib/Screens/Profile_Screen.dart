import 'package:flutter/material.dart';
import '../Services/user_profile_service.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final Function(String) updateUserName;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.updateUserName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  bool isLoading = true;

  int favoriteCount = 0;
  int currentXp = 0;
  String currentRank = "Yükleniyor...";
  int nextRankTarget = 100;

  List<Map<String, dynamic>> earnedBadges = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _loadStats();
  }

  Future<void> _loadStats() async {
    final profile = await UserProfileService.load();

    if (!mounted) return;

    setState(() {
      favoriteCount = profile.favorites.length;
      currentXp = profile.xp;
      currentRank = profile.rankTitle;
      nextRankTarget = profile.nextRankTarget == 0 ? 1 : profile.nextRankTarget;
      earnedBadges = profile.achievements;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    String newName = _nameController.text.trim();
    if (newName.isEmpty) newName = "Misafir";

    widget.updateUserName(newName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profil güncellendi! ✅'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    Color primaryColor = Theme.of(context).primaryColor;
    Color cardColor = Theme.of(context).cardColor;
    Color textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    double progress = currentXp / nextRankTarget;
    progress = progress.clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Oyuncu Kartı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar ve Rank
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 4),
                    ),
                    child: Icon(Icons.account_circle,
                        size: 80, color: primaryColor),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currentRank.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    "$currentXp XP",
                    style: TextStyle(
                        fontSize: 16, color: textColor.withOpacity(0.6)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Level Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sonraki Rütbe",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${(progress * 100).toInt()}%"),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: cardColor,
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 5),
            Text("Hedef: $nextRankTarget XP",
                style:
                    TextStyle(fontSize: 12, color: textColor.withOpacity(0.5))),

            const SizedBox(height: 30),

            // İstatistik Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("Favoriler", "$favoriteCount", Icons.favorite),
                  _buildStatItem("Zorluk", "A1–C1", Icons.bar_chart),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Rozetler
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Başarı Rozetleri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: earnedBadges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final badge = earnedBadges[index];
                final bool isLocked = badge['locked'] == true;

                return Container(
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey.withOpacity(0.1) : cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLocked ? '🔒' : (badge['icon'] ?? '🏆'),
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        badge['title'] ?? 'Rozet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : textColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Oyuncu Adı',
                prefixIcon: Icon(Icons.edit),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('KAYDET'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
