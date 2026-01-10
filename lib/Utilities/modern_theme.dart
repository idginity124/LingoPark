import 'package:flutter/material.dart';

class AppThemes {
  // Yeni Premium Tema İsimleri
  static const String luxuryGold = "Lüks Altın";
  static const String cyberNeon = "Siber Neon";
  static const String royalPurple = "Asil Mor";
  static const String deepOcean = "Derin Okyanus";
  static const String crimsonRed = "Kızıl Ejder";

  // Tüm temaların listesi
  static final Map<String, ThemeData> themeOptions = {
    luxuryGold: _buildTheme(
      primaryColor: const Color(0xFFFFD700), // Altın Sarısı
      bgColor: const Color(0xFF121212), // Mat Siyah
      cardColor: const Color(0xFF1E1E1E), // Koyu Gri
      textColor: const Color(0xFFE0E0E0),
      accentColor: const Color(0xFFB8860B), // Koyu Altın (Gölge için)
    ),
    cyberNeon: _buildTheme(
      primaryColor: const Color(0xFF00E5FF), // Neon Camgöbeği
      bgColor: const Color(0xFF09090B), // Çok Koyu Lacivert/Siyah
      cardColor: const Color(0xFF1C1C24),
      textColor: const Color(0xFFE0FFFF),
      accentColor: const Color(0xFF00B8D4),
    ),
    royalPurple: _buildTheme(
      primaryColor: const Color(0xFFD500F9), // Canlı Mor
      bgColor: const Color(0xFF0F0518), // Çok Koyu Mor/Siyah
      cardColor: const Color(0xFF1D0E2C),
      textColor: const Color(0xFFE1BEE7),
      accentColor: const Color(0xFFAA00FF),
    ),
    deepOcean: _buildTheme(
      primaryColor: const Color(0xFF00B0FF), // Pasifik Mavisi
      bgColor: const Color(0xFF001018), // Siyaha yakın mavi
      cardColor: const Color(0xFF031F2E),
      textColor: const Color(0xFFE1F5FE),
      accentColor: const Color(0xFF01579B),
    ),
    crimsonRed: _buildTheme(
      primaryColor: const Color(0xFFFF1744), // Ateş Kırmızısı
      bgColor: const Color(0xFF140505), // Siyaha yakın kırmızı
      cardColor: const Color(0xFF2B0B0B),
      textColor: const Color(0xFFFFEBEE),
      accentColor: const Color(0xFFD50000),
    ),
  };

  // Tema Oluşturucu
  static ThemeData _buildTheme({
    required Color primaryColor,
    required Color bgColor,
    required Color cardColor,
    required Color textColor,
    required Color accentColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: bgColor,
      cardColor: cardColor,
      hintColor: accentColor, // Bunu ikincil renk olarak kullanacağız

      // Yazı Stilleri
      textTheme: TextTheme(
        bodyMedium:
            TextStyle(color: textColor, fontSize: 16, fontFamily: 'Roboto'),
        titleLarge: TextStyle(
            color: primaryColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: cardColor, // AppBar artık kart renginde (Daha modern)
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: primaryColor, fontSize: 22, fontWeight: FontWeight.bold),
      ),

      // Butonlar (Daha Premium)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor:
              bgColor, // Buton yazısı arkaplan rengi olsun (Kontrast)
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)), // Daha yuvarlak
          elevation: 8,
          shadowColor:
              primaryColor.withOpacity(0.5), // Renkli gölge (Glow efekti verir)
          textStyle: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),
      ),

      // BottomSheet (Tema Seçici Paneli için)
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        modalBackgroundColor: cardColor,
      ),

      // Inputlar
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
    );
  }
}
