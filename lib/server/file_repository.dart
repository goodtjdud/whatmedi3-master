import 'dart:io';
import 'dart:typed_data';
import 'package:whatmedi3/server/file_api.dart';

class FileRepository {
  final _fileApi = FileApi();
  Future<bool> uploadImage(Uint8List image, String userId) async {
    try {
      await _fileApi.uploadImage(image, userId);
      return true; //성공 실패유무 알려주는거
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
// class FileRepository {
//   final _fileApi = FileApi();
//   Future<bool> uploadImage(Uint8List image) async {
//     try {
//       await _fileApi.uploadImage(image);
//       return true; //성공 실패유무 알려주는거
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }
// }
