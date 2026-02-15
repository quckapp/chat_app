import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';
import '../../models/attachment.dart';
import '../widgets/chat/image_message.dart';

/// Screen for viewing all shared media in a conversation
class MediaGalleryScreen extends StatefulWidget {
  final String conversationId;
  final String conversationName;

  const MediaGalleryScreen({
    super.key,
    required this.conversationId,
    required this.conversationName,
  });

  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data - in production, this would come from the chat service
  final List<Attachment> _images = [];
  final List<Attachment> _videos = [];
  final List<Attachment> _documents = [];
  final List<String> _links = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMedia();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMedia() {
    // TODO: Load media from chat service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Media'),
            Text(
              widget.conversationName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey500,
                  ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Media'),
            Tab(text: 'Docs'),
            Tab(text: 'Links'),
            Tab(text: 'Audio'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMediaTab(),
          _buildDocumentsTab(),
          _buildLinksTab(),
          _buildAudioTab(),
        ],
      ),
    );
  }

  Widget _buildMediaTab() {
    final allMedia = [..._images, ..._videos];

    if (allMedia.isEmpty) {
      return _buildEmptyState(
        icon: Icons.photo_library_outlined,
        title: 'No media yet',
        subtitle: 'Photos and videos shared in this chat will appear here',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: allMedia.length,
      itemBuilder: (context, index) {
        final media = allMedia[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageViewer(
                  images: _images,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                media.thumbnailUrl ?? media.url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.grey200,
                    child: Icon(
                      media.isVideo ? Icons.videocam : Icons.image,
                      color: AppColors.grey400,
                    ),
                  );
                },
              ),
              if (media.isVideo)
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          _formatDuration(media.duration ?? 0),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocumentsTab() {
    if (_documents.isEmpty) {
      return _buildEmptyState(
        icon: Icons.insert_drive_file_outlined,
        title: 'No documents yet',
        subtitle: 'Documents shared in this chat will appear here',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _documents.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final doc = _documents[index];
        return _DocumentListItem(document: doc);
      },
    );
  }

  Widget _buildLinksTab() {
    if (_links.isEmpty) {
      return _buildEmptyState(
        icon: Icons.link,
        title: 'No links yet',
        subtitle: 'Links shared in this chat will appear here',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _links.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final link = _links[index];
        return _LinkListItem(url: link);
      },
    );
  }

  Widget _buildAudioTab() {
    // Filter audio attachments
    final audioFiles = <Attachment>[];

    if (audioFiles.isEmpty) {
      return _buildEmptyState(
        icon: Icons.headphones_outlined,
        title: 'No audio yet',
        subtitle: 'Voice messages and audio files will appear here',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: audioFiles.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final audio = audioFiles[index];
        return _AudioListItem(audio: audio);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}

class _DocumentListItem extends StatelessWidget {
  final Attachment document;

  const _DocumentListItem({required this.document});

  String get _fileSize {
    if (document.size == null) return '';
    final bytes = document.size!;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData get _fileIcon {
    final name = document.name ?? '';
    final ext = name.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(_fileIcon, color: AppColors.primary),
      ),
      title: Text(
        document.name ?? 'Unknown file',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_fileSize),
      trailing: IconButton(
        icon: const Icon(Icons.download_outlined),
        onPressed: () {
          // Download file
        },
      ),
      onTap: () {
        // Open file
      },
    );
  }
}

class _LinkListItem extends StatelessWidget {
  final String url;

  const _LinkListItem({required this.url});

  String get _displayUrl {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (_) {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.link, color: AppColors.secondary),
      ),
      title: Text(
        _displayUrl,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.grey500),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.open_in_new),
        onPressed: () {
          // Open link
        },
      ),
      onTap: () {
        // Open link
      },
    );
  }
}

class _AudioListItem extends StatelessWidget {
  final Attachment audio;

  const _AudioListItem({required this.audio});

  String get _duration {
    if (audio.duration == null) return '';
    final seconds = audio.duration!;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.mic, color: AppColors.success),
      ),
      title: Text(
        audio.name ?? 'Voice message',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(_duration),
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_outline),
        onPressed: () {
          // Play audio
        },
      ),
      onTap: () {
        // Play audio
      },
    );
  }
}
