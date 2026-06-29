import 'package:dio/dio.dart';

import '../services/network/http_client.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'api_routes.dart';

class ApiClient {
  final HttpClient httpClient;

  ApiClient({
    required this.httpClient,
  });

  Future<ApiResponse<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await httpClient.dio.get(
        '${ApiRoutes.baseUrl}$endpoint',
        queryParameters: queryParameters,
      );

      return ApiResponse(
        data: response.data,
      );
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<dynamic>> post(
    String endpoint, {
    dynamic body,
  }) async {
    try {
      final response = await httpClient.dio.post(
        '${ApiRoutes.baseUrl}$endpoint',
        data: body,
      );

      return ApiResponse(
        data: response.data,
      );
    } on DioException catch (e) {
      throw ApiException(
        e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}