import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel_extras.dart';

class ChannelTabTile extends StatelessWidget {
  final ChannelTab tab;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ChannelTabTile({
    super.key,
    required this.tab,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _typeColor.withValues(alpha: 0.1),
        child: Icon(_typeIcon, color: _typeColor, size: 20),
      ),
      title: Text(
        tab.name,
        style: AppTypography.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        tab.url,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: AppColors.grey400, size: 20),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }

  IconData get _typeIcon {
    switch (tab.type) {
      case 'doc':
        return Icons.description;
      case 'spreadsheet':
        return Icons.table_chart;
      case 'link':
        return Icons.link;
      case 'custom':
        return Icons.widgets;
      default:
        return Icons.tab;
    }
  }

  Color get _typeColor {
    switch (tab.type) {
      case 'doc':
        return Colors.blue;
      case 'spreadsheet':
        return Colors.green;
      case 'link':
        return AppColors.primary;
      case 'custom':
        return Colors.orange;
      default:
        return AppColors.grey500;
    }
  }
}
