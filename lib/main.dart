import 'package:flutter/material.dart';
import 'package:whatmedi3/pages/mainpage.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  //Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
  await prefs.setBool('isFirstRun', false);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xfff6cecc)),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: isFirstRun
          ? IntroScreen(
        requiredCamera: firstCamera,
      )
          : MainPage(requiredCamera: firstCamera),
    ),
  );
}

class IntroScreen extends StatefulWidget {
  final CameraDescription requiredCamera;
  final Future<List<CameraDescription>> camerasFuture;
  final Future<CameraDescription> firstCameraFuture;

  IntroScreen({required this.requiredCamera})
      : camerasFuture = availableCameras(),
        firstCameraFuture = availableCameras().then((cameras) => cameras.first);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

  class _IntroScreenState extends State<IntroScreen> {
    int musicStart = 0;
    Icon play = Icon(
      Icons.play_circle,
      color: Colors.black,
      size: 40,
    );
    final player = AudioPlayer();
    Text message = Text("오디오 재생");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '앱 사용 설명 페이지',
        style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () => setState(
                () {
                  if (musicStart == 0) {
                    player.play(
                      AssetSource('guide.m4a'),
                    );
                    musicStart = 1;
                    message = Text("오디오 정지");
                  } else {
                    player.stop();
                    musicStart = 0;
                    message = Text("오디오 재생");
                  }
                }
              ),
                // TODO: Implement audio playback logic
              child: message,
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                player.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      requiredCamera: widget.requiredCamera,
                    ),
                  ),
                );
              },
              child: Text('홈페이지로'),
            ),
          ),
        ],
      ),
    );
  }
}
