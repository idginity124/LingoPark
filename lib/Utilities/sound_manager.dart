import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  // Varsayılan Ayarlar
  static bool _isSoundOn = true;
  static bool _isVibrationOn = true;

  // Uygulama açılınca ayarları yükle (main.dart'ta çağıracağız)
  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundOn = prefs.getBool('sound') ?? true;
    _isVibrationOn = prefs.getBool('vibration') ?? true;
  }

  // Ayarları Değiştirme
  static Future<void> toggleSound(bool value) async {
    _isSoundOn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', value);
  }

  static Future<void> toggleVibration(bool value) async {
    _isVibrationOn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration', value);
  }

  // Getter'lar (Ayarlar ekranı için)
  static bool get isSoundOn => _isSoundOn;
  static bool get isVibrationOn => _isVibrationOn;

  // --- TİTREŞİM (Kontrollü) ---
  static void playClickHaptic() {
    if (_isVibrationOn) HapticFeedback.lightImpact();
  }

  static void playSuccessHaptic() {
    if (_isVibrationOn) HapticFeedback.mediumImpact();
  }

  static void playErrorHaptic() {
    if (_isVibrationOn) HapticFeedback.heavyImpact();
  }

  // --- SES (Kontrollü) ---
  static Future<void> playClickSound() async {
    if (!_isSoundOn) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.play(AssetSource('sounds/click.mp3'), volume: 0.5);
    } catch (e) {/* Hata yut */}
  }

  static Future<void> playCorrectSound() async {
    if (!_isSoundOn) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.play(AssetSource('sounds/correct.mp3'));
    } catch (e) {/* Hata yut */}
  }

  static Future<void> playWrongSound() async {
    if (!_isSoundOn) return;
    try {
      if (_player.state == PlayerState.playing) await _player.stop();
      await _player.play(AssetSource('sounds/wrong.mp3'));
    } catch (e) {/* Hata yut */}
  }
}
