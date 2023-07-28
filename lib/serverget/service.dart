import 'package:http/http.dart' as http;
import 'package:whatmedi3/pages/takepicturescreen.dart';
import 'package:whatmedi3/serverget/info.dart';
import 'package:fluttertoast/fluttertoast.dart';

// String? id = TakePictureScreenState().uniqueId;
// String ur = 'http://52.78.227.27:8000/beombeom/';
// String url = ur + id!;
//
// class Services {
//   //static const url = 'asdf';
// //static으로 하는 이유에 대한 설명함 이게 더 좋은거 같은데 에러 뜨면 코솁 한번 확인
// //코딩셰프랑 다른게 코셉이 받은 uri의 json은 리스트안에 맵 형식의 json이 있어서 list 타입 나는 아니라서 그냥 이렇게 하면돼
//   static Future<List<Info>> getInfo() async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final List<Info> info = infoFromJson(response.body);
//         return info;
//       } else {
//         Fluttertoast.showToast(msg: '에러');
//         return <Info>[];
//         // list map 말고 그냥 map이면 약간 애매한 느낌이 들어서 일단 이렇게 함.
//         //이게 좀 그렇긴 해서
//         //제대로 할거면 {"Tyrenol":1}를
//         //[{"Tyrenol":1}] 이런 형식으로 바꿔야 하긴 할듯
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: '에러입니다');
//       return <Info>[];
//     }
//   }
// }
class Services {
  //String url = 'http://52.78.227.27:8000/beombeom/' + TakePictureScreenState().uniqueId!;
  //static const url = 'asdf';
//static으로 하는 이유에 대한 설명함 이게 더 좋은거 같은데 에러 뜨면 코솁 한번 확인
//코딩셰프랑 다른게 코셉이 받은 uri의 json은 리스트안에 맵 형식의 json이 있어서 list 타입 나는 아니라서 그냥 이렇게 하면돼
  static Future<List<Info>> getInfo() async {
    try {
      final response = await http.get(Uri.parse(
          'http://52.78.227.27:8000/beombeom/' +
              TakePictureScreenState().uniqueId!));
      //TakePictureScreenState().uniqueId!
      http: //52.78.227.27:8000/beombeom/1688970887591
      if (response.statusCode == 200) {
        final List<Info> info = infoFromJson(response.body);
        return info;
      } else {
        Fluttertoast.showToast(msg: '에러');
        return <Info>[];
        // list map 말고 그냥 map이면 약간 애매한 느낌이 들어서 일단 이렇게 함.
        //이게 좀 그렇긴 해서
        //제대로 할거면 {"Tyrenol":1}를
        //[{"Tyrenol":1}] 이런 형식으로 바꿔야 하긴 할듯
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return <Info>[];
    }
  }
}