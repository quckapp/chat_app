import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/bookmark/bookmark_bloc.dart';
import '../../../bloc/bookmark/bookmark_event.dart';
import '../../../bloc/bookmark/bookmark_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/bookmark.dart';
import '../../widgets/bookmark/bookmark_tile.dart';

class BookmarkFolderScreen extends StatefulWidget {
  final String folderId;
  final String folderName;

  const BookmarkFolderScreen({
    super.key,
    required this.folderId,
    required this.folderName,
  });

  @override
  State<BookmarkFolderScreen> createState() => _BookmarkFolderScreenState();
}

class _BookmarkFolderScreenState extends State<BookmarkFolderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookmarkBloc>().add(BookmarkLoad(folderId: widget.folderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDeleteFolder(),
          ),
        ],
      ),
      body: BlocConsumer<BookmarkBloc, BookmarkState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.bookmarks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: AppColors.grey400),
                  const SizedBox(height: AppSpacing.md),
                  Text('Folder is empty', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Bookmarks added to this folder will appear here',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BookmarkBloc>().add(BookmarkLoad(folderId: widget.folderId));
            },
            child: ListView.separated(
              itemCount: state.bookmarks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final bookmark = state.bookmarks[index];
                return BookmarkTile(
                  bookmark: bookmark,
                  onDelete: () => _confirmDelete(bookmark),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(Bookmark bookmark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: const Text('Remove this bookmark? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BookmarkBloc>().add(BookmarkDelete(bookmarkId: bookmark.id));
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteFolder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder'),
        content: const Text('Delete this folder? Bookmarks inside will not be deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BookmarkBloc>().add(BookmarkDeleteFolder(folderId: widget.folderId));
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
