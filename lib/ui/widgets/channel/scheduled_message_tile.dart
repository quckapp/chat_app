import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/scheduled_message.dart';

class ScheduledMessageTile extends StatelessWidget {
  final ScheduledMessage message;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const ScheduledMessageTile({
    super.key,
    required this.message,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _statusColor.withValues(alpha: 0.1),
        child: Icon(_statusIcon, color: _statusColor, size: 20),
      ),
      title: Text(
        message.content,
        style: AppTypography.bodyLarge,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            'Scheduled for ${_formatDateTime(message.scheduledAt)}',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              message.status.toUpperCase(),
              style: AppTypography.bodyMedium.copyWith(
                color: _statusColor,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
      trailing: message.status == 'pending'
          ? IconButton(
              icon: Icon(Icons.cancel_outlined, color: AppColors.grey400, size: 20),
              onPressed: onCancel,
            )
          : null,
      onTap: onTap,
      isThreeLine: true,
    );
  }

  Color get _statusColor {
    switch (message.status) {
      case 'pending':
        return AppColors.primary;
      case 'sent':
        return Colors.green;
      case 'cancelled':
        return AppColors.grey500;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  IconData get _statusIcon {
    switch (message.status) {
      case 'pending':
        return Icons.schedule;
      case 'sent':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'failed':
        return Icons.error_outline;
      default:
        return Icons.schedule;
    }
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
