import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/typing_indicator.dart';

class CompanionChatScreen extends ConsumerStatefulWidget {
  const CompanionChatScreen({super.key});

  @override
  ConsumerState<CompanionChatScreen> createState() =>
      _CompanionChatScreenState();
}

class _CompanionChatScreenState
    extends ConsumerState<CompanionChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Atlas AI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(chatProvider.notifier).clearConversation();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount:
                  state.messages.length + (state.loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (state.loading &&
                    index == state.messages.length) {
                  return const TypingIndicator();
                }

                return ChatBubble(
                  message: state.messages[index],
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: ChatInput(
              controller: _controller,
              onSend: () async {
                final text = _controller.text.trim();

                if (text.isEmpty) return;

                _controller.clear();

                await ref
                    .read(chatProvider.notifier)
                    .sendMessage(text);
              },
            ),
          ),
        ],
      ),
    );
  }
}