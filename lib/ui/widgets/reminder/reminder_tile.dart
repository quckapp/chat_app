import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/reminder.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onSnooze;
  final VoidCallback? onDelete;

  const ReminderTile({
    super.key,
    required this.reminder,
    this.onTap,
    this.onComplete,
    this.onSnooze,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _statusColor.withValues(alpha: 0.1),
        child: Icon(_statusIcon, color: _statusColor, size: 20),
      ),
      title: Text(
        reminder.note ?? 'Reminder',
        style: AppTypography.bodyLarge.copyWith(
          decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatRemindAt(reminder.remindAt),
        style: AppTypography.bodySmall.copyWith(
          color: reminder.isOverdue ? AppColors.error : AppColors.grey500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!reminder.isCompleted && !reminder.isDismissed) ...[
            IconButton(
              icon: Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
              onPressed: onComplete,
              tooltip: 'Complete',
            ),
            IconButton(
              icon: Icon(Icons.snooze, color: AppColors.grey500, size: 20),
              onPressed: onSnooze,
              tooltip: 'Snooze',
            ),
          ],
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppColors.grey400, size: 20),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Color get _statusColor {
    if (reminder.isOverdue) return AppColors.error;
    switch (reminder.status) {
      case ReminderStatus.pending:
        return AppColors.primary;
      case ReminderStatus.snoozed:
        return AppColors.grey500;
      case ReminderStatus.completed:
        return AppColors.grey400;
      case ReminderStatus.dismissed:
        return AppColors.grey400;
    }
  }

  IconData get _statusIcon {
    if (reminder.isOverdue) return Icons.alarm;
    switch (reminder.status) {
      case ReminderStatus.pending:
        return Icons.alarm;
      case ReminderStatus.snoozed:
        return Icons.snooze;
      case ReminderStatus.completed:
        return Icons.check_circle;
      case ReminderStatus.dismissed:
        return Icons.cancel;
    }
  }

  String _formatRemindAt(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.isNegative) {
      final past = now.difference(date);
      if (past.inMinutes < 60) return '${past.inMinutes}m overdue';
      if (past.inHours < 24) return '${past.inHours}h overdue';
      return '${past.inDays}d overdue';
    }
    if (diff.inMinutes < 60) return 'In ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'In ${diff.inHours}h';
    if (diff.inDays < 7) return 'In ${diff.inDays}d';
    return '${date.day}/${date.month}/${date.year}';
  }
}
