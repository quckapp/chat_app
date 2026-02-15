import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/bloc.dart';
import '../../core/theme/theme.dart';
import '../../models/conversation.dart';
import '../../models/participant.dart';
import '../widgets/presence_indicator.dart';

/// Screen showing chat/conversation details
class ChatInfoScreen extends StatelessWidget {
  final String conversationId;

  const ChatInfoScreen({
    super.key,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUserId = authState.user?.id ?? '';

        return BlocBuilder<ChatBloc, ChatState>(
          builder: (context, chatState) {
            final conversation = chatState.getConversation(conversationId);

            if (conversation == null) {
              return Scaffold(
                appBar: AppBar(title: const Text('Chat Info')),
                body: const Center(child: Text('Conversation not found')),
              );
            }

            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  // App bar with avatar
                  _buildSliverAppBar(context, conversation, currentUserId),

                  // Content
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Quick actions
                        _buildQuickActions(context),

                        const Divider(height: 32),

                        // Media section
                        _buildMediaSection(context),

                        const Divider(height: 32),

                        // Participants (for groups)
                        if (conversation.isGroup)
                          _buildParticipantsSection(context, conversation, currentUserId),

                        // Settings
                        _buildSettingsSection(context, conversation),

                        const Divider(height: 32),

                        // Danger zone
                        _buildDangerZone(context, conversation, currentUserId),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Conversation conversation, String currentUserId) {
    final otherParticipant = conversation.getOtherParticipant(currentUserId);
    final displayName = conversation.displayName(currentUserId);

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.grey900,
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
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.primary.withValues(alpha: 0.1),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Avatar
                if (otherParticipant != null)
                  PresenceIndicatorPositioned(
                    userId: otherParticipant.id,
                    indicatorSize: 20,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Text(
                        otherParticipant.initials,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                    child: const Icon(Icons.group, size: 40, color: AppColors.secondary),
                  ),

                const SizedBox(height: 16),

                // Name
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                // Status/participants count
                if (conversation.isGroup)
                  Text(
                    '${conversation.participants.length} participants',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.grey600,
                        ),
                  )
                else if (otherParticipant != null)
                  BlocBuilder<PresenceBloc, PresenceState>(
                    builder: (context, presenceState) {
                      final isOnline = presenceState.isOnline(otherParticipant.id);
                      return Text(
                        isOnline ? 'Online' : 'Offline',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isOnline ? AppColors.success : AppColors.grey500,
                            ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickActionButton(
            icon: Icons.call_outlined,
            label: 'Audio',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio call coming soon')),
              );
            },
          ),
          _QuickActionButton(
            icon: Icons.videocam_outlined,
            label: 'Video',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call coming soon')),
              );
            },
          ),
          _QuickActionButton(
            icon: Icons.search,
            label: 'Search',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
          _QuickActionButton(
            icon: Icons.notifications_outlined,
            label: 'Mute',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mute coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Media, Links, and Docs',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to media gallery
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),

        // Media preview grid
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: AppColors.grey400,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsSection(
    BuildContext context,
    Conversation conversation,
    String currentUserId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${conversation.participants.length} Participants',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),

        const SizedBox(height: 8),

        // Add participants button
        ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_add_outlined, color: AppColors.primary),
          ),
          title: const Text('Add Participants'),
          onTap: () {
            // Navigate to add participants
          },
        ),

        // Participant list
        ...conversation.participants.map((participant) {
          return _ParticipantTile(
            participant: participant,
            isCurrentUser: participant.id == currentUserId,
          );
        }),

        const Divider(height: 32),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, Conversation conversation) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          trailing: Switch(
            value: !conversation.isMuted,
            onChanged: (value) {
              // Toggle mute
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library_outlined),
          title: const Text('Media visibility'),
          subtitle: const Text('Show media in gallery'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Encryption'),
          subtitle: const Text('Messages are end-to-end encrypted'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: const Text('Disappearing messages'),
          subtitle: Text(
            conversation.disappearingMessagesTimer == 0 ? 'Off' : 'On',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showDisappearingMessagesDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone(
    BuildContext context,
    Conversation conversation,
    String currentUserId,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.block, color: AppColors.error),
          title: Text('Block', style: TextStyle(color: AppColors.error)),
          onTap: () {
            _showBlockConfirmation(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.thumb_down_outlined, color: AppColors.error),
          title: Text('Report', style: TextStyle(color: AppColors.error)),
          onTap: () {
            // Show report dialog
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: AppColors.error),
          title: Text('Clear chat', style: TextStyle(color: AppColors.error)),
          onTap: () {
            _showClearChatConfirmation(context);
          },
        ),
        if (conversation.isGroup)
          ListTile(
            leading: Icon(Icons.exit_to_app, color: AppColors.error),
            title: Text('Exit group', style: TextStyle(color: AppColors.error)),
            onTap: () {
              _showExitGroupConfirmation(context);
            },
          ),
      ],
    );
  }

  void _showDisappearingMessagesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disappearing messages'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('Off'),
              value: 0,
              groupValue: 0,
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<int>(
              title: const Text('24 hours'),
              value: 86400,
              groupValue: 0,
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<int>(
              title: const Text('7 days'),
              value: 604800,
              groupValue: 0,
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<int>(
              title: const Text('30 days'),
              value: 2592000,
              groupValue: 0,
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block contact?'),
        content: const Text('Blocked contacts cannot send you messages or call you.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contact blocked')),
              );
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showClearChatConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear chat?'),
        content: const Text('All messages will be deleted from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showExitGroupConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit group?'),
        content: const Text('You will no longer receive messages from this group.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You left the group')),
              );
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final Participant participant;
  final bool isCurrentUser;

  const _ParticipantTile({
    required this.participant,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PresenceIndicatorPositioned(
        userId: participant.id,
        indicatorSize: 12,
        child: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            participant.initials,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Text(participant.name),
          if (isCurrentUser)
            Text(
              ' (You)',
              style: TextStyle(color: AppColors.grey500),
            ),
        ],
      ),
      subtitle: participant.role != ParticipantRole.member
          ? Text(
              participant.role.name.capitalize(),
              style: TextStyle(color: AppColors.primary),
            )
          : null,
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {
          // Handle participant actions
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'view', child: Text('View profile')),
          const PopupMenuItem(value: 'message', child: Text('Message')),
          if (!isCurrentUser) ...[
            const PopupMenuItem(value: 'make_admin', child: Text('Make admin')),
            const PopupMenuItem(value: 'remove', child: Text('Remove')),
          ],
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
