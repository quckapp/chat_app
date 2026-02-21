import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/file/file_bloc.dart';
import '../../../bloc/file/file_event.dart';
import '../../../bloc/file/file_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/file_info.dart';

class FilePreviewScreen extends StatefulWidget {
  final String fileId;

  const FilePreviewScreen({super.key, required this.fileId});

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FileBloc>().add(FileSelectPreview(fileId: widget.fileId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        final file = state.previewFile;
        if (file == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('File Preview')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(file.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Share file
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(child: _buildPreview(file)),
              _buildFileInfo(file),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreview(FileInfo file) {
    if (file.type == FileType.image) {
      return Center(
        child: InteractiveViewer(
          child: Image.network(
            file.url,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildFallbackIcon(file),
          ),
        ),
      );
    }
    return Center(child: _buildFallbackIcon(file));
  }

  Widget _buildFallbackIcon(FileInfo file) {
    final IconData icon;
    switch (file.type) {
      case FileType.video:
        icon = Icons.videocam;
        break;
      case FileType.audio:
        icon = Icons.audiotrack;
        break;
      case FileType.document:
        icon = Icons.description;
        break;
      case FileType.archive:
        icon = Icons.archive;
        break;
      default:
        icon = Icons.insert_drive_file;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: AppColors.grey400),
        const SizedBox(height: AppSpacing.md),
        Text(file.name, style: AppTypography.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        Text(file.sizeFormatted, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500)),
      ],
    );
  }

  Widget _buildFileInfo(FileInfo file) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.grey400.withValues(alpha: 0.3))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(file.name, style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text(file.sizeFormatted, style: AppTypography.bodySmall.copyWith(color: AppColors.grey500)),
              const SizedBox(width: AppSpacing.md),
              Text(file.mimeType ?? file.type.name, style: AppTypography.bodySmall.copyWith(color: AppColors.grey500)),
              const SizedBox(width: AppSpacing.md),
              Text(
                '${file.createdAt.month}/${file.createdAt.day}/${file.createdAt.year}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
