import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:whatmedi3/pages/searchpage2.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:whatmedi3/pages/settingpage.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatmedi3/backdata/medicinedata.dart';
import 'package:whatmedi3/serverget/info.dart';
import 'package:whatmedi3/serverget/service.dart';
import 'package:whatmedi3/dataget/mediservice.dart';
import 'package:whatmedi3/dataget/data.dart';
import 'package:whatmedi3/pages/takepicturescreen.dart';
import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatmedi3/dataget/audio_player_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();
  final FlutterTts tts = FlutterTts();
  bool isDescending = true; //가나다 다나가 변형할때 사용하는 부울변수

  ///서버 통신 용 코드
  List<Info> _info = <Info>[];
  bool loading = false; //사용자에게 로딩여부를 알려주기 위해서 불리안 사용
  ///
  ///약 데이터 서버 통신용 코드
  //List<Data> _data = <Data>[];

  ///
  bool fetchserverloading = true;
  Future<void> fetchDataFromServer() async {
    const String url =
        'http://52.78.227.27:8000/beombeom3'; // 서버의 엔드포인트 URL을 입력하세요.
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        var encodedString = utf8.decode(bytes); // UTF-8로 수동 디코딩
        var jsonData = json.decode(encodedString);
        _foundUsers = List<Map<String, dynamic>>.from(jsonData);
        medidata = List<Map<String, dynamic>>.from(jsonData);
        fetchserverloading =
        false; //즉 loading이 완료됨을 알려주는것 이걸로 circularindicator()해주기
        Fluttertoast.showToast(msg: '데이터를 성공적으로 받았습니다.');
      } else {
        Fluttertoast.showToast(
            msg: '데이터를 받는데 실패했습니다. 상태 코드: ${response.statusCode}');
        print('데이터를 받는데 실패했습니다. 상태 코드: ${response.statusCode}');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '데이터를 받는 도중 오류가 발생했습니다: $error');
    }
  }

  set() {
    tts.setLanguage('ko-KR');
    //tts.setSpeechRate(1);
    //1이 최대인데 생각보다 너무 느림
  }

  //final medidata = MedicineData(); //약 data 있는곳에서 가져오는 방식
  //medicinedata.dart에서 가져온 데이터
  List<Map<String, dynamic>> _foundUsers = [];
  List<Map<String, dynamic>> medidata = [];
  List<Map<String, dynamic>> sortedfoundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _loadData();
    // _foundUsers =
    //     medidata.data; //medicineData의 객체인 medidata의 data를 _foundUsers에다가 넣어준것
    super.initState();
    //medicine = fetchDataFromServer();
    // Services.getInfo().then((value) {
    //   ///서버로부터 데이터받아오기 위한 initstate 코드 이제 이거를 takepicture에 옮기면 됨.
    //   setState(() {
    //     _info = value; //setstate 메서드 내에서는 info에 value값을 전달해줌
    //     loading = true;
    //   });
    // });
    fetchDataFromServer();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool("isSwitched")!;
      isTitle = prefs.getBool("isTitle")!;
      isCorp = prefs.getBool("isCorp")!;
      isIngredient = prefs.getBool("isIngredient")!;
      isEffect = prefs.getBool("isEffect")!;
      isUsage = prefs.getBool("isUsage")!;
      isWarning = prefs.getBool("isWarning")!;
      speechRateInt = prefs.getDouble("speechRateInt")!;
      isDescending = prefs.getBool("isDescending")!;
    });
  }

//int a=0;
  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results =
          medidata; //이거 그냥 medidata라는거 안해주고 그냥 _foundUsers로 해줘도 되는건지 확인해봐야하긴 함.
      //무조건 따로 만들어줘야함 _foundUsers로 하면 안됨.
    } else {
      results = medidata
          .where((user) => user["title"]
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();

      ///
      ///약명을 지을때 띄어쓰기 하면 띄어쓰기도 인식하긴
      ///해 완전 안전하게 할거면 "_타이레놀정_500_밀리그램"이런식으로 하면 스페이스바 섞여도 그나마 더 안전.
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tts.stop();
    super.dispose();
  } //일단 넣어본것

  @override
  Widget build(BuildContext context) {
    @override
    _savebool() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isDescending", isDescending);
      //다른 스위치도 이렇게 저장하면 됌.
    }
    //sortedfoundUsers= _foundUsers..sort((item1, item2)=> item2.compareTo(item1));

    ///서버 관련.
    //Info info = _info[0]; //일단 info의 0이어야함.
    //String test = info.tyrenol;
    //[{"tyrenol":"1"}]->이게 서버에 저장되어 있는거 즉 test에 "1"이 저장됨.
    //일단 그냥 [{"tyrenol":1}]로 해서 int로 하고 이걸로 그냥 약순서대로 해서 페이지 넘기는 방법 존재.
    //Map data = _data as Map;
    //Data data =_data[0:1];
    ///

    set();
    //tts.stop(); //이 페이지로 오면 음성이 멈추도록 //stop은 아예 끊기고 pause는 중단되었다가 다른 페이지 들어가도 처음들어갔던 페이지의 언어 그대로 나옴
    //List<bool> _isFavorited =
    //List<bool>.generate(_foundUsers.length, (_) => false);
    return Scaffold(
        appBar: AppBar(
          //title: Text(loading ? 'Info' : 'Loading...'),
          //그냥 앱바 말고 컨테이너로 쌓아줘도 상관없긴 할듯
          //앱바 크기 줄여야하니까 하이트
          leading: IconButton(
            ///이걸로 지금 나중 카메라 찍고 페이지 루트 실험용 버튼
            icon: Icon(Icons
                .account_circle_rounded), //Icons.account_circle_rounded,Icons.add
            onPressed: () {
              //Fluttertoast.showToast(msg: url);
              //print(medicine);
              // saveinformation = _foundUsers[1];
              // //print(saveinformation); //잘됨. 그럼 이
              // //saveinformation의 값들을 가져오거나 우선적으로
              // //SearchedPage(mediinfo: saveinformation,);
              // //이 위에 것처럼 하면 될듯 잘 넘어갈 것 같습니다.
              // print(test);
              // if (test == '1') {
              //   //지금은 tyrenol에 1(string으로)을 넣었으니까 그런것.
              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => SearchedPage(
              //             mediinfo: saveinformation,
              //           )));
              // } else {} //이렇게 하니까 됨.
            }, //잘 됨.
            color: whatmedicol.medipink,
          ),

          elevation: 0,
          centerTitle: true,
          //title: Text('무엇이약 로고 넣기'),
          backgroundColor: whatmedicol.medigreen,

          // leading: Center(
          //   child: Text('Cranes'),
          // ),
          // title: Image.asset("assets/images/whatmedi2.png",
          //     fit: BoxFit.contain,
          //     height: AppBar().preferredSize.height, //어느 핸드폰이든 보일 수 있도록.
          //     width: AppBar().preferredSize.height),
          // title: Image.asset(
          //   "images/whatmedi2.png",
          //   fit: BoxFit.contain,
          //   height: AppBar().preferredSize.height - 5, //어느 핸드폰이든 보일 수 있도록.
          //   width: AppBar().preferredSize.height - 5,
          // ),
        ),
        backgroundColor: whatmedicol.medipink, //이걸로 뒤에 배경색

        body: RefreshIndicator(
            onRefresh: fetchDataFromServer,
            child: SafeArea(
              child: Builder(builder: (context) {
                sortedfoundUsers = isDescending
                    ? _foundUsers
                    : _foundUsers.reversed.toList(); //이걸로 위아래 조절 가능
                //sortedfoundUsers =_foundUsers..sort((item1['약명'], item2['약명'])=>item1['약명'].compareTo(item2['약명']));
                return GestureDetector(
                  //화면 아무곳이나 터치하면 그냥키보드 내려가도록 추가 기능은 함
                  //safearea빼고 하니까 됨
                  //애매하긴 하다. 작동은 되는데 이게 터치하면 어차피 페이지 이동해서
                  //찾는 약품이 없거나 혹은 약품들이 수가 줄어들면 사용됨.
                  //처음 화면에서 검색만 하려고 했을때는 빈 공간이 거의 없긴 함.
                  // 보이스 어시스턴트 기능 킨 채로도 한번 탭 혹은 두번의 탭으로 내려가는지 확인하기.
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Container(
                        color: whatmedicol.medigreen,
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: TextField(
                            cursorColor: whatmedicol
                                .medipink, //이거는 그냥 검색창 누르면 깜빡깜빡 거리는 거 색상
                            onChanged: (value) => _runFilter(value),
                            controller: editingController,

                            decoration: InputDecoration(
                                fillColor: whatmedicol.medipink,
                                filled: true, //원래는 false가 디폴트
                                focusColor: whatmedicol.medigreen,
                                hoverColor: whatmedicol.medigreenwhite,
                                //icon: Icon(Icons.search),
                                //iconColor: whatmedicol.medigreen,
                                labelText: "검색(띄어쓰기 금지)",
                                labelStyle: TextStyle(
                                    fontSize: 18, color: whatmedicol.medigreen),
                                hintText: "찾고자 하는 약을 입력하세요(띄어쓰기 금지)",
                                hintStyle: TextStyle(
                                    fontSize: 18, color: whatmedicol.medigreen),
                                //hintStyle: ,

                                prefixIcon: Icon(
                                  Icons.search,
                                  color: whatmedicol.medigreen,
                                ),
                                //prefixIconColor: whatmedicol.medipink,
                                border: OutlineInputBorder(
                                  //gapPadding: 4.0,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      // child: Row(
                      //   children: [
                      //     Icon(Icons.arrow_drop_down_outlined),
                      //     Text('ㄱ-ㅎ')
                      //   ],
                      // ),
                      height: 36,
                      child: Align(
                        alignment: Alignment(-1, 0),
                        child: TextButton.icon(
                          icon: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.compare_arrows,
                              size: 20,
                              color: whatmedicol.medigreen,
                            ),
                          ),
                          label: Text(
                            isDescending ? '가나다순' : '다나가순',
                            style: TextStyle(
                                fontSize: 16,
                                color: whatmedicol.medigreen,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () => setState(() {
                            isDescending = !isDescending;
                            print(isDescending);
                            _savebool(); //이거는 settingpage에 있는 _savebool아니라 또 isDescending이라는 서치페이지에 있는
                            //부울 값을 저장하기 위한 _savebool() 을 만들어준것 위에 보면 build밑에 오버라이드 해서 _savebool()했음.
                          }),
                        ),
                      ),
                    ),
                    fetchserverloading
                        ? Expanded(
                      //fit: FlexFit.tight,
                        child: Center(
                            child: Column(children: [
                              CircularProgressIndicator(
                                color: whatmedicol.medigreen,
                              ),
                              Text('화면을 눌러주세요')
                            ])))
                        : Expanded(
                      /*
            https://api.flutter.dev/flutter/material/ListTile-class.html
            리스트타일 관련 api 홈페이지/
            expansionlisttile로 그냥 한페이지에서 모든 약의 정보를 보여주는 것도 생각해보면 좋을듯
            물론 그냥 페이지 넘기는게 더 나을 거 같기는 함.
  */

                      child: sortedfoundUsers.isNotEmpty
                          ? ListView.builder(
                        addAutomaticKeepAlives: false,

                        //이게 off-screen 일때도 state preserve 시켜주는 거 같아서 했는데 아예 앱 밖으로 나갔을때
                        //오디오가 재생이 안되는 용도로 되는지 확인해봐야함.
                        //따라서 생각으로는 false를 해서 앱 밖으로 나가면 state 유지 안되도록 해서 재생이 안되도록 하고 싶은데 가능할지 모르겠음.

                        shrinkWrap: true,
                        scrollDirection: Axis
                            .vertical, //vertical : 수직으로 나열 / horizontal : 수평으로 나열
                        itemCount:
                        sortedfoundUsers.length, //리스트의 개수
                        itemBuilder:
                            (BuildContext context, int index) =>
                            Card(
                              elevation: 10.0,
                              margin: new EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6.0),
                              shadowColor: whatmedicol
                                  .medipink, //이거 되는건줄 알았는데 안됨. 타일 뒤에 흰색들 배경색 어떻게 하는지 모름 아직

                              key: ValueKey(
                                  sortedfoundUsers[index]["title"]),
                              color: whatmedicol.medigreen,
                              // elevation: 0,
                              // margin: const EdgeInsets.symmetric(vertical: 2),
                              //리스트의 반목문 항목 형성
                              child: ListTile(
                                //leading: ,
                                // shape: Border.all(
                                //     width: 5, style: BorderStyle.none),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10,
                                      10,
                                      10,
                                      10), //타일내 텍스트와 타일 사이 거리
                                  title: SizedBox(
                                      child: Text(
                                        sortedfoundUsers[index]["title"]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: whatmedicol.medipink),
                                      )),
                                  subtitle: SizedBox(
                                    child: Text(
                                      sortedfoundUsers[index]["corp"]
                                          .toString(),
                                      style: TextStyle(
                                        color: whatmedicol.medipink,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                  trailing: Container(
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: whatmedicol.medipink,
                                    ),
                                  ),
                                  //그냥 icon으로 해도 되는데 혹시 모르니까 나중에 더 추가하고 싶으면 컨테이너로
                                  //이거는 favorite를 만들어줄때 생각하는 용도
                                  // trailing: IconButton(
                                  //   icon: _isFavorited[index]
                                  //       ? Icon(Icons.star)
                                  //       : Icon(Icons.star_border),
                                  //   onPressed: () => setState(() =>
                                  //       _isFavorited[index] =
                                  //           !_isFavorited[index]),
                                  // ),

                                  onTap: () {
                                    // MethodChannel('flutter/accessibility')
                                    //     .invokeMethod<void>('decreaseAccessibility');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchedPage(
                                                  mediinfo:
                                                  sortedfoundUsers[
                                                  index],
                                                )));
                                    print(index);
                                  }),
                            ),
                      )
                          : const Text(
                        '찾으시는 약품이 없습니다',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                  ]),
                ); //기존의 세이프 에리아 부분
              }),
            ))

      ///

    ); //
  }
}