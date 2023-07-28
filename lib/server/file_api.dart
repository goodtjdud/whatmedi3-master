import 'dart:typed_data';
import 'package:dio/dio.dart';

/*
http://52.78.227.27:8000/image_upload/%EC%97%90
 */
//이미지파일을 전송하는 코드라 생각하면 됨.

class FileApi {
  final _dio = Dio();

  Future<Response> uploadImage(Uint8List image, String userId) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(image.buffer.asUint8List(),
          filename: 'group10.png'),
      'user_id': userId,
    });
    final response = await _dio.post(
      'http://52.78.227.27:8000/image_upload/',
      data: formData,
    );
    return response;
  }
}
// class FileApi {
//   final _dio = Dio();
//   Future<Response> uploadImage(
//     Uint8List image,
//   ) async {
//     final formData = FormData.fromMap({
//       'image': MultipartFile.fromBytes(image.buffer.asUint8List(),
//           filename: 'group10.png'),
//       //'user_id': MultipartFile.fromString('23'),
//     });
//     final response = await _dio.post(
//       //응답객체
//       'http://52.78.227.27:8000/image_upload/', //여기로 쏘는거임.
//       data: formData,
//     );
//     return response;
//   }
// }
