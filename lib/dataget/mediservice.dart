import 'package:whatmedi3/dataget/data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class MediServices {
  static const String url = 'http://52.78.227.27:8000/beombeom3';
//static으로 하는 이유에 대한 설명함 이게 더 좋은거 같은데 에러 뜨면 코솁 한번 확인
//코딩셰프랑 다른게 코셉이 받은 uri의 json은 리스트안에 맵 형식의 json이 있어서 list 타입 나는 아니라서 그냥 이렇게 하면돼
  static Future<List<Data>> getInfo() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<Data> data = dataFromJson(response.body);
        return data;
      } else {
        Fluttertoast.showToast(msg: '에러');
        return <Data>[];
        // list map 말고 그냥 map이면 약간 애매한 느낌이 들어서 일단 이렇게 함.
        //이게 좀 그렇긴 해서
        //제대로 할거면 {"Tyrenol":1}를
        //[{"Tyrenol":1}] 이런 형식으로 바꿔야 하긴 할듯
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '에러입니다');
      return <Data>[];
    }
  }
}
