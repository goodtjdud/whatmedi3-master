import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  int _selectedIndex = 0;

  Future<CameraDescription> cameraA() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    return firstCamera;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]); //스크린 세로로 고정하는 것.

    // setState(() {
    //   tts.speak('.');
    // });
    return Scaffold(
        backgroundColor:
            whatmedicol.medipink, //이거는 이제 각 페이지 마다 생각해줘야 해 백그라운드 배경색.
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            SearchPage(),
            TakePictureScreen(),
            SettingPage(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: 110.6 + 2.4 + 3.0, //족므 더 생각//pixel 오버플로우 나타나서 2.4 더해주긴 했음
            padding: EdgeInsets.all(0),
            child: ClipRRect(
              //borderRadius: BorderRadius.circular(50.0),

              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              //이런것도 있다 정도로만 알아두기

              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,

                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: _selectedIndex,
                backgroundColor: whatmedicol.medigreen,
                //이거보다 약간은 연하게 해주는 색 찾기
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedLabelStyle: TextStyle(
                  //height: 1.6,
                  fontSize: 30,
                  color: whatmedicol.medipink,
                ),
                unselectedLabelStyle: TextStyle(
                  //height: 1.6,
                  fontSize: 20,
                  color:
                      whatmedicol.medipinkwhite, //이거도 위에처럼 약간은 연하게 해주는 색 찾아서 넣기
                ), // your text style
                iconSize: 25,
                selectedIconTheme: IconThemeData(size: 35),
                selectedItemColor: whatmedicol.medipink,
                unselectedItemColor: whatmedicol.medipinkwhite,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                    ),
                    label: "검색",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.camera_alt,
                    ),
                    label: "촬영",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                    ),
                    label: "설정",
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
