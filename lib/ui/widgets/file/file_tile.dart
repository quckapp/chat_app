import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/file_info.dart';

class FileTile extends StatelessWidget {
  final FileInfo file;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FileTile({super.key, required this.file, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getColor().withValues(alpha: 0.1),
        child: Icon(_getIcon(), color: _getColor(), size: 20),
      ),
      title: Text(file.name, style: AppTypography.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${file.sizeFormatted} \u00B7 ${file.mimeType ?? file.type.name}',
        style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
      ),
      trailing: onDelete != null
          ? IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: onDelete)
          : null,
      onTap: onTap,
    );
  }

  IconData _getIcon() {
    switch (file.type) {
      case FileType.image: return Icons.image;
      case FileType.video: return Icons.videocam;
      case FileType.audio: return Icons.audiotrack;
      case FileType.document: return Icons.description;
      case FileType.archive: return Icons.archive;
      case FileType.other: return Icons.insert_drive_file;
    }
  }

  Color _getColor() {
    switch (file.type) {
      case FileType.image: return Colors.blue;
      case FileType.video: return Colors.red;
      case FileType.audio: return Colors.purple;
      case FileType.document: return Colors.orange;
      case FileType.archive: return Colors.brown;
      case FileType.other: return AppColors.grey500;
    }
  }
}
