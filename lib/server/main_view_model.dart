import 'dart:typed_data';
import 'package:whatmedi3/server/file_repository.dart';
import 'package:dio/dio.dart';

// class MainViewModel {
//   final _repository = FileRepository();
//   var isLoading = false; //로딩처리 처음에는 false 성공하면 true로 되게 setstate해줘야지 나중에
//   Future uploadImage(Uint8List image) async {
//     await _repository.uploadImage(image);
//   }
// }

class MainViewModel {
  final _repository = FileRepository();
  var isLoading = false;
  Future uploadImage(Uint8List image, String userId) async {
    await _repository.uploadImage(image, userId);
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