import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
  });

  // final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool active = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // To display the current output from the Camera,
    // create a CameraController.
    _initCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///여기서부터 아래에 있는 부분까지 카메라 라이프 사이클 관련된 코드

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // _initCamera();
      print("Resumed");
      _initCamera();
      // _controller?.resumePreview();
    }
    // else if (state == AppLifecycleState.inactive) {
    //   active = false;
    //   print("Inactive");
    // } else if (state == AppLifecycleState.detached) {
    //   print ("Detached");
    // }
    else if (state == AppLifecycleState.paused) {
      print("Paused");
      _controller?.pausePreview();
    }
  }

  _initCamera() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      availableCameras().then((value) async {
        if (!mounted) {
          return;
        }
        if (value.isEmpty) {
          setState(() {
            active = false;
          });
          return;
        }
        await _setupCamera(value);
      });
    });
  }

  _setupCamera(List<CameraDescription> value) async {
    try {
      final cameraController =
          CameraController(value[0], ResolutionPreset.medium);
      cameraController.addListener(() {});
      _controller = cameraController;

      await _controller?.initialize();
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      setState(() {
        active = false;
      });
      print("Failed to create camera with $e");
    }
  }

  ///
  ///
  /// 여기까지가 앱사이클 관련된 코딩이라고 생각하면 돼
  int tapNumber = 0;
  Icon flash = Icon(
    Icons.flash_on_outlined,
    color: Colors.black,
    size: 40,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _controller?.initialize(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller!);
          } else {
            print("connection not done");
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: getFloatingButtons(),
    );
  }

  Widget getFloatingButtons() {
    return
        // Padding(
        // padding: const EdgeInsets.only(bottom:20),
        SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        //아마 root app의 height인 90이상으로 SizedBox 넣어줘야 할듯 아래에 Row 밑에 넣음
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 45),
              IconButton(
                onPressed: () async {
                  // Take the Picture in a try / catch block. If anything goes wrong,
                  // catch the error.
                  try {
                    // Ensure that the camera is initialized.
                    await _controller?.initialize();

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller!.takePicture();
                    postRequest() async {
                      File imageFile = File(image.path);
                      List<int> imageBytes = imageFile.readAsBytesSync();
                      String base64Image = base64Encode(imageBytes);
                      print(base64Image);
                      Uri url = Uri.parse('your_server_ip/test');
                      http.Response response = await http.post(
                        url,
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        }, // this header is essential to send json data
                        body: jsonEncode([
                          {'image': '$base64Image'}
                        ]),
                      );
                      print(response.body);
                    }

                    postRequest();

                    if (!mounted) return;
                    //여기서 이제 await response해서 받고 그거에 해당하는 페이지로 넘기는 작업해야할듯 이거는 그냥 searchpage에서
                    //materialroute해도 될듯.
                    // If the picture was taken, display it on a new screen.
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image.path,
                        ),
                      ),
                    );
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
                icon: Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                iconSize: 100.0,
                padding: EdgeInsets.all(0.0),
                splashRadius: 45.0,
              ),

              // SizedBox(width: 120),
              IconButton(
                icon: flash,
                iconSize: 45,
                padding: EdgeInsets.all(0.0),
                splashRadius: 25.0,
                onPressed: () => setState(
                  () {
                    if (tapNumber == 0) {
                      _controller!.setFlashMode(FlashMode.always);
                      tapNumber = 1;
                      flash = Icon(
                        Icons.flash_off_outlined,
                      );
                      print("flashmode on");
                    } else {
                      _controller!.setFlashMode(FlashMode.off);
                      tapNumber = 0;
                      flash = Icon(
                        Icons.flash_on_outlined,
                      );
                      print("flashmode off");
                    }
                  },
                ),
                // onPressed: (){
                //   _controller.setFlashMode(FlashMode.always);
                //   // print('flashmode_is_on');
                // },
              ),
            ],
          ),
          // SizedBox(
          //   height: 90,
          // ),
        ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
