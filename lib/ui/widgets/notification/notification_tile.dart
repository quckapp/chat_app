import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _typeColor.withValues(alpha: 0.1),
        child: Icon(_typeIcon, color: _typeColor, size: 20),
      ),
      title: Text(
        notification.title,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: notification.isUnread ? FontWeight.w600 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        notification.body,
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(notification.createdAt),
            style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
          ),
          if (notification.isUnread) ...[
            const SizedBox(height: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      tileColor: notification.isUnread
          ? AppColors.primary.withValues(alpha: 0.04)
          : null,
      onTap: onTap,
    );
  }

  Color get _typeColor {
    switch (notification.type) {
      case NotificationType.message:
        return AppColors.primary;
      case NotificationType.mention:
        return Colors.blue;
      case NotificationType.reaction:
        return Colors.orange;
      case NotificationType.threadReply:
        return Colors.purple;
      case NotificationType.channelInvite:
        return Colors.green;
      case NotificationType.system:
        return AppColors.grey500;
    }
  }

  IconData get _typeIcon {
    switch (notification.type) {
      case NotificationType.message:
        return Icons.chat_bubble_outline;
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.reaction:
        return Icons.emoji_emotions_outlined;
      case NotificationType.threadReply:
        return Icons.reply;
      case NotificationType.channelInvite:
        return Icons.group_add_outlined;
      case NotificationType.system:
        return Icons.info_outline;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${date.day}/${date.month}';
  }
}
