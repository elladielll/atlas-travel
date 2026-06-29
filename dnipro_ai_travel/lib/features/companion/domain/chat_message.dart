enum ChatRole {
  user,
  assistant,
}

class ChatMessage {
  final ChatRole role;
  final String content;

  const ChatMessage({
    required this.role,
    required this.content,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json["role"] == "assistant"
          ? ChatRole.assistant
          : ChatRole.user,
      content: json["content"] as String,
    );
  }
}