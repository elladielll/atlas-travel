import 'package:dio/dio.dart';

class HttpClient {
  late final Dio dio;

  HttpClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'User-Agent': 'Atlas Travel App',
          'Accept': 'application/json',
        },
      ),
    );
  }
}