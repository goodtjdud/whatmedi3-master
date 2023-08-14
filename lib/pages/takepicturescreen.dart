import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatmedi3/pages/searchpage.dart';
import 'package:whatmedi3/pages/searchpage2.dart';
import 'package:whatmedi3/server/main_view_model.dart';
import 'package:uuid/uuid.dart';
import 'package:whatmedi3/serverget/info.dart';
import 'package:whatmedi3/serverget/service.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
  });
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool flashOn = true;
  bool active = true;
  bool _flashOn = false;

  //final String deviceid = Uuid().v4();

  ///서버 통신 용 코드
  List<Info> _info = <Info>[];
  bool pictosearchloading = true;
  bool checkvalue = false;
  bool loading = false;

  ///
  List<Map<String, dynamic>> servermedidata = [];
  Future<void> fetchDataFromServer2() async {
    //String url = ; // 서버의 엔드포인트 URL을 입력하세요.
    try {
      final response = await http
          .get(Uri.parse('http://52.78.227.27:8000/result/' + uniqueId!));
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        var encodedString = utf8.decode(bytes); // UTF-8로 수동 디코딩
        var jsonData = json.decode(encodedString);
        // _foundUsers = List<Map<String, dynamic>>.from(jsonData);
        servermedidata = List<Map<String, dynamic>>.from(jsonData);
        Fluttertoast.showToast(msg: '데이터를 성공적으로 받았습니다.');
      } else {
        Fluttertoast.showToast(
            msg: '데이터를 받는데 실패했습니다. 상태 코드: ${response.statusCode}');
        print('데이터를 받는데 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '데이터를 받는 도중 오류가 발생했습니다: $error');
    }}

  ///유저 id 주는 용도
  final String uniqueIdKey = 'uniqueId';
  String? uniqueId;

  Future<void> getUniqueId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedId = prefs.getString(uniqueIdKey);

    if (storedId == null) {
      // 처음 실행 시 고유한 ID 생성
      uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

      // 생성한 ID를 저장
      await prefs.setString(uniqueIdKey, uniqueId!);
    } else {
      uniqueId = storedId;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // To display the current output from the Camera,// create a CameraController.
    _initCamera();
    getUniqueId();
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
      print("Resumed");
      _initCamera();
    } else if (state == AppLifecycleState.paused) {
      print("Paused");
      _controller?.pausePreview();
    }
  }

  _initCamera() {
    Future.delayed(Duration(milliseconds: 0)).then((value) {
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
      CameraController(value[0], ResolutionPreset.high);
      cameraController.addListener(() {});
      _controller = cameraController;

      await _controller?.initialize();
      if (!mounted) {
        return;
      }
      _controller?.setFlashMode(FlashMode.auto);
      setState(() {});
    } catch (e) {
      setState(() {
        active = false;
      });
      print("Failed to create camera with $e");
      // final Size screenSize = MediaQuery.of(context).size;
      // final double screenAspectRatio = screenSize.width / screenSize.height;
      //
      // final List<Size> availablePreviewSizes = _controller?.value.previewSizes;
      // Size selectedSize;
    }
  }

  /// 여기까지가 앱사이클 관련된 코딩이라고 생각하면 돼
  // double diff = double.infinity;
  // for (var size in availablePreviewSizes) {
  //   final double aspectRatio = size.width / size.height;
  //   final double currentDiff = (aspectRatio - screenAspectRatio).abs();
  //   if (currentDiff < diff) {
  //     diff = currentDiff;
  //     selectedSize = size;
  // }
  //   }


  int tapNumber = 0;
  Icon flash = Icon(
    Icons.flash_on_outlined,
    color: Colors.black,
    size: 40,
  );

  ///서버에 사진보낼때 생각
  final viewModel = MainViewModel();

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
      _controller?.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  ///
  @override

  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = (screenWidth * 1280) / 720;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized && pictosearchloading)
            Center(
                child: AspectRatio(
                    aspectRatio: screenWidth / screenHeight,
                    child: CameraPreview(_controller!)
                )
            ),
          // 카메라 초기화가 완료된 경우에만 표시
          if (_controller == null || !_controller!.value.isInitialized)
            const Center(
                child:
                CircularProgressIndicator()), // 카메라 초기화 중이거나 실패한 경우 로딩 표시

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: getFloatingButtons(),
          ),


        ],
      ),

    );

//   (
    //   body: FutureBuilder<void>(
    //     future: _controller?.initialize(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         // If the Future is complete, display the preview.
    //         return CameraPreview(_controller!);
    //       } else {
    //         print("connection not done");
    //         // Otherwise, display a loading indicator.
    //         return const Center(child: Text('asdf'));
    //       }
    //     },
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   floatingActionButton: getFloatingButtons(),
    // );
  }

  Widget getFloatingButtons() {
    ///결과값 가져오는 서버 관련.
    // Info info = _info[0]; //일단 info의 0이어야함.
    // String test = info.tyrenol;
    //[{"tyrenol":"1"}]->이게 서버에 저장되어 있는거 즉 test에 "1"이 저장됨.
    //일단 그냥 [{"tyrenol":1}]로 해서 int로 하고 이걸로 그냥 약순서대로 해서 페이지 넘기는 방법 존재.
    //Map data = _data as Map;
    //Data data =_data[0:1];
    ///
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //그냥 잘 되는지 확인하려고 만드는것 .
              // if (viewModel.isLoading) CircularProgressIndicator(),
              IconButton(
                onPressed: () async {
                  try {
                    // Ensure that the camera is initialized.
                    await _controller?.initialize();
                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await _controller!.takePicture();
                    if (!mounted) return;
                    setState(() {
                      viewModel.isLoading = true;
                    });
                    final bytes = await image
                        .readAsBytes(); //카메라에서 캡쳐한 이미지를 받아오는 bytes로 변환 후
                    await viewModel.uploadImage(
                        bytes.buffer.asUint8List(), uniqueId!); //잘됨.deviceid로 보내줌.
                    //위의 코드로 서버에 카메라 이미지 전달해줌.
                    setState(() {
                      viewModel.isLoading = false;
                    });

                    await Future.delayed(Duration(milliseconds: 1));
                    fetchDataFromServer2();
                  } catch (e) {
                    print(e);
                  }

                  // 여기까지가 현재 서버에 이미지 보내는 과정.
                  // try {
                  //   //fetchDataFromServer();
                  // } catch (e) {
                  //   print(e);
                  // }

                  // 그다음은 약 데이터 서버에서 가져오는과정
                  // 그 후 결과값을 서버에서 결과 값을 가져오는과정
                  // 총 3가지 try catch구문 사용해야함.
                  // try {
                  //   Services.getInfo().then((value) {
                  //     ///서버로부터 데이터받아오기 위한 initstate 코드 이제 이거를 takepicture에 옮기면 됨.
                  //     setState(() {
                  //       _info = value; //setstate 메서드 내에서는 info에 value값을 전달해줌
                  //       loading = true;
                  //     });
                  //   });
                  //   saveinformation = _foundUsers[1];
                  //   print(test);
                  //   if (test == '1') {
                  //     //지금은 tyrenol에 1(string으로)을 넣었으니까 그런것.
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => SearchedPage(
                  //               mediinfo: saveinformation,
                  //             )));
                  //   } else {} //이렇게 하니까 됨.
                  // } catch (e) {
                  //   print(e);
                  // }

                  try {
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      //pictosearchloading = true;
                      checkvalue = true;
                      fetchDataFromServer2();
                    });

                    Map<String, String> medidata = {
                      "title": servermedidata[0]['title'],
                      "corp": servermedidata[0]['corp'],
                      "ingredient": servermedidata[0]['ingredient'],
                      "effect": servermedidata[0]['effect'],
                      "usage": servermedidata[0]['usage']
                    };

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SearchedPage(
                          mediinfo: medidata,
                        )));
                    setState(() {
                      pictosearchloading = true;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Semantics(
                  excludeSemantics: true,
                  child: Icon(
                    Icons.radio_button_on,
                    color: Colors.white,
                    semanticLabel: '촬영 버튼',
                  ),
                ),
                iconSize: 100.0,
                padding: EdgeInsets.all(0.0),
                splashRadius: 45.0,
              ),

              // SizedBox(width: 120),
              //   IconButton(
              //   icon : flashOn ? Icon(Icons.flash_off, color: Colors.white) : Icon(Icons.flash_on, color: Colors.white),
              //   iconSize: 45,
              //   padding: EdgeInsets.all(0.0),
              //   splashRadius: 25.0,
              //   onPressed: () {
              //     setState(() {
              //       if (flashOn) {
              //         _controller!.setFlashMode(FlashMode.off);
              //         }
              //       else {
              //         _controller!.setFlashMode(FlashMode.always);
              //      }
              //       flashOn =! flashOn;
              //   });
              //   },
              //   ),
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