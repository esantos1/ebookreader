import 'dart:io';

import 'package:dio/dio.dart';

class DioHelper {
  final Dio _dio = Dio();

  Future<Response> get(String url) async {
    final response = await _dio.get(url);

    return response;
  }

  Future<void> download(String url, String path) async {
    final directory = Directory(path);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final List<String> urlParts = path.split('/');
    final String fileName = urlParts.last;
    path = '$path/$fileName';

    await _dio.download(
      url,
      path,
      onReceiveProgress: (count, total) {
        if (total != -1) {
          final progress = count / total;

          print('Progresso: $progress');
        }
      },
      deleteOnError: true,
    );
  }
}
