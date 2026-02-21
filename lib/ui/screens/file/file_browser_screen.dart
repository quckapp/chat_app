import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/file/file_bloc.dart';
import '../../../bloc/file/file_event.dart';
import '../../../bloc/file/file_state.dart';
import '../../../bloc/workspace/workspace_bloc.dart';
import '../../../core/theme/theme.dart';
import '../../../models/file_info.dart';
import '../../widgets/file/file_tile.dart';

class FileBrowserScreen extends StatefulWidget {
  const FileBrowserScreen({super.key});

  @override
  State<FileBrowserScreen> createState() => _FileBrowserScreenState();
}

class _FileBrowserScreenState extends State<FileBrowserScreen> {
  @override
  void initState() {
    super.initState();
    final ws = context.read<WorkspaceBloc>().state.activeWorkspace;
    context.read<FileBloc>().add(FileLoad(workspaceId: ws?.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Files')),
      body: BlocConsumer<FileBloc, FileState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.files.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.files.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: AppColors.grey400),
                  const SizedBox(height: AppSpacing.md),
                  Text('No files yet', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Files shared in channels will appear here',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              final ws = context.read<WorkspaceBloc>().state.activeWorkspace;
              context.read<FileBloc>().add(FileLoad(workspaceId: ws?.id));
            },
            child: ListView.separated(
              itemCount: state.files.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final file = state.files[index];
                return FileTile(
                  file: file,
                  onTap: () {
                    context.read<FileBloc>().add(FileSelectPreview(fileId: file.id));
                    context.push('/file/${file.id}/preview');
                  },
                  onDelete: () => _confirmDelete(file),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(FileInfo file) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Delete "${file.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<FileBloc>().add(FileDelete(fileId: file.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
