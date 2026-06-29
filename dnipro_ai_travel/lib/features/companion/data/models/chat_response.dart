import '../../domain/chat_message.dart';

class ChatResponse {
  final List<ChatMessage> messages;

  const ChatResponse({
    required this.messages,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      messages: (json["messages"] as List)
          .map((e) => ChatMessage.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
    );
  }
}