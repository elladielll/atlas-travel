import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/companion_repository.dart';
import '../domain/chat_message.dart';
import 'companion_provider.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool loading;

  const ChatState({
    this.messages = const [],
    this.loading = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? loading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  late final CompanionRepository repository;

  static final List<ChatMessage> _history = [
    const ChatMessage(
      role: ChatRole.assistant,
      content:
          "👋 Hi! I'm Atlas.\n\nI'm your personal travel companion.\nAsk me anything about Dnipro.",
    ),
  ];

  @override
  ChatState build() {
    repository = ref.read(companionRepositoryProvider);

    return ChatState(
      messages: List.from(_history),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.loading) return;

    final userMessage = ChatMessage(
      role: ChatRole.user,
      content: text.trim(),
    );

    _history.add(userMessage);

    state = state.copyWith(
      loading: true,
      messages: List.from(_history),
    );

    try {
      final response = await repository.chat(text);

      for (final message in response) {
        if (message.role == ChatRole.assistant) {
          _history.add(message);
        }
      }

      state = ChatState(
        loading: false,
        messages: List.from(_history),
      );
    } catch (_) {
      const errorMessage = ChatMessage(
        role: ChatRole.assistant,
        content: "⚠️ Sorry, I couldn't reach the Atlas server.",
      );

      _history.add(errorMessage);

      state = ChatState(
        loading: false,
        messages: List.from(_history),
      );
    }
  }

  Future<void> clearConversation() async {
    await repository.clearChat();

    _history
      ..clear()
      ..add(
        const ChatMessage(
          role: ChatRole.assistant,
          content:
              "👋 Hi! I'm Atlas.\n\nLet's start a new conversation.",
        ),
      );

    state = ChatState(
      messages: List.from(_history),
    );
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);