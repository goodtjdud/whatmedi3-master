import 'package:flutter_tts/flutter_tts.dart';
import 'package:whatmedi3/pages/settingpage.dart';
import 'package:whatmedi3/pages/searchpage.dart';

class TtsService {
  FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  static final TtsService _instance = TtsService._internal();
  factory TtsService() {
    return _instance;
  }
  TtsService._internal() {
    _initTts();
  }
  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ko-KR');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(speechRateInt);
  }

  Future<void> speak(String text) async {
    if (!_isSpeaking) {
      await _flutterTts.speak(text);
      _isSpeaking = true;
    }
  }

  Future<void> stop() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
    }
  }
}
