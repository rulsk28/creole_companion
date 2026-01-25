import 'package:audioplayers/audioplayers.dart';

class AudioController {
  
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;

  late AudioPlayer _player;
  bool _initialized = false;
  
  // Track preference state locally
  bool _isMuted = false;

  AudioController._internal();

  Future<void> init() async {
    if (_initialized) return;

    _player = AudioPlayer();

    // Set to loop forever
    await _player.setReleaseMode(ReleaseMode.loop);
    
    // Default: Play on start
    await _player.play(
      AssetSource('audio/le_mal_du_pays.mp3'),
      volume: 0.3, // Gentle background volume
    );

    _initialized = true;
  }

  // --- NEW: Toggle Logic ---
  Future<void> toggleMusic() async {
    if (!_initialized) return;

    if (_player.state == PlayerState.playing) {
      await _player.pause();
      _isMuted = true;
    } else {
      await _player.resume();
      _isMuted = false;
    }
  }

  // --- NEW: Status Checker ---
  bool get isPlaying => _player.state == PlayerState.playing;

  void stop() {
    _player.stop();
  }
}