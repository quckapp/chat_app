import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../bloc/bloc.dart';
import '../../core/theme/theme.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../models/participant.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/presence_indicator.dart';

/// Screen for chatting in a conversation
class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  bool _isLoading = true;
  bool _showScrollToBottom = false;
  Message? _replyToMessage;
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    _joinConversation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Rejoin conversation when app resumes
      context.read<ChatBloc>().add(ChatJoinConversation(widget.conversationId));
    }
  }

  Future<void> _joinConversation() async {
    context.read<ChatBloc>().add(ChatJoinConversation(widget.conversationId));
    context.read<TypingBloc>().add(TypingSubscribe(widget.conversationId));

    if (mounted) {
      setState(() => _isLoading = false);
    }

    // Scroll to bottom after initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animate: false);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final threshold = 100.0;

    // Show scroll to bottom button when not at bottom
    final shouldShow = currentScroll < maxScroll - threshold;
    if (shouldShow != _showScrollToBottom) {
      setState(() => _showScrollToBottom = shouldShow);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    // Leave conversation when screen is disposed
    context.read<ChatBloc>().add(ChatLeaveConversation(widget.conversationId));
    context.read<TypingBloc>().add(TypingUnsubscribe(widget.conversationId));
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    if (animate) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _setReplyTo(Message message) {
    setState(() => _replyToMessage = message);
  }

  void _clearReply() {
    setState(() => _replyToMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUserId = authState.user?.id ?? '';

        return BlocConsumer<ChatBloc, ChatState>(
          listener: (context, chatState) {
            // Auto-scroll when new messages arrive
            final messages = chatState.getMessagesForConversation(widget.conversationId);
            if (messages.length > _previousMessageCount && _previousMessageCount > 0) {
              // New message received
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_showScrollToBottom) {
                  _scrollToBottom();
                }
              });
            }
            _previousMessageCount = messages.length;
          },
          builder: (context, chatState) {
            final conversation = chatState.getConversation(widget.conversationId);
            final messages = chatState.getMessagesForConversation(widget.conversationId);
            final otherParticipant = conversation?.getOtherParticipant(currentUserId);

            return Scaffold(
              backgroundColor: AppColors.grey50,
              appBar: _buildAppBar(context, conversation, otherParticipant, currentUserId),
              body: Column(
                children: [
                  // Connection status banner
                  BlocBuilder<RealtimeBloc, RealtimeState>(
                    builder: (context, realtimeState) {
                      if (realtimeState.isConnected) return const SizedBox.shrink();

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: realtimeState.hasError
                            ? AppColors.error.withValues(alpha: 0.1)
                            : AppColors.warning.withValues(alpha: 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: realtimeState.isConnecting || realtimeState.isReconnecting
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.warning,
                                    )
                                  : Icon(Icons.cloud_off, size: 16, color: AppColors.error),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              realtimeState.isConnecting || realtimeState.isReconnecting
                                  ? 'Connecting...'
                                  : 'No connection',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: realtimeState.hasError ? AppColors.error : AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (realtimeState.hasError) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => context.read<RealtimeBloc>().add(const RealtimeConnect()),
                                child: Text(
                                  'Retry',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),

                  // Messages list
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : messages.isEmpty
                            ? _buildEmptyState(context)
                            : _buildMessageList(context, messages, currentUserId),
                  ),

                  // Typing indicator above input
                  BlocBuilder<TypingBloc, TypingState>(
                    builder: (context, typingState) {
                      final typingUsers = typingState.getTypingUsers(widget.conversationId);
                      if (typingUsers.isEmpty) return const SizedBox.shrink();

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const TypingIndicator(dotSize: 6, spacing: 3),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _buildTypingText(typingUsers),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.grey600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Reply preview
                  if (_replyToMessage != null) _buildReplyPreview(context),

                  // Message input
                  Container(
                    color: Colors.white,
                    child: SafeArea(
                      top: false,
                      child: ChatMessageInput(
                        onSend: (content) => _sendMessage(content),
                        onTypingStart: () {
                          context.read<TypingBloc>().add(TypingStarted(widget.conversationId));
                        },
                        onTypingStop: () {
                          context.read<TypingBloc>().add(TypingStopped(widget.conversationId));
                        },
                        hintText: _replyToMessage != null ? 'Reply...' : 'Type a message',
                        replyTo: _replyToMessage,
                        onCancelReply: _clearReply,
                      ),
                    ),
                  ),
                ],
              ),

              // Scroll to bottom FAB
              floatingActionButton: _showScrollToBottom
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: FloatingActionButton.small(
                        onPressed: _scrollToBottom,
                        backgroundColor: Colors.white,
                        elevation: 4,
                        child: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey700),
                      ),
                    )
                  : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    Conversation? conversation,
    Participant? otherParticipant,
    String currentUserId,
  ) {
    final theme = Theme.of(context);
    final displayName = conversation?.displayName(currentUserId) ?? 'Chat';
    final isGroup = conversation?.isGroup ?? false;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
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
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => _showChatInfo(context),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            // Avatar with presence
            _buildHeaderAvatar(context, otherParticipant, isGroup, displayName),
            const SizedBox(width: 12),

            // Name and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  _buildStatusText(context, otherParticipant, isGroup, conversation),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video call coming soon')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.call_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice call coming soon')),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) => _onMenuSelected(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'info', child: Text('Chat info')),
            const PopupMenuItem(value: 'search', child: Text('Search')),
            const PopupMenuItem(value: 'mute', child: Text('Mute notifications')),
            const PopupMenuItem(value: 'clear', child: Text('Clear chat')),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderAvatar(
    BuildContext context,
    Participant? otherParticipant,
    bool isGroup,
    String displayName,
  ) {
    Widget avatar;

    if (isGroup) {
      avatar = Container(
        width: 40,
        height: 40,
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
        child: const Icon(Icons.group, color: Colors.white, size: 20),
      );
    } else if (otherParticipant?.avatar != null) {
      avatar = CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(otherParticipant!.avatar!),
      );
    } else {
      // Generate consistent color based on name
      final colorIndex = displayName.hashCode % _avatarColors.length;
      final avatarColor = _avatarColors[colorIndex.abs()];

      avatar = Container(
        width: 40,
        height: 40,
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
            otherParticipant?.initials ?? _getInitials(displayName),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Add presence indicator for direct chats
    if (!isGroup && otherParticipant != null) {
      return PresenceIndicatorPositioned(
        userId: otherParticipant.id,
        indicatorSize: 12,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildStatusText(
    BuildContext context,
    Participant? otherParticipant,
    bool isGroup,
    Conversation? conversation,
  ) {
    final theme = Theme.of(context);

    return BlocBuilder<TypingBloc, TypingState>(
      builder: (context, typingState) {
        final typingUsers = typingState.getTypingUsers(widget.conversationId);

        if (typingUsers.isNotEmpty) {
          return Text(
            'typing...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          );
        }

        // Show participant count for groups
        if (isGroup && conversation != null) {
          return Text(
            '${conversation.participants.length} participants',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
              fontSize: 12,
            ),
          );
        }

        // Show online status for direct chats
        if (otherParticipant != null) {
          return BlocBuilder<PresenceBloc, PresenceState>(
            builder: (context, presenceState) {
              final isOnline = presenceState.isOnline(otherParticipant.id);
              return Text(
                isOnline ? 'Online' : 'Offline',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isOnline ? AppColors.success : AppColors.grey500,
                  fontSize: 12,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No messages yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grey800,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to start the conversation',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, List<Message> messages, String currentUserId) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isSent = message.senderId == currentUserId;

        // Check if we should show date separator
        final showDateSeparator = index == 0 ||
            !_isSameDay(messages[index - 1].createdAt, message.createdAt);

        // Check if this is a continuation from same sender
        final isFirstFromSender = index == 0 ||
            messages[index - 1].senderId != message.senderId ||
            showDateSeparator;

        // Check if next message is from same sender
        final isLastFromSender = index == messages.length - 1 ||
            messages[index + 1].senderId != message.senderId ||
            (index < messages.length - 1 && !_isSameDay(message.createdAt, messages[index + 1].createdAt));

        return Column(
          children: [
            if (showDateSeparator)
              _buildDateSeparator(context, message.createdAt),
            if (message.isSystem)
              SystemMessageBubble(message: message)
            else
              Padding(
                padding: EdgeInsets.only(
                  top: isFirstFromSender ? 8 : 2,
                  bottom: isLastFromSender ? 8 : 2,
                ),
                child: ChatMessageBubble(
                  message: message,
                  isSent: isSent,
                  showTimestamp: isLastFromSender,
                  showReadReceipts: isSent && isLastFromSender,
                  isFirstInGroup: isFirstFromSender,
                  isLastInGroup: isLastFromSender,
                  onTap: () {},
                  onLongPress: () => _showMessageOptions(context, message, currentUserId),
                  onSwipeReply: () => _setReplyTo(message),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDateSeparator(BuildContext context, DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            _formatDateSeparator(date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }

  String _formatDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else if (date.year == now.year) {
      return DateFormat('MMMM d').format(date);
    } else {
      return DateFormat('MMMM d, y').format(date);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildReplyPreview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Replying to',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  _replyToMessage!.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: _clearReply,
            color: AppColors.grey500,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String content) async {
    context.read<ChatBloc>().add(ChatSendMessage(
          conversationId: widget.conversationId,
          content: content,
          replyTo: _replyToMessage?.id,
        ));

    _clearReply();

    // Scroll to bottom after sending
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _showMessageOptions(BuildContext context, Message message, String currentUserId) {
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Message preview
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Quick reactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['👍', '❤️', '😂', '😮', '😢', '🙏'].map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        context.read<ChatBloc>().add(ChatAddReaction(
                              conversationId: widget.conversationId,
                              messageId: message.id,
                              emoji: emoji,
                            ));
                        Navigator.pop(bottomSheetContext);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          shape: BoxShape.circle,
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 24)),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),
              const Divider(),

              // Actions
              ListTile(
                leading: const Icon(Icons.reply_outlined),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setReplyTo(message);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Copy'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message copied'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.forward_outlined),
                title: const Text('Forward'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Forward coming soon')),
                  );
                },
              ),
              if (message.senderId == currentUserId) ...[
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showEditDialog(context, message);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text('Delete', style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _showDeleteConfirmation(context, message);
                  },
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Message message) {
    final controller = TextEditingController(text: message.content);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: const InputDecoration(
            hintText: 'Enter new message',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final newContent = controller.text.trim();
              if (newContent.isNotEmpty && newContent != message.content) {
                // TODO: Implement edit message in bloc
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit coming soon')),
                );
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This message will be deleted for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              // TODO: Implement delete message in bloc
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete coming soon')),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showChatInfo(BuildContext context) {
    context.push('/chat/${widget.conversationId}/info');
  }

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'info':
        _showChatInfo(context);
        break;
      case 'search':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Search coming soon')),
        );
        break;
      case 'mute':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mute coming soon')),
        );
        break;
      case 'clear':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Clear chat coming soon')),
        );
        break;
    }
  }

  String _buildTypingText(Set<String> typingUserIds) {
    if (typingUserIds.length == 1) {
      return 'typing...';
    }
    return '${typingUserIds.length} people typing...';
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
