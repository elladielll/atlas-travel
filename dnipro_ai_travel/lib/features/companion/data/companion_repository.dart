import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_response.dart';
import '../domain/chat_message.dart';
import '../domain/companion_dashboard.dart';
import 'models/chat_response.dart';

class CompanionRepository {
  final ApiClient apiClient;

  const CompanionRepository({
    required this.apiClient,
  });

  Future<CompanionDashboard> getDashboard() async {
    final response = await apiClient.get('/companion/');

    return CompanionDashboard.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<List<ChatMessage>> chat(String message) async {
    final sessionId = await _getSessionId();

    final ApiResponse response = await apiClient.post(
      '/companion/chat',
      body: {
        'message': message,
        'session_id': sessionId,
      },
    );

    final result = ChatResponse.fromJson(
      Map<String, dynamic>.from(response.data),
    );

    return result.messages;
  }

  Future<void> clearChat() async {
    final sessionId = await _getSessionId();

    await apiClient.post(
      '/companion/chat/clear',
      body: {
        'session_id': sessionId,
      },
    );
  }

  Future<String> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getString('atlas_session_id');

    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final sessionId = 'atlas_${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setString('atlas_session_id', sessionId);

    return sessionId;
  }
}