import 'package:audioplayers/audioplayers.dart';

class AudioController {
  
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;

  late AudioPlayer _player;
  bool _initialized = false;

  AudioController._internal();

  Future<void> init() async {
    if (_initialized) return;

    _player = AudioPlayer();

    
    await _player.setReleaseMode(ReleaseMode.loop);

    
    await _player.play(
      AssetSource('audio/le_mal_du_pays.mp3'),
      volume: 0.3, // gentle background volume
    );

    _initialized = true;
  }

  void stop() {
    _player.stop();
  }
}
