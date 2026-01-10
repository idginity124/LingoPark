import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelime_oyunu/Screens/quiz_screen.dart'; // QuizScreen import ediyoruz

void main() {
  testWidgets('Test QuizScreen Widgets and Logic', (WidgetTester tester) async {
    // Widget'ı başlatıyoruz
    await tester.pumpWidget(
      MaterialApp(
        home: QuizScreen(
          toggleTheme: () {}, // Theme değiştirici fonksiyon
          isDarkTheme: false, // Tema karanlık mı değil mi?
          difficulty: 'Easy', // Zorluk seviyesi
          wordList: {
            'Easy': {
              'apple': 'elma', // örnek kelime verisi
            },
          },
        ),
      ),
    );

    // Test 1: Yükleme işlemi sırasında bir CircularProgressIndicator görmeliyiz
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Test 2: Kelimeler yüklendikten sonra, kelimeyi görmek için veriyi kontrol etmeliyiz
    await tester.pumpAndSettle(); // Yüklenen widget'ları bekliyoruz

    // Kelimeyi görmeliyiz, yani kelimenin mevcut olduğuna dair bir test
    expect(find.text('Kelime:'), findsOneWidget);

    // Test 3: Kullanıcı doğru cevabı verirse mesajın "Doğru!" olduğuna emin olalım
    await tester.enterText(
        find.byType(TextField), 'elma'); // Yanıtı doğru giriyoruz
    await tester.tap(find.text('Cevabı Kontrol Et'));
    await tester.pump();

    // Doğru cevabı verdiğinde "Doğru!" mesajını görmeliyiz
    expect(find.text('Doğru!'), findsOneWidget);

    // Test 4: Yanlış cevabı girerse "Yanlış! Tekrar deneyin." mesajını alırız
    await tester.enterText(
        find.byType(TextField), 'banana'); // Yanlış cevabı giriyoruz
    await tester.tap(find.text('Cevabı Kontrol Et'));
    await tester.pump();

    // Yanlış cevabı verdiğinde "Yanlış! Tekrar deneyin." mesajını görmeliyiz
    expect(find.text('Yanlış! Tekrar deneyin.'), findsOneWidget);

    // Test 5: "Cevabı Göster" butonuna tıkladığında, cevabın doğru şekilde göründüğüne emin olalım
    await tester.tap(find.text('Cevabı Göster'));
    await tester.pump();

    // Cevap mesajının doğru bir şekilde göründüğünü test ediyoruz
    expect(find.text('Cevap: elma'), findsOneWidget);

    // Test 6: Boş cevap girildiğinde uygun hata mesajı gösteriliyor mu?
    await tester.enterText(find.byType(TextField), ''); // Boş cevap
    await tester.tap(find.text('Cevabı Kontrol Et'));
    await tester.pump();

    // Boş cevap girildiğinde hata mesajı gösterilmeli
    expect(find.text('Cevap girmeniz gerekiyor!'), findsOneWidget);

    // Test 7: Geçersiz karakter girildiğinde uygun mesaj gösteriliyor mu?
    await tester.enterText(
        find.byType(TextField), '!@#'); // Geçersiz karakterler
    await tester.tap(find.text('Cevabı Kontrol Et'));
    await tester.pump();

    // Geçersiz karakterler için hata mesajı gösterilmeli
    expect(find.text('Lütfen geçerli bir cevap girin!'), findsOneWidget);
  });
}
