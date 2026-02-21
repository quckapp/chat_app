import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/bookmark.dart';

class BookmarkTile extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BookmarkTile({
    super.key,
    required this.bookmark,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(Icons.bookmark, color: AppColors.primary, size: 20),
      ),
      title: Text(
        bookmark.note ?? 'Bookmarked message',
        style: AppTypography.bodyLarge,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatDate(bookmark.createdAt),
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: AppColors.grey400, size: 20),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
