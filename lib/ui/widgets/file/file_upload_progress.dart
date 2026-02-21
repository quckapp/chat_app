import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class FileUploadProgress extends StatelessWidget {
  final String fileName;
  final double progress;
  final VoidCallback? onCancel;

  const FileUploadProgress({
    super.key,
    required this.fileName,
    required this.progress,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        children: [
          Icon(Icons.upload_file, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(fileName, style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress, minHeight: 3),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('${(progress * 100).toInt()}%', style: AppTypography.labelSmall),
          if (onCancel != null)
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
        ],
      ),
    );
  }
}
