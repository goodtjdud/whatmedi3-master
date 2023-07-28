import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:whatmedi3/pages/settingpage.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:whatmedi3/pages/searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; //얘를 임포트해줘야지 안드로이드인지 ios인지 구별가능해짐
import 'package:whatmedi3/tts/tts.dart';
// StateManagementClass.dart
class StateManagementClass {
  final FlutterTts tts = FlutterTts();

  Future<void> play(String text) async {
    await tts.speak(text);
  }

  void stop() {
    tts.stop();
  }
}

// MyApp.dart (or the main application file)
class MyApp extends StatelessWidget {
  final StateManagementClass stateManager = StateManagementClass();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ... other app configurations

      navigatorObservers: [
        _RouteChangeObserver(stateManager),
      ],

      home: SearchedPage(
        mediinfo: {}, // Add your initial data here
      ),
    );
  }
}

// _RouteChangeObserver.dart
class _RouteChangeObserver extends RouteObserver<PageRoute<dynamic>> {
  final StateManagementClass stateManager;

  _RouteChangeObserver(this.stateManager);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != '/searched_page') {
      stateManager.stop();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name != '/searched_page') {
      stateManager.stop();
    }
  }

// Handle other route change events as needed
}

// SearchedPage.dart
class SearchedPage extends StatefulWidget {
  SearchedPage({Key? key, required this.mediinfo}) : super(key: key);

  final Map mediinfo;

  @override
  _SearchedPageState createState() => _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage> {
  final StateManagementClass stateManager = StateManagementClass();

  @override
  void initState() {
    choice();
    set();
    if (isSwitched == true) {
      Future<void>.delayed(const Duration(milliseconds: 100));
      stateManager.play(pummok + upche + sungbun + hyoneung + youngbup);
    }
    super.initState();
  }

  @override
  void dispose() {
    stateManager.stop();
    super.dispose();
  }

// Rest of the code...
}