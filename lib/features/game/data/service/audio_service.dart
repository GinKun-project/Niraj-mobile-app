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
    await _backgroundPlayer.play(AssetSource('sounds/backgound.wav'));
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  Future<void> playSwordSwing() async {
    await _effectPlayer.play(AssetSource('sounds/sword.wav'));
  }

  Future<void> playCriticalHit() async {
    await _effectPlayer.play(AssetSource('sounds/crit.mp3'));
  }

  Future<void> playImpact() async {
    await _effectPlayer.play(AssetSource('sounds/impact.wav'));
  }

  Future<void> playMenuSelect() async {
    await _effectPlayer.play(AssetSource('sounds/menu.wav'));
  }

  Future<void> playTurnNotification() async {
    await _effectPlayer.play(AssetSource('sounds/notification.mp3'));
  }

  Future<void> playFightersReady() async {
    await _sensorPlayer.play(AssetSource('sounds/notification.mp3'));
  }

  void dispose() {
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
    _sensorPlayer.dispose();
  }
}
