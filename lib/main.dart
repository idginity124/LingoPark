import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/db_service.dart';
import 'Services/user_profile_service.dart';
import 'Screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dikey moda kilitle
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Servis init
  await UserProfileService.init();
  await DbService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 0 = sistem
  /// 1 = açık
  /// 2 = koyu
  int _themeModeIndex = 0;

  static const String _themePrefKey = "app_theme_mode";

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  /// 🔹 Önceden seçilen temayı yükle
  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_themePrefKey) ?? 0;

    if (!mounted) return;
    setState(() => _themeModeIndex = saved);
  }

  /// 🔹 Tema değiştir ve kaydet
  Future<void> _setThemeMode(int index) async {
    // güvenlik: sadece 0/1/2
    final safeIndex = (index < 0 || index > 2) ? 0 : index;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, safeIndex);

    if (!mounted) return;
    setState(() => _themeModeIndex = safeIndex);
  }

  ThemeMode get _themeMode {
    switch (_themeModeIndex) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // ☀️ AÇIK TEMA
  ThemeData get _lightTheme => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.deepPurple,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme:
            GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: Colors.black87,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      );

  // 🌑 KOYU TEMA
  ThemeData get _darkTheme => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: Colors.tealAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.tealAccent,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.tealAccent),
          trackColor:
              WidgetStateProperty.all(Colors.tealAccent.withOpacity(0.4)),
        ),
        textTheme:
            GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.amber,
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lingo Park',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,

      // Başlangıç ekranı
      home: SplashScreen(
        isDarkTheme: _themeModeIndex == 2,
        toggleTheme: (bool isDark) {
          // true = koyu, false = açık
          _setThemeMode(isDark ? 2 : 1);
        },
      ),
    );
  }
}
