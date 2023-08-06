import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:whatmedi3/pages/searchpage2.dart';
import 'package:whatmedi3/pages/searchpage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatmedi3/dataget/audio_player_provider.dart';

/*

      https://pub.dev/packages/in_app_review 이거 앱 안에서 리뷰 남길 수 있는거야

       */




class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

bool isTitle = true;
bool isCorp = true;
bool isIngredient = true;
bool isEffect = true;
bool isUsage = true;
bool isWarning = true;
bool isSwitched = true;
double speechRateInt = 1;
double pitchRateInt = 1;

// _loadData()와 _saveData()를 비동기 함수로 변경하고, await를 사용하여 데이터 로딩 및 저장을 처리합니다.
// initState()에서 _loadData()를 호출하여 초기 데이터를 로드합니다.
// SharedPreferences에서 값이 없는 경우에 대한 기본값을 설정하여 Null 방지합니다.
// UI 업데이트 시에만 필요한 부분을 리렌더링하도록 setState()를 적절히 사용합니다.
class _SettingPageState extends State<SettingPage> {
  //이걸로 읽기 속도 조절가능
  int musicStart = 0;
  Icon play = Icon(
    Icons.play_circle,
    color: whatmedicol.medipink,
    size: 50,
  );
  final player = AudioPlayer();
//스위치 디폴트 값
  TextEditingController editingController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }


  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool("isSwitched")!;
      isTitle = prefs.getBool("isTitle")!;
      isCorp = prefs.getBool("isCorp")!;
      isIngredient = prefs.getBool("isIngredient")!;
      isEffect = prefs.getBool("isEffect")!;
      isUsage = prefs.getBool("isUsage")!;
      speechRateInt = prefs.getDouble("speechRateInt")!;
      pitchRateInt = prefs.getDouble("pitchRateInt")!;
    });
  }

  Future<void> _savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isSwitched", isSwitched);
    await prefs.setBool("isTitle", isTitle);
    await prefs.setBool("isCorp", isCorp);
    await prefs.setBool("isIngredient", isIngredient);
    await prefs.setBool("isEffect", isEffect);
    await prefs.setBool("isUsage", isUsage);
    await prefs.setDouble("speechRateInt", speechRateInt);
    await prefs.setDouble("pitchRateInt", pitchRateInt);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whatmedicol.medipink,
      //appBar: AppBar(),
      body: SafeArea(
        child: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(children: [

              Card(
                color: Colors.white70,
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: Row(
                  children: [],
                ),
              ),
              Card(
                  color: Colors.white70,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                    title: SizedBox(
                      child: Text(
                        "음성 안내",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    subtitle: SizedBox(
                      child: Text(
                        "인식 결과를 터치 없이 음성으로 들을 수 있습니다.",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    trailing: SizedBox(
                      width: 70,
                      height: 80,
                      child: FlutterSwitch(
                        activeColor: Colors.white,
                        toggleColor: whatmedicol.medipink,
                        //위와 같은 스위치로 안하고 이런 스위치로 해도 가능한지 확인 필요.
                        value: isSwitched,
                        onToggle: (value) {
                          setState(() {
                            isSwitched = value;
                            _savebool();
                          });
                        },
                      ),
                      // FittedBox(
                      //   fit: BoxFit.fill,
                      //   child: FlutterSwitch(
                      //     //위와 같은 스위치로 안하고 이런 스위치로 해도 가능한지 확인 필요.
                      //     value: isSwitched,
                      //     onToggle: (value) {
                      //       setState(() {
                      //         isSwitched = value;
                      //         _savebool();
                      //       });
                      //     },
                      //   ),
                      // ),
                    ),
                  )),

              Card(
                color: Colors.white70,
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 1),

                child: Column(
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                        title: SizedBox(
                            child: Text(
                              "안내 속도",
                              style: TextStyle(fontSize: 25),)),
                        subtitle: SizedBox(
                            child: Text(
                              "하단에서, 약의 정보를 음성으로 안내받을 속도를 조정할 수 있습니다.",
                              style: TextStyle(fontSize: 20),)),
                    ),
                    SpinBox(
                      //이거는 갤럭시용 아이폰 용은 cupertinospinbox임 이거 사용한 pub dev에서 확인
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      // 세부적인거는 일단 나중에 해도 될듯
                      min: 1,
                      max: 5,
                      enabled: true, //이아래까지 기능으로 버튼으로만 속도 조절 가능.
                      readOnly: true,
                      value: speechRateInt, //기본 초기 설정값으로 나타남. nono 보이는 값
//                       onChanged: (value) {
//                         setState(() {
//                           //print(value);
//                           speechRateInt = value;
// //     //     ? (speechRateInt == 1 ? speechRateInt : speechRateInt / 2
//                           _savebool();
//                         });
//                       },
                    ),
                  ],
                ),

              ),
//
//               Card(
//                 color: Colors.white70,
//                 elevation: 0,
//                 margin: const EdgeInsets.symmetric(vertical: 1),
//                 child: SpinBox(
//                   //이거는 갤럭시용 아이폰 용은 cupertinospinbox임 이거 사용한 pub dev에서 확인
//                   decoration: InputDecoration(
//                       labelText: '음성안내 속도'), //세부적인거는 일단 나중에 해도 될듯
//                   min: 1,
//                   max: 5,
//                   enabled: true, //이아래까지 기능으로 버튼으로만 속도 조절 가능.
//                   readOnly: true,
//                   value: speechRateInt, //기본 초기 설정값으로 나타남. nono 보이는 값
//                   onChanged: (value) {
//                     setState(() {
//                       //print(value);
//                       speechRateInt = value;
// //     //     ? (speechRateInt == 1 ? speechRateInt : speechRateInt / 2
//                       _savebool();
//                     });
//                   },
//                 ),
//               ),

              Card(
              margin: const EdgeInsets.symmetric(vertical:1.0),
                color: Colors.white70,
                elevation: 0,
                child: Column(
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                      title: SizedBox(
                          child: Text(
                            "음성 안내",
                            style: TextStyle(fontSize: 25),)),
                      subtitle: SizedBox(
                          child: Text(
                              "하단에서, 약의 정보 중 음성으로 안내받을 항목을 선택할 수 있습니다.",
                            style: TextStyle(fontSize: 20),))
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            children: [
                              Text("약명"),
                              Checkbox(
                                value: isTitle,
                                onChanged: (value) {
                                  setState(() {
                                    isTitle = value!;
                                    _savebool();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            children: [
                              Text("제조사"),
                              Checkbox(
                                value: isCorp,
                                onChanged: (value) {
                                  setState(() {
                                    isCorp = value!;
                                    _savebool();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            children: [
                              Text("성분"),
                              Checkbox(
                                value: isIngredient,
                                onChanged: (value) {
                                  setState(() {
                                    isIngredient = value!;
                                    _savebool();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            children: [
                              Text("효능"),
                              Checkbox(
                                value: isEffect,
                                onChanged: (value) {
                                  setState(() {
                                    isEffect = value!;
                                    _savebool();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Column(
                            children: [
                              Text("복용"),
                              Checkbox(
                                value: isUsage,
                                onChanged: (value) {
                                  setState(() {
                                    isUsage = value!;
                                    _savebool();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                  color: Colors.white70,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                      title: SizedBox(
                        child: Text(
                          "앱 안내 듣기",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      subtitle: SizedBox(
                        child: Text(
                          "앱 사용 방법을 음성으로 들을 수 있습니다.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      trailing: IconButton(
                        icon: play,
                        color: whatmedicol.medipink,
                        iconSize: 50,
                        padding: EdgeInsets.all(0.0),
                        splashRadius: 25.0,
                        onPressed: () => setState(
                          () {
                            if (musicStart == 0) {
                              player.play(
                                AssetSource('guide.m4a'),
                              );
                              musicStart = 1;
                              play = Icon(
                                Icons.stop_circle,
                              );
                            } else {
                              player.stop();
                              musicStart = 0;
                              play = Icon(
                                Icons.play_circle,
                              );
                            }
                          },
                        ),
                      ))),
              // Card(
              //     color: Colors.white70,
              //     elevation: 0,
              //     margin: const EdgeInsets.symmetric(vertical: 1),
              //     child: SingleChildScrollView(
              //       child: ListTile(
              //           contentPadding: EdgeInsets.fromLTRB(20, 10, 30, 10),
              //           title: SizedBox(
              //             child: Text(
              //               "의견 제출",
              //               style: TextStyle(fontSize: 25),
              //             ),
              //           ),
              //           subtitle: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "앱 사용에 문의사항이나 불편함이 있으시면 아래 상자에 의견을 작성하시고 하단에 위치한 전송 버튼을 눌러주세요.",
              //                 style: TextStyle(fontSize: 20),
              //               ),
              //               SizedBox(height: 20),
              //               SizedBox(
              //                 child: TextField(
              //                     controller: editingController,
              //                     minLines: 1,
              //                     maxLines: 10,
              //                     keyboardType: TextInputType.multiline,
              //                     decoration: InputDecoration(
              //                       hintText: "의견 사항이 있으시다면 ...",
              //                       border: OutlineInputBorder(),
              //                     )),
              //               ),
              //               Center(
              //                 child: ElevatedButton(
              //                   onPressed: () {
              //                     print(editingController.text);
              //                   },
              //                   child: Text("전송"),
              //                 ),
              //               )
              //             ],
              //           )),
              //     )),
            ]),
          );
        }),
      ),
    );
  }
}
