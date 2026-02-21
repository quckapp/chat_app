import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/channel/channel_bloc.dart';
import '../../../bloc/channel/channel_event.dart';
import '../../../bloc/channel/channel_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/channel.dart';

class ChannelDetailScreen extends StatefulWidget {
  final String channelId;

  const ChannelDetailScreen({super.key, required this.channelId});

  @override
  State<ChannelDetailScreen> createState() => _ChannelDetailScreenState();
}

class _ChannelDetailScreenState extends State<ChannelDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChannelBloc>().add(ChannelSelectActive(channelId: widget.channelId));
    context.read<ChannelBloc>().add(ChannelLoadMembers(channelId: widget.channelId));
    context.read<ChannelBloc>().add(ChannelLoadPins(channelId: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        final channel = state.activeChannel;
        if (channel == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Channel')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final members = state.membersFor(widget.channelId);
        final pins = state.pinsFor(widget.channelId);

        return Scaffold(
          appBar: AppBar(
            title: Text(channel.name),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) => _onMenuAction(value, channel),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit Channel')),
                  const PopupMenuItem(value: 'members', child: Text('Manage Members')),
                  const PopupMenuItem(value: 'pins', child: Text('Pinned Messages')),
                  const PopupMenuItem(value: 'leave', child: Text('Leave Channel')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete Channel')),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel header
                _buildChannelHeader(channel),
                const SizedBox(height: AppSpacing.lg),

                // Channel info
                if (channel.description != null && channel.description!.isNotEmpty) ...[
                  Text('Description', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(channel.description!, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                ],

                if (channel.topic != null && channel.topic!.isNotEmpty) ...[
                  Text('Topic', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(channel.topic!, style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Stats row
                _buildStatsRow(channel, members.length, pins.length),
                const SizedBox(height: AppSpacing.lg),

                // Members section
                Text(
                  'Members (${members.length})',
                  style: AppTypography.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (members.isEmpty)
                  Text('No members loaded', style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500))
                else
                  ...members.map((m) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: m.avatar != null ? NetworkImage(m.avatar!) : null,
                          child: m.avatar == null
                              ? Text(
                                  (m.displayName ?? m.userId).substring(0, 1).toUpperCase(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                        title: Text(m.displayName ?? m.userId),
                        subtitle: Text(m.role, style: AppTypography.bodySmall.copyWith(color: AppColors.grey500)),
                        trailing: m.role == 'owner'
                            ? Chip(
                                label: Text('Owner', style: AppTypography.labelSmall),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              )
                            : null,
                      )),

                // Pinned messages section
                if (pins.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Pinned Messages (${pins.length})',
                    style: AppTypography.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...pins.map((p) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.push_pin, size: 20),
                          title: Text('Message: ${p.messageId}', style: AppTypography.bodyMedium),
                          subtitle: Text(
                            'Pinned ${_formatDate(p.pinnedAt)}',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => context.read<ChannelBloc>().add(
                                  ChannelUnpinMessage(channelId: widget.channelId, pinId: p.id),
                                ),
                          ),
                        ),
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelHeader(Channel channel) {
    final IconData typeIcon;
    switch (channel.type) {
      case ChannelType.private:
        typeIcon = Icons.lock;
        break;
      case ChannelType.dm:
        typeIcon = Icons.person;
        break;
      default:
        typeIcon = Icons.tag;
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          backgroundImage: channel.avatar != null ? NetworkImage(channel.avatar!) : null,
          child: channel.avatar == null
              ? Icon(typeIcon, size: 30, color: AppColors.primary)
              : null,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(typeIcon, size: 16, color: AppColors.grey500),
                  const SizedBox(width: AppSpacing.xs),
                  Text(channel.name, style: AppTypography.headlineMedium),
                ],
              ),
              if (channel.isArchived)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Chip(
                    label: Text('Archived', style: AppTypography.labelSmall.copyWith(color: AppColors.error)),
                    backgroundColor: AppColors.error.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(Channel channel, int memberCount, int pinCount) {
    return Row(
      children: [
        _buildStatItem(Icons.people, '$memberCount members'),
        const SizedBox(width: AppSpacing.lg),
        _buildStatItem(Icons.push_pin, '$pinCount pins'),
        const SizedBox(width: AppSpacing.lg),
        _buildStatItem(
          channel.isPublic ? Icons.public : Icons.lock,
          channel.type.name,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.grey500),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.grey500)),
      ],
    );
  }

  void _onMenuAction(String action, Channel channel) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit channel screen
        break;
      case 'members':
        context.read<ChannelBloc>().add(ChannelLoadMembers(channelId: widget.channelId));
        break;
      case 'pins':
        context.read<ChannelBloc>().add(ChannelLoadPins(channelId: widget.channelId));
        break;
      case 'leave':
        _showLeaveConfirmation(channel);
        break;
      case 'delete':
        _showDeleteConfirmation(channel);
        break;
    }
  }

  void _showLeaveConfirmation(Channel channel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Channel'),
        content: Text('Are you sure you want to leave #${channel.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChannelBloc>().add(ChannelLeave(channelId: channel.id));
              context.pop();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Channel channel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Channel'),
        content: Text('Are you sure you want to permanently delete #${channel.name}? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChannelBloc>().add(ChannelDelete(channelId: channel.id));
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${date.month}/${date.day}/${date.year}';
  }
}
