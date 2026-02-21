import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel_extras.dart';

class ChannelLinkTile extends StatelessWidget {
  final ChannelLink link;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ChannelLinkTile({
    super.key,
    required this.link,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(Icons.link, color: AppColors.primary, size: 20),
      ),
      title: Text(
        link.title,
        style: AppTypography.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            link.url,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (link.description != null && link.description!.isNotEmpty)
            Text(
              link.description!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: AppColors.grey400, size: 20),
        onPressed: onDelete,
      ),
      onTap: onTap,
      isThreeLine: link.description != null && link.description!.isNotEmpty,
    );
  }
}
