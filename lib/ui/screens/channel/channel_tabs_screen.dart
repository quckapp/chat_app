import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_event.dart';
import '../../../bloc/channel_extras/channel_extras_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel_extras.dart';
import '../../../models/serializable/channel_extras_dto.dart';
import '../../widgets/channel/channel_tab_tile.dart';

class ChannelTabsScreen extends StatefulWidget {
  final String channelId;

  const ChannelTabsScreen({super.key, required this.channelId});

  @override
  State<ChannelTabsScreen> createState() => _ChannelTabsScreenState();
}

class _ChannelTabsScreenState extends State<ChannelTabsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChannelExtrasBloc>().add(LoadTabs(channelId: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Tabs'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTabDialog(),
        child: const Icon(Icons.add),
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
          if (state.isLoading && state.tabs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.tabs.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ChannelExtrasBloc>()
                  .add(LoadTabs(channelId: widget.channelId));
            },
            child: ListView.separated(
              itemCount: state.tabs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tab = state.tabs[index];
                return ChannelTabTile(
                  tab: tab,
                  onDelete: () => _confirmDelete(tab),
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
          Icon(Icons.tab_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No tabs yet', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Add tabs to organize channel resources',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ChannelTab tab) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Tab'),
        content: Text('Remove "${tab.name}" from channel tabs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChannelExtrasBloc>().add(DeleteTab(
                    channelId: widget.channelId,
                    tabId: tab.id,
                  ));
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showAddTabDialog() {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    String selectedType = 'link';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Tab'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tab name'),
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'doc', child: Text('Document')),
                  DropdownMenuItem(value: 'spreadsheet', child: Text('Spreadsheet')),
                  DropdownMenuItem(value: 'link', child: Text('Link')),
                  DropdownMenuItem(value: 'custom', child: Text('Custom')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setDialogState(() => selectedType = v);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL'),
                keyboardType: TextInputType.url,
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
                final name = nameController.text.trim();
                final url = urlController.text.trim();
                if (name.isNotEmpty && url.isNotEmpty) {
                  Navigator.pop(ctx);
                  context.read<ChannelExtrasBloc>().add(CreateTab(
                        channelId: widget.channelId,
                        data: CreateChannelTabDto(
                          name: name,
                          type: selectedType,
                          url: url,
                        ),
                      ));
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
