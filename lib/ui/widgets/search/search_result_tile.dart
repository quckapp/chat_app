import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/search_result.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResult result;
  final VoidCallback? onTap;

  const SearchResultTile({
    super.key,
    required this.result,
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
        result.title,
        style: AppTypography.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.snippet != null)
            Text(
              result.snippet!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (result.channelName != null || result.userName != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                [
                  if (result.channelName != null) '#${result.channelName}',
                  if (result.userName != null) result.userName,
                ].join(' - '),
                style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
              ),
            ),
        ],
      ),
      trailing: Text(
        result.type.name,
        style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
      ),
      onTap: onTap,
    );
  }

  Color get _typeColor {
    switch (result.type) {
      case SearchResultType.message:
        return AppColors.primary;
      case SearchResultType.user:
        return Colors.green;
      case SearchResultType.channel:
        return Colors.blue;
      case SearchResultType.file:
        return Colors.orange;
    }
  }

  IconData get _typeIcon {
    switch (result.type) {
      case SearchResultType.message:
        return Icons.chat_bubble_outline;
      case SearchResultType.user:
        return Icons.person_outline;
      case SearchResultType.channel:
        return Icons.tag;
      case SearchResultType.file:
        return Icons.insert_drive_file_outlined;
    }
  }
}
