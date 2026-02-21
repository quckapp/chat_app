import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_event.dart';
import '../../../bloc/channel_extras/channel_extras_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel_extras.dart';
import '../../../models/serializable/channel_extras_dto.dart';
import '../../widgets/channel/channel_link_tile.dart';

class ChannelLinksScreen extends StatefulWidget {
  final String channelId;

  const ChannelLinksScreen({super.key, required this.channelId});

  @override
  State<ChannelLinksScreen> createState() => _ChannelLinksScreenState();
}

class _ChannelLinksScreenState extends State<ChannelLinksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChannelExtrasBloc>().add(LoadLinks(channelId: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Links'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLinkDialog(),
        child: const Icon(Icons.add_link),
      ),
      body: BlocConsumer<ChannelExtrasBloc, ChannelExtrasState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.links.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.links.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ChannelExtrasBloc>()
                  .add(LoadLinks(channelId: widget.channelId));
            },
            child: ListView.separated(
              itemCount: state.links.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final link = state.links[index];
                return ChannelLinkTile(
                  link: link,
                  onDelete: () => _confirmDelete(link),
                );
              },
            ),
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
          Icon(Icons.link_off, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No links yet', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Add useful links to this channel',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ChannelLink link) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Link'),
        content: Text('Remove "${link.title}" from channel links?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChannelExtrasBloc>().add(DeleteLink(
                    channelId: widget.channelId,
                    linkId: link.id,
                  ));
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddLinkDialog() {
    final urlController = TextEditingController();
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'URL'),
              keyboardType: TextInputType.url,
              autofocus: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final url = urlController.text.trim();
              final title = titleController.text.trim();
              if (url.isNotEmpty && title.isNotEmpty) {
                Navigator.pop(ctx);
                context.read<ChannelExtrasBloc>().add(CreateLink(
                      channelId: widget.channelId,
                      data: CreateChannelLinkDto(
                        url: url,
                        title: title,
                        description: descController.text.trim().isEmpty
                            ? null
                            : descController.text.trim(),
                      ),
                    ));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
