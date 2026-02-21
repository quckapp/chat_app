import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/channel/channel_bloc.dart';
import '../../../bloc/channel/channel_event.dart';
import '../../../bloc/channel/channel_state.dart';
import '../../../bloc/workspace/workspace_bloc.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel.dart';
import '../../widgets/channel/channel_tile.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({super.key});

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  void _loadChannels() {
    final workspaceState = context.read<WorkspaceBloc>().state;
    final activeWorkspace = workspaceState.activeWorkspace;
    if (activeWorkspace != null) {
      context.read<ChannelBloc>().add(ChannelLoad(workspaceId: activeWorkspace.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/channels/create'),
          ),
        ],
      ),
      body: BlocConsumer<ChannelBloc, ChannelState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.channels.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.channels.isEmpty) {
            return _buildEmptyState(context);
          }

          // Group channels by type
          final publicChannels =
              state.channels.where((c) => c.type == ChannelType.public).toList();
          final privateChannels =
              state.channels.where((c) => c.type == ChannelType.private).toList();
          final dmChannels =
              state.channels.where((c) => c.type == ChannelType.dm).toList();

          return RefreshIndicator(
            onRefresh: () async => _loadChannels(),
            child: ListView(
              children: [
                if (publicChannels.isNotEmpty) ...[
                  _buildSectionHeader('Public Channels', publicChannels.length),
                  ...publicChannels.map((c) => ChannelTile(
                        channel: c,
                        isActive: state.activeChannel?.id == c.id,
                        onTap: () => _onChannelTap(c),
                      )),
                ],
                if (privateChannels.isNotEmpty) ...[
                  _buildSectionHeader('Private Channels', privateChannels.length),
                  ...privateChannels.map((c) => ChannelTile(
                        channel: c,
                        isActive: state.activeChannel?.id == c.id,
                        onTap: () => _onChannelTap(c),
                      )),
                ],
                if (dmChannels.isNotEmpty) ...[
                  _buildSectionHeader('Direct Messages', dmChannels.length),
                  ...dmChannels.map((c) => ChannelTile(
                        channel: c,
                        isActive: state.activeChannel?.id == c.id,
                        onTap: () => _onChannelTap(c),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '($count)',
            style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No channels yet',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Create a channel to start communicating',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => context.push('/channels/create'),
            icon: const Icon(Icons.add),
            label: const Text('Create Channel'),
          ),
        ],
      ),
    );
  }

  void _onChannelTap(Channel channel) {
    context.read<ChannelBloc>().add(ChannelSelectActive(channelId: channel.id));
    context.push('/channel/${channel.id}');
  }
}
