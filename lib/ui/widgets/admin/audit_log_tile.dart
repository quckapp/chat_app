import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/audit_log.dart';

class AuditLogTile extends StatelessWidget {
  final AuditLogEntry entry;
  final VoidCallback? onTap;

  const AuditLogTile({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _actionColor.withValues(alpha: 0.1),
        child: Icon(_actionIcon, color: _actionColor, size: 20),
      ),
      title: Text(
        entry.action,
        style: AppTypography.bodyLarge,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${entry.targetType}/${entry.targetId}',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                _formatDate(entry.createdAt),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.grey500,
                  fontSize: 11,
                ),
              ),
              if (entry.ipAddress != null) ...[
                const SizedBox(width: 8),
                Text(
                  entry.ipAddress!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey500,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      onTap: onTap,
      isThreeLine: true,
    );
  }

  IconData get _actionIcon {
    if (entry.action.contains('login')) return Icons.login;
    if (entry.action.contains('logout')) return Icons.logout;
    if (entry.action.contains('create')) return Icons.add_circle_outline;
    if (entry.action.contains('update')) return Icons.edit;
    if (entry.action.contains('delete')) return Icons.delete_outline;
    if (entry.action.contains('suspend')) return Icons.block;
    return Icons.history;
  }

  Color get _actionColor {
    if (entry.action.contains('login')) return Colors.green;
    if (entry.action.contains('logout')) return Colors.orange;
    if (entry.action.contains('create')) return Colors.blue;
    if (entry.action.contains('update')) return AppColors.primary;
    if (entry.action.contains('delete')) return AppColors.error;
    if (entry.action.contains('suspend')) return AppColors.error;
    return AppColors.grey500;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
