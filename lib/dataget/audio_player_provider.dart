import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  void toggleAudio() async {
    if (_isPlaying) {
      await player.stop();
    } else {
      await player.play(
        AssetSource('guide.m4a'),
      );
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }
}
