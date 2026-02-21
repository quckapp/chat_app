import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/bookmark/bookmark_bloc.dart';
import '../../../bloc/bookmark/bookmark_event.dart';
import '../../../bloc/bookmark/bookmark_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/bookmark.dart';
import '../../../models/serializable/bookmark_dto.dart';
import '../../widgets/bookmark/bookmark_tile.dart';

class BookmarkListScreen extends StatefulWidget {
  const BookmarkListScreen({super.key});

  @override
  State<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  String? _selectedFolderId;

  @override
  void initState() {
    super.initState();
    context.read<BookmarkBloc>().add(const BookmarkLoad());
    context.read<BookmarkBloc>().add(const BookmarkLoadFolders());
  }

  void _loadBookmarks() {
    context.read<BookmarkBloc>().add(BookmarkLoad(folderId: _selectedFolderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.create_new_folder_outlined),
            onPressed: () => _showCreateFolderDialog(),
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

          return Column(
            children: [
              // Folder filter chips
              if (state.folders.isNotEmpty)
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: FilterChip(
                          label: const Text('All'),
                          selected: _selectedFolderId == null,
                          onSelected: (_) {
                            setState(() => _selectedFolderId = null);
                            _loadBookmarks();
                          },
                        ),
                      ),
                      ...state.folders.map((folder) => Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.xs),
                            child: FilterChip(
                              label: Text(folder.name),
                              selected: _selectedFolderId == folder.id,
                              onSelected: (_) {
                                setState(() => _selectedFolderId = folder.id);
                                _loadBookmarks();
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              // Bookmark list
              Expanded(
                child: state.bookmarks.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () async => _loadBookmarks(),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No bookmarks yet', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Save messages to find them later',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
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

  void _showCreateFolderDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Folder name'),
              autofocus: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(ctx);
                context.read<BookmarkBloc>().add(
                      BookmarkCreateFolder(
                        data: CreateBookmarkFolderDto(
                          name: nameController.text.trim(),
                          description: descController.text.trim().isEmpty
                              ? null
                              : descController.text.trim(),
                        ),
                      ),
                    );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
