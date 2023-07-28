import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_upload_guide/main_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewModel = MainViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            viewModel.isLoading
                ? const CircularProgressIndicator()
                : Container(),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  viewModel.isLoading = true;
                });

                final bytes = await rootBundle.load('assets/group10.png');
                await viewModel.uploadImage(bytes.buffer.asUint8List());

                setState(() {
                  viewModel.isLoading = false;
                });
              },
              child: const Text('업로드 파일'),
            ),
          ],
        ),
      ),
    );
  }
}
