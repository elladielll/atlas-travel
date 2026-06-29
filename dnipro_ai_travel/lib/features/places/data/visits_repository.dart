import '../../../core/api/api_client.dart';

class VisitResult {
  final bool alreadyVisited;
  final int totalVisits;

  const VisitResult({
    required this.alreadyVisited,
    required this.totalVisits,
  });

  factory VisitResult.fromJson(Map<String, dynamic> json) {
    return VisitResult(
      alreadyVisited: json['already_visited'] == true,
      totalVisits: json['total_visits'] ?? 0,
    );
  }
}

class VisitsRepository {
  final ApiClient apiClient;

  const VisitsRepository({
    required this.apiClient,
  });

  Future<VisitResult> createVisit({
    required String placeId,
  }) async {
    final response = await apiClient.post(
      '/visits/',
      body: {
        'place_id': placeId,
      },
    );

    return VisitResult.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}