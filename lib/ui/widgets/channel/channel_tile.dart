import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel.dart';

class ChannelTile extends StatelessWidget {
  final Channel channel;
  final bool isActive;
  final VoidCallback? onTap;

  const ChannelTile({
    super.key,
    required this.channel,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive
            ? AppColors.primary
            : AppColors.primary.withOpacity(0.1),
        backgroundImage: channel.avatar != null ? NetworkImage(channel.avatar!) : null,
        child: channel.avatar == null ? _buildIcon() : null,
      ),
      title: Text(
        channel.name,
        style: AppTypography.bodyLarge.copyWith(
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        channel.topic ?? channel.description ?? '${channel.memberCount} members',
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (channel.isArchived)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: Icon(Icons.archive, size: 16, color: AppColors.grey400),
            ),
          if (isActive)
            Icon(Icons.check_circle, color: AppColors.primary, size: 20),
        ],
      ),
      selected: isActive,
      onTap: onTap,
    );
  }

  Widget _buildIcon() {
    final IconData icon;
    switch (channel.type) {
      case ChannelType.private:
        icon = Icons.lock;
        break;
      case ChannelType.dm:
        icon = Icons.person;
        break;
      default:
        icon = Icons.tag;
    }

    return Icon(
      icon,
      color: isActive ? Colors.white : AppColors.primary,
      size: 20,
    );
  }
}
