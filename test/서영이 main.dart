import 'dart:async';
// import 'dart:io';
import 'package:flutter/material.dart';
import '../pages/takepicturescreen.dart';
import 'package:camera/camera.dart';
import 'package:untitled/pages/searchpage.dart';
import 'package:untitled/pages/settingpage.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  ///Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  ///

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: MainPage(requiredCamera: firstCamera),
      // Pass the appropriate camera to the TakePictureScreen widget.
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required CameraDescription requiredCamera})
      : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  // Future<CameraDescription> cameraA() async {
  //   final cameras = await availableCameras();
  //   final firstCamera = cameras.first;
  //   return firstCamera;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SearchPage(),
          TakePictureScreen(),
          // FutureBuilder(
          //     future: cameraA(),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData == false) {
          //         print('error here');
          //         return CircularProgressIndicator();
          //       }
          //       else if (snapshot.hasError) {
          //         return Center(
          //             child: Text("Error: ${snapshot.error}")
          //         );
          //       }
          //       else {
          //         final theCamera = snapshot.data;
          //         return TakePictureScreen(camera: theCamera);
          //       }
          //     }),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 110.6,
        child: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.lightGreen[50],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: TextStyle(
            height: 1.6,
            fontSize: 25,
            color: Colors.black,
          ),
          unselectedLabelStyle: TextStyle(
            height: 1.6,
            fontSize: 25,
            color: Colors.black54,
          ), // your text style
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 32),
              label: "검색",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt, size: 32),
              label: "촬영",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 32),
              label: "설정",
            ),
          ],
        ),
      ),
    );
  }
}
