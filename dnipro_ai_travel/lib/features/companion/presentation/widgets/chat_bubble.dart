import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_radius.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/app_text_styles.dart';
import '../../domain/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const _AtlasAvatar(),
            const SizedBox(width: AppSpacing.sm),
          ],
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(AppSpacing.lg),
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                color: isUser ? AppColors.ink : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppRadius.xl),
                  topRight: const Radius.circular(AppRadius.xl),
                  bottomLeft: Radius.circular(
                    isUser ? AppRadius.xl : AppRadius.sm,
                  ),
                  bottomRight: Radius.circular(
                    isUser ? AppRadius.sm : AppRadius.xl,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: AppTextStyles.body.copyWith(
                  color: isUser ? Colors.white : AppColors.ink,
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: AppSpacing.sm),
            const _UserAvatar(),
          ],
        ],
      ),
    );
  }
}

class _AtlasAvatar extends StatelessWidget {
  const _AtlasAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Text(
        '🧭',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 20,
        color: AppColors.muted,
      ),
    );
  }
}