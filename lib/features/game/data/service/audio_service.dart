import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _sensorPlayer = AudioPlayer();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _effectPlayer.setReleaseMode(ReleaseMode.stop);
    await _sensorPlayer.setReleaseMode(ReleaseMode.stop);
    _isInitialized = true;
  }

  Future<void> playBackgroundMusic() async {
    try {
      await _backgroundPlayer.play(AssetSource('sounds/backgound.wav'));
    } catch (e) {
      print('Background music error: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundPlayer.stop();
    } catch (e) {
      print('Stop background music error: $e');
    }
  }

  Future<void> playSwordSwing() async {
    try {
      await _effectPlayer.play(AssetSource('sounds/sword.wav'));
    } catch (e) {
      print('Sword swing error: $e');
    }
  }

  Future<void> playCriticalHit() async {
    try {
      await _effectPlayer.play(AssetSource('sounds/crit.mp3'));
    } catch (e) {
      print('Critical hit error: $e');
    }
  }

  Future<void> playImpact() async {
    try {
      await _effectPlayer.play(AssetSource('sounds/impact.wav'));
    } catch (e) {
      print('Impact error: $e');
    }
  }

  Future<void> playMenuSelect() async {
    try {
      await _effectPlayer.play(AssetSource('sounds/menu.wav'));
    } catch (e) {
      print('Menu select error: $e');
    }
  }

  Future<void> playTurnNotification() async {
    try {
      await _effectPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      print('Turn notification error: $e');
    }
  }

  Future<void> playSkillSound() async {
    try {
      await _effectPlayer.play(AssetSource('sounds/skill.wav'));
    } catch (e) {
      print('Skill sound error: $e');
    }
  }

  Future<void> playFightersReady() async {
    try {
      await _sensorPlayer.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      print('Fighters ready error: $e');
    }
  }

  void dispose() {
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
    _sensorPlayer.dispose();
  }
}
