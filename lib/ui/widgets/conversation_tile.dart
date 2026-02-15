import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/bloc.dart';
import '../../core/theme/theme.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import 'presence_indicator.dart';
import 'typing_indicator.dart';

/// A list tile for displaying a conversation in a list
class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = conversation.displayName(currentUserId);
    final lastMessage = conversation.lastMessage;
    final hasUnread = conversation.hasUnread;

    // Get other participant for direct chats (for presence indicator)
    final otherParticipant = conversation.getOtherParticipant(currentUserId);

    return Material(
      color: hasUnread ? AppColors.primary.withValues(alpha: 0.03) : Colors.white,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Avatar with presence indicator
              _buildAvatar(context, displayName, otherParticipant?.id),

              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and time row
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  displayName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight:
                                        hasUnread ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (conversation.isMuted) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.notifications_off,
                                  size: 14,
                                  color: AppColors.grey400,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (lastMessage != null)
                          Text(
                            _formatTime(lastMessage.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: hasUnread
                                  ? AppColors.primary
                                  : AppColors.grey500,
                              fontWeight:
                                  hasUnread ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Last message and badges row
                    Row(
                      children: [
                        // Typing indicator or last message
                        Expanded(
                          child: BlocBuilder<TypingBloc, TypingState>(
                            builder: (context, typingState) {
                              final typingUsers =
                                  typingState.getTypingUsers(conversation.id);

                              if (typingUsers.isNotEmpty) {
                                return Row(
                                  children: [
                                    const TypingIndicator(
                                      dotSize: 5,
                                      spacing: 2,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'typing...',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: AppColors.primary,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return _buildLastMessagePreview(
                                  context, lastMessage, hasUnread);
                            },
                          ),
                        ),

                        // Badges
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (conversation.isPinned) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.push_pin,
                                size: 14,
                                color: AppColors.grey400,
                              ),
                            ],
                            if (hasUnread) ...[
                              const SizedBox(width: 8),
                              _buildUnreadBadge(context),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(
      BuildContext context, String displayName, String? otherUserId) {
    final avatar = conversation.displayAvatar(currentUserId);
    final initials = _getInitials(displayName);

    Widget avatarWidget;

    if (conversation.isGroup) {
      avatarWidget = Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.secondary.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.group, color: Colors.white, size: 26),
      );
    } else if (avatar != null) {
      avatarWidget = Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(avatar),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Generate a consistent color based on the name
      final colorIndex = displayName.hashCode % _avatarColors.length;
      final avatarColor = _avatarColors[colorIndex.abs()];

      avatarWidget = Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              avatarColor,
              avatarColor.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Add presence indicator for direct chats
    if (conversation.isDirect && otherUserId != null) {
      avatarWidget = PresenceIndicatorPositioned(
        userId: otherUserId,
        indicatorSize: 14,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildLastMessagePreview(
      BuildContext context, Message? message, bool hasUnread) {
    final theme = Theme.of(context);

    if (message == null) {
      return Text(
        'No messages yet',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.grey400,
          fontStyle: FontStyle.italic,
          fontSize: 14,
        ),
      );
    }

    // Build message preview with sender name for groups
    Widget content;
    final isSentByMe = message.senderId == currentUserId;

    if (message.isDeleted) {
      content = Row(
        children: [
          Icon(Icons.block, size: 14, color: AppColors.grey400),
          const SizedBox(width: 4),
          Text(
            'Message deleted',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey400,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ],
      );
    } else {
      // Build preview text
      final previewText = _getMessagePreviewText(message);

      content = Row(
        children: [
          // Read receipt for sent messages
          if (isSentByMe) ...[
            _buildReadReceipt(message),
            const SizedBox(width: 4),
          ],

          // Sender name for groups
          if (conversation.isGroup && !isSentByMe) ...[
            Text(
              '${_getSenderName(message)}: ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasUnread ? AppColors.grey700 : AppColors.grey500,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ] else if (isSentByMe) ...[
            Text(
              'You: ',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
                fontSize: 14,
              ),
            ),
          ],

          // Message content
          Expanded(
            child: Text(
              previewText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasUnread ? AppColors.grey800 : AppColors.grey500,
                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return content;
  }

  Widget _buildReadReceipt(Message message) {
    if (message.isPending) {
      return SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: AppColors.grey400,
        ),
      );
    }

    if (message.hasFailed) {
      return Icon(Icons.error_outline, size: 14, color: AppColors.error);
    }

    final isRead = message.readBy.isNotEmpty;

    return Icon(
      isRead ? Icons.done_all : Icons.done,
      size: 14,
      color: isRead ? AppColors.primary : AppColors.grey400,
    );
  }

  Widget _buildUnreadBadge(BuildContext context) {
    final count = conversation.unreadCount;
    final displayCount = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: EdgeInsets.symmetric(
        horizontal: count > 9 ? 6 : 0,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: conversation.isMuted ? AppColors.grey400 : AppColors.primary,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Center(
        child: Text(
          displayCount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  String _getSenderName(Message message) {
    // In a real app, you'd look up the sender's name
    // For now, just return a short version
    return message.senderId.substring(0, 8);
  }

  String _getMessagePreviewText(Message message) {
    switch (message.type) {
      case 'image':
        return '📷 Photo';
      case 'video':
        return '🎥 Video';
      case 'file':
        return '📎 File';
      case 'audio':
        return '🎤 Voice message';
      case 'location':
        return '📍 Location';
      case 'contact':
        return '👤 Contact';
      case 'sticker':
        return '🎨 Sticker';
      default:
        if (message.attachments.isNotEmpty) {
          final attachment = message.attachments.first;
          if (attachment.isImage) return '📷 Photo';
          if (attachment.isVideo) return '🎥 Video';
          if (attachment.isAudio) return '🎤 Voice message';
          return '📎 File';
        }
        return message.content;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);
    final difference = today.difference(messageDate).inDays;

    if (difference == 0) {
      return DateFormat.jm().format(time);
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return DateFormat.E().format(time); // Day name (Mon, Tue, etc.)
    } else if (time.year == now.year) {
      return DateFormat.MMMd().format(time); // Jan 15
    } else {
      return DateFormat.yMMMd().format(time); // Jan 15, 2024
    }
  }
}

// Color palette for avatars
const List<Color> _avatarColors = [
  Color(0xFF6366F1), // Indigo
  Color(0xFF8B5CF6), // Purple
  Color(0xFFEC4899), // Pink
  Color(0xFFEF4444), // Red
  Color(0xFFF97316), // Orange
  Color(0xFFF59E0B), // Amber
  Color(0xFF10B981), // Emerald
  Color(0xFF14B8A6), // Teal
  Color(0xFF06B6D4), // Cyan
  Color(0xFF3B82F6), // Blue
];
