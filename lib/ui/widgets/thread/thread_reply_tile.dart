import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/thread.dart';

class ThreadReplyTile extends StatelessWidget {
  final Thread thread;
  final VoidCallback? onTap;

  const ThreadReplyTile({
    super.key,
    required this.thread,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(
          thread.isResolved ? Icons.check_circle : Icons.forum,
          color: thread.isResolved ? Colors.green : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        'Thread in message',
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.reply, size: 14, color: AppColors.grey500),
          const SizedBox(width: 4),
          Text(
            '${thread.replyCount} replies',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.people, size: 14, color: AppColors.grey500),
          const SizedBox(width: 4),
          Text(
            '${thread.participantCount}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
          ),
          if (thread.lastReplyAt != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Text(
              _formatDate(thread.lastReplyAt!),
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey400),
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (thread.isFollowing)
            Icon(Icons.notifications_active, size: 16, color: AppColors.primary),
          if (thread.isResolved)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.check_circle, size: 16, color: Colors.green),
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 30) return '${diff.inDays}d';
    return '${date.month}/${date.day}';
  }
}
