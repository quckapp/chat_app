import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/attachment.dart';

/// Widget to display file attachments
class FileAttachment extends StatelessWidget {
  final Attachment file;
  final bool isSent;
  final VoidCallback? onTap;

  const FileAttachment({
    super.key,
    required this.file,
    required this.isSent,
    this.onTap,
  });

  String get _fileSize {
    if (file.size == null) return '';
    final bytes = file.size!;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get _fileExtension {
    final name = file.name ?? '';
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toUpperCase() : 'FILE';
  }

  IconData get _fileIcon {
    final ext = _fileExtension.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audio_file;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file;
      case 'txt':
        return Icons.text_snippet;
      case 'json':
      case 'xml':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color get _fileColor {
    final ext = _fileExtension.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.amber;
      default:
        return AppColors.grey600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSent
              ? Colors.white.withValues(alpha: 0.15)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // File icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _fileColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_fileIcon, color: _fileColor, size: 24),
            ),

            const SizedBox(width: 12),

            // File info
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    file.name ?? 'Unknown file',
                    style: TextStyle(
                      color: isSent ? Colors.white : AppColors.grey900,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$_fileExtension${_fileSize.isNotEmpty ? ' • $_fileSize' : ''}',
                    style: TextStyle(
                      color: isSent
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppColors.grey500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Download icon
            Icon(
              Icons.download_outlined,
              color: isSent ? Colors.white.withValues(alpha: 0.7) : AppColors.grey500,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display video thumbnail with play button
class VideoThumbnail extends StatelessWidget {
  final Attachment video;
  final bool isSent;
  final VoidCallback? onTap;

  const VideoThumbnail({
    super.key,
    required this.video,
    required this.isSent,
    this.onTap,
  });

  String get _duration {
    if (video.duration == null) return '';
    final seconds = video.duration!;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
            maxHeight: 200,
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              // Thumbnail
              if (video.thumbnailUrl != null)
                Image.network(
                  video.thumbnailUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 150,
                      color: AppColors.grey800,
                      child: Icon(Icons.videocam, color: AppColors.grey500, size: 48),
                    );
                  },
                )
              else
                Container(
                  width: 200,
                  height: 150,
                  color: AppColors.grey800,
                  child: Icon(Icons.videocam, color: AppColors.grey500, size: 48),
                ),

              // Play button overlay
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),

              // Duration badge
              if (_duration.isNotEmpty)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _duration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
