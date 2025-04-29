import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> toggleMusic(bool value) async {
    _isPlaying = value;
    notifyListeners();

    if (value) {
      await _player.play(AssetSource('audio/background.mp3'), volume: 0.5);
      _player.setReleaseMode(ReleaseMode.loop);
    } else {
      await _player.stop();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
