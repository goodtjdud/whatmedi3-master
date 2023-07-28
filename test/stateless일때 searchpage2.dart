// class SearchedPage extends StatelessWidget with WidgetsBindingObserver {
//   SearchedPage({Key? key, required this.mediinfo})
//       : super(key: key); //const였는데 tts때문에 뺌
//   final Map mediinfo;
//
//   FlutterTts flutterTts = FlutterTts();
//
//   final speech = TtsService();
//   final FlutterTts tts = FlutterTts();
//   //FlutterTtsPlugin ttts = FlutterTtsPlugin();
//   Future set() async {
//     tts.setLanguage('ko-KR');
//     //한국어(대한민국)	표준	ko-KR	             ko-KR-Standard-A	여성//voice도 가져와야겠다.
//     // await tts.setSpeechRate(Platform.isAndroid
//     //     ? (speechRateInt == 1 ? speechRateInt : speechRateInt / 2)
//     //     : speechRateInt);
//     await tts.setSpeechRate(speechRateInt);
//   }
//
//   String pummok = '';
//   String upche = '';
//   String sungbun = '';
//   String hyoneung = '';
//   String youngbup = '';
//   choice() {
//     if (isTitle == true) {
//       pummok = ',,,품목명: ${mediinfo["title"]}';
//     } else {
//       pummok = '';
//     }
//     if (isCorp == true) {
//       upche = ',,,업체명: ${mediinfo["corp"]}';
//     } else {
//       upche = '';
//     }
//     if (isIngredient == true) {
//       sungbun = ',,,성분: ${mediinfo["ingredient"]}';
//     } else {
//       sungbun = '';
//     }
//     if (isEffect == true) {
//       hyoneung = ',,,효능효과: ${mediinfo["effect"]}';
//     } else {
//       hyoneung = '';
//     }
//     if (isUsage == true) {
//       youngbup = ',,,용법용량: ${mediinfo["usage"]}';
//     } else {
//       youngbup = '';
//     }
//   }
//
//   Future play() async {
//     await tts.speak(pummok + upche + sungbun + hyoneung + youngbup);
//   }
//
//   Future play2() async {
//     await speech.speak(pummok + upche + sungbun + hyoneung + youngbup);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     TtsService();
//     set();
//     choice();
//
//     if (isSwitched == true) {
//       Future<void>.delayed(const Duration(milliseconds: 100));
//       play();
//     } else {
//       () {};
//     }
//
//     return Scaffold(
//       backgroundColor: whatmedicol.medipink,
//       appBar: AppBar(
//         //확인해보기
//         /*
//         앱바를 없애고 핸드폰에 빌드하였을때 뒤로가기를 어떻게 하는지 일단 알아보기
//          */
//         elevation: 0,
//         title: Text(mediinfo["title"]),
//       ),
//       body: Builder(builder: (context) {
//         return GestureDetector(
//             // 지금은 아래에 있는 텍스트 위젯을 클릭하면 스탑이 되니까 앱바랑 그냥 핸드폰 화면 전체에 대한 것으로 바꿔야 함.
//             //이니셜라이즈 하는것 생각 해줘야 뭐가 될듯
//             onTap: () {
//               //ttts._stop(); //모르겠다 증말로
//               //tts.stop();
//               set();
//             },
//             //padding 대신에 safearea로 하고
//             //padding: const EdgeInsets.all(10.0),
//             child: SafeArea(
//                 child: Padding(
//                     padding: EdgeInsets.all(20.0),
//                     child: Center(
//                         child: ClipRRect(
//                             borderRadius: BorderRadius.circular(20.0),
//                             child: Container(
//                               height: 400,
//                               width: 300,
//                               decoration: BoxDecoration(
//                                   /*
//                                 https://www.geeksforgeeks.org/gradient-in-flutter-applications/
//                                 gradient 사이트
//                                  */
//                                   gradient: RadialGradient(colors: [
//                                 whatmedicol.medigreen,
//                                 whatmedicol.medigreenwhite
//                               ])),
//                               //color: whatmedicol.medigreen,
//                               child: Column(
//                                   mainAxisAlignment: MainAxisAlignment
//                                       .center, //화면 중앙에 가져다 놓은 것
//                                   crossAxisAlignment: CrossAxisAlignment
//                                       .start, //중앙하나 큰 컨테이너 같은 위젯 안에 위젯들 넣으면 앞에서부터 시작
//                                   children: [
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text("품목명: ${mediinfo["title"]}",
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             fontFamily: 'SCDream4')),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text("업체명: ${mediinfo["corp"]}",
//                                         style: TextStyle(fontSize: 20)),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text("성분: ${mediinfo["ingredient"]}",
//                                         style: TextStyle(fontSize: 20)),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text("효능, 효과: ${mediinfo["effect"]}",
//                                         style: TextStyle(fontSize: 20)),
//                                     SizedBox(
//                                       height: 20,
//                                     ),
//                                     Text("용법, 용량: ${mediinfo["usage"]}",
//                                         style: TextStyle(fontSize: 20)),
//                                   ]),
//                             ))))));
//       }),
//     );
//   }
// }
