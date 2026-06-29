import '../../../core/api/api_client.dart';

class PassportRepository {
  final ApiClient apiClient;

  const PassportRepository({
    required this.apiClient,
  });

  Future<List<dynamic>> getVisits() async {
    final response = await apiClient.get('/visits/');
    return response.data as List<dynamic>;
  }
}