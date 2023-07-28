import 'package:flutter/material.dart';
//import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro Views Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final pages = [
    PageViewModel(
      title: Text("Welcome"),
      body: Text("This is an introduction screen."),
      //image: Image.asset('assets/images/intro_image_1.png'),
    ),
    PageViewModel(
      title: Text("Features"),
      body: Text("Discover amazing features."),
      //image: Image.asset('assets/images/intro_image_2.png'),
    ),
    PageViewModel(
      title: Text("Get Started"),
      body: Text("Let's get started!"),
      //image: Image.asset('assets/images/intro_image_3.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      showNextButton: true,
      showSkipButton: true,
      onTapSkipButton: () {
        // Skip 버튼을 눌렀을 때 처리할 작업
        // 여기에서는 현재 페이지를 종료하고 다음 화면으로 이동합니다.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      onTapDoneButton: () {
        // Done 버튼을 눌렀을 때 처리할 작업
        // 여기에서는 현재 페이지를 종료하고 다음 화면으로 이동합니다.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}
