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