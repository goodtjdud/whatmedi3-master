import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:whatmedi3/pages/settingpage.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:whatmedi3/pages/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; //얘를 임포트해줘야지 안드로이드인지 ios인지 구별가능해짐
import 'package:whatmedi3/tts/tts.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_accessibility_service/accessibility_event.dart';

import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter/services.dart';



class SearchedPage extends StatefulWidget with WidgetsBindingObserver {
  SearchedPage({Key? key, required this.mediinfo}) : super(key: key);
  final Map mediinfo;
  //final double speechRateInt;
  @override
  _SearchedPageState createState() => _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage>
    with WidgetsBindingObserver {
  final speech = TtsService();
  final FlutterTts tts = FlutterTts();
  //double speechrateint2 = speechRateInt;
  // Future set2() async {
  //   await tts.setLanguage('ko-KR');
  //   await tts.setSpeechRate(speechRateInt);
  // }

  set() {
    tts.setPitch(pitchRateInt);
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    tts.setSpeechRate(isAndroid ? speechRateInt / 2 : speechRateInt);
    // await tts.setSpeechRate(Platform.isAndroid
//     //     ? (speechRateInt == 1 ? speechRateInt : speechRateInt / 2)
//     //     : speechRateInt);
    tts.setLanguage('ko-KR');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      speech.stop();
      // 앱이 백그라운드로 이동할 때 TTS 중지
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    //WidgetsBinding.instance?.addObserver(this);
    choice();
    //TtsService._isSpeaking = false;
    if (isSwitched == true && TtsService._isSpeaking == false) {
      //FlutterAccessibilityService.;
      //FlutterAccessibility.disableAccessibility();
      MethodChannel('flutter/accessibility')
          .invokeMethod<void>('decreaseAccessibility');
      Future<void>.delayed(const Duration(milliseconds: 1000));
      play();
      MethodChannel('flutter/accessibility')
          .invokeMethod<void>('increaseAccessibility');
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    //WidgetsBinding.instance?.removeObserver(this);
    //TtsService._isSpeaking = true;
    speech.stop();
    setState(() {
      TtsService._isSpeaking = false;
    });
    super.dispose();
  }

  TextStyle bold = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  TextStyle regular = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );

  String pummok = '';
  String upche = '';
  String sungbun = '';
  String hyoneung = '';
  String youngbup = '';
  String juyi = '';
  void choice() {
    if (isTitle == true) {
      pummok = ',,,품목명: ${widget.mediinfo["title"]}';
    } else {
      pummok = '';
    }
    if (isCorp == true) {
      upche = ',,,업체명: ${widget.mediinfo["corp"]}';
    } else {
      upche = '';
    }
    if (isIngredient == true) {
      sungbun = ',,,성분: ${widget.mediinfo["ingredient"]}';
    } else {
      sungbun = '';
    }
    if (isEffect == true) {
      hyoneung = ',,,효능효과: ${widget.mediinfo["effect"]}';
    } else {
      hyoneung = '';
    }
    if (isUsage == true) {
      youngbup = ',,,용법용량: ${widget.mediinfo["usage"]}';
    } else {
      youngbup = '';
    }
    if (isWarning == true) {
      juyi = ',,,주의사항: ${widget.mediinfo["warning"]}';
    } else {
      juyi = '';
    }
  }

  Future play() async {
    set();
    await speech.speak(pummok + upche + sungbun + hyoneung + youngbup + juyi);
  }
  // Future play2() async {
  //   await speech.speak(pummok + upche + sungbun + hyoneung + youngbup);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whatmedicol.medipink,
        appBar: AppBar(
          backgroundColor: Colors.white30,
          elevation: 0,
          title: Text(widget.mediinfo["title"]),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '품목명',
                          style: bold,
                        ),
                        TextSpan(
                          text: ': ${widget.mediinfo["title"]}',
                          style: regular
                        ),
                      ],
                    ),
                  ),
              SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '성분',
                          style: bold,
                        ),
                        TextSpan(
                          text: ': ${widget.mediinfo["ingredient"]}',
                          style: regular,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '효능효과',
                          style: bold,
                        ),
                        TextSpan(
                          text: ': ${widget.mediinfo["effect"]}',
                          style: regular,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '용법용량',
                          style: bold,
                        ),
                        TextSpan(
                          text: ': ${widget.mediinfo["usage"]}',
                          style: regular,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '주의사항',
                          style: bold,
                        ),
                        TextSpan(
                          text: ': ${widget.mediinfo["warning"]}',
                          style: regular,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                  height: 20,
                  ),
              ]),
            ),
          ),
        ));
  }
}

class TtsService {
  FlutterTts _flutterTts = FlutterTts();
  static bool _isSpeaking = false;
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
      _isSpeaking = true;
      await _flutterTts.speak(text);
      //_isSpeaking = false;
    }
  }

  Future<void> stop() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
    }
  }
}