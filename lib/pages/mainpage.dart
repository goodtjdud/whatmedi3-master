import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:whatmedi3/pages/searchpage.dart';
import 'package:whatmedi3/pages/settingpage.dart';
import 'package:whatmedi3/pages/takepicturescreen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required CameraDescription requiredCamera})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FlutterTts tts = FlutterTts();
  PageController _pageController = PageController(initialPage: 0); // Add this line and set the initialPage

  Future<CameraDescription> cameraA() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    return firstCamera;
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the page controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: whatmedicol.medipink,
      body: PageView(
        controller: _pageController,
        children: const [
          SearchPage(),
          TakePictureScreen(),
          SettingPage(),
        ],
        onPageChanged: (index) {
          // You can do something when the page changes if needed
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 110.6 + 2.4 + 3.0,
          padding: EdgeInsets.all(0),
          child: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              backgroundColor: whatmedicol.medigreen,

              onTap: (index) {
                // Use _pageController to animate the page transition when tapping on a bottom navigation bar item
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 30),
                  curve: Curves.easeInOut,
                );
              },
              selectedItemColor: whatmedicol.medipink,
              unselectedItemColor: whatmedicol.medipinkwhite,
              items: [
                BottomNavigationBarItem(
                  icon: Semantics(
                    excludeSemantics: true,
                    child: Icon(
                      Icons.search,
                      size: 30,
                      semanticLabel: '검색 탭',
                    ),
                  ),
                  label: "검색",
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    excludeSemantics: true,
                    child: Icon(
                      size: 30,
                      Icons.camera_alt,
                      semanticLabel: '촬영 탭',
                    ),
                  ),
                  label: "촬영",
                ),
                BottomNavigationBarItem(
                  icon: Semantics(
                    excludeSemantics: true,
                    child: Icon(
                      size: 30,
                      Icons.settings,
                      semanticLabel: '설정 탭',
                    ),
                  ),
                  label: "설정",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}