import 'dart:math';

/// İki metin arasındaki Levenshtein mesafesini hesaplar.
///
/// Bu fonksiyon, kullanıcının girdiği kelime ile doğru cevap arasındaki
/// harf farkını bulur.
///
/// Örnekler:
/// levenshtein('elma', 'elma') -> 0 (Tam eşleşme)
/// levenshtein('elma', 'elm') -> 1 (1 harf eksik)
/// levenshtein('kalem', 'kelam') -> 2 (2 harf değişmiş)
int levenshtein(String s1, String s2) {
  // Eğer kelimeler aynıysa işlem yapmaya gerek yok
  if (s1 == s2) return 0;

  final int len1 = s1.length;
  final int len2 = s2.length;

  // Eğer biri boşsa, diğerinin uzunluğu kadar mesafe gerekir
  if (len1 == 0) return len2;
  if (len2 == 0) return len1;

  // DP (Dynamic Programming) tablosunu oluşturuyoruz
  List<List<int>> dp = List.generate(
    len1 + 1,
    (index) => List<int>.filled(len2 + 1, 0),
  );

  // Tablonun ilk satır ve sütunlarını dolduruyoruz
  for (int i = 0; i <= len1; i++) {
    dp[i][0] = i;
  }
  for (int j = 0; j <= len2; j++) {
    dp[0][j] = j;
  }

  // Mesafeyi hesaplıyoruz
  for (int i = 1; i <= len1; i++) {
    for (int j = 1; j <= len2; j++) {
      // Karakterler aynı mı? (Dart string indexleri 0'dan başlar, o yüzden i-1 ve j-1)
      int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;

      // Silme (delete), Ekleme (insert) veya Değiştirme (substitute) işlemlerinden
      // maliyeti en düşük olanı seçiyoruz.
      dp[i][j] = min(
        dp[i - 1][j] + 1, // Silme
        min(
          dp[i][j - 1] + 1, // Ekleme
          dp[i - 1][j - 1] + cost, // Değiştirme
        ),
      );
    }
  }

  // Tablonun sağ alt köşesindeki değer, iki kelime arasındaki mesafedir
  return dp[len1][len2];
}
