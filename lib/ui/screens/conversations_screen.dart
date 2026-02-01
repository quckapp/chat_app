import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/bloc.dart';
import '../../core/theme/theme.dart';
import '../../models/conversation.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/conversation_tile.dart';

/// Screen showing list of conversations
class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _isSearching = false;
  String _searchQuery = '';
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeOut),
    );
    _fabAnimationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RealtimeBloc>().add(const RealtimeConnect());
      context.read<ChatBloc>().add(const ChatLoadConversations());
      context.read<PresenceBloc>().add(const PresenceStartListening());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() => _isSearching = true);
    _searchFocusNode.requestFocus();
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  List<Conversation> _filterConversations(
      List<Conversation> conversations, String currentUserId) {
    if (_searchQuery.isEmpty) return conversations;

    final query = _searchQuery.toLowerCase();
    return conversations.where((c) {
      final name = c.displayName(currentUserId).toLowerCase();
      final lastMessage = c.lastMessage?.content.toLowerCase() ?? '';
      return name.contains(query) || lastMessage.contains(query);
    }).toList();
  }

  List<Conversation> _sortConversations(List<Conversation> conversations) {
    final sorted = List<Conversation>.from(conversations);
    sorted.sort((a, b) {
      // Pinned first
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;

      // Then by last message time
      final aTime = a.lastMessage?.createdAt ?? a.createdAt;
      final bTime = b.lastMessage?.createdAt ?? b.createdAt;
      return bTime.compareTo(aTime);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final currentUserId = authState.user?.id ?? '';
        final userName = authState.user?.fullName ?? 'User';

        return Scaffold(
          backgroundColor: AppColors.grey50,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildSliverAppBar(context, userName, innerBoxIsScrolled),
              ];
            },
            body: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, chatState) {
                if (chatState.isLoading) {
                  return const Center(
                    child: AppLoadingIndicator(size: LoadingSize.large),
                  );
                }

                if (chatState.hasError) {
                  return _buildErrorState(context, chatState.error ?? 'Failed to load conversations');
                }

                final allConversations = _sortConversations(chatState.conversations);
                final conversations =
                    _filterConversations(allConversations, currentUserId);

                if (chatState.conversations.isEmpty) {
                  return _buildEmptyState(context);
                }

                if (conversations.isEmpty && _searchQuery.isNotEmpty) {
                  return _buildNoSearchResults(context);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ChatBloc>().add(const ChatLoadConversations());
                  },
                  color: AppColors.primary,
                  child: CustomScrollView(
                    slivers: [
                      // Connection banner
                      _buildConnectionBanner(),

                      // Pinned conversations section
                      if (conversations.any((c) => c.isPinned))
                        _buildPinnedSection(
                            context, conversations, currentUserId),

                      // All conversations
                      _buildConversationsList(
                          context, conversations, currentUserId),
                    ],
                  ),
                );
              },
            ),
          ),
          floatingActionButton: ScaleTransition(
            scale: _fabScaleAnimation,
            child: FloatingActionButton(
              onPressed: () => context.push('/new-chat'),
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, String userName, bool innerBoxIsScrolled) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      // Use fixed expandedHeight - primary:true handles safe area automatically
      expandedHeight: _isSearching ? null : 110,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: innerBoxIsScrolled ? 1 : 0,
      forceElevated: innerBoxIsScrolled,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      title: _isSearching
          ? _buildSearchField()
          : Text(
              'Chats',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
      actions: [
        if (!_isSearching) ...[
          // Connection status
          BlocBuilder<RealtimeBloc, RealtimeState>(
            builder: (context, realtimeState) {
              if (realtimeState.isConnected) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: realtimeState.isConnecting || realtimeState.isReconnecting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.warning,
                          ),
                        )
                      : Icon(Icons.cloud_off, color: AppColors.error),
                  onPressed: () {
                    if (realtimeState.hasError) {
                      context.read<RealtimeBloc>().add(const RealtimeConnect());
                    }
                  },
                  tooltip: realtimeState.hasError ? 'Reconnect' : 'Connecting...',
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _startSearch,
            tooltip: 'Search',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_group',
                child: ListTile(
                  leading: Icon(Icons.group_add_outlined),
                  title: Text('New group'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'archived',
                child: ListTile(
                  leading: Icon(Icons.archive_outlined),
                  title: Text('Archived'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ] else
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _stopSearch,
          ),
      ],
      // Move quick actions to bottom slot instead of flexibleSpace
      bottom: !_isSearching
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: _buildQuickActions(context),
            )
          : null,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search conversations...',
        hintStyle: TextStyle(color: AppColors.grey500),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      onChanged: (value) => setState(() => _searchQuery = value),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _QuickActionChip(
            icon: Icons.group_add_outlined,
            label: 'New group',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New group coming soon')),
              );
            },
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.campaign_outlined,
            label: 'Broadcast',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Broadcast coming soon')),
              );
            },
          ),
          const SizedBox(width: 8),
          _QuickActionChip(
            icon: Icons.qr_code_scanner,
            label: 'Scan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR scan coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBanner() {
    return BlocBuilder<RealtimeBloc, RealtimeState>(
      builder: (context, realtimeState) {
        if (realtimeState.isConnected) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: realtimeState.hasError
                  ? AppColors.error.withValues(alpha: 0.1)
                  : AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: realtimeState.hasError
                    ? AppColors.error.withValues(alpha: 0.3)
                    : AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  realtimeState.hasError ? Icons.cloud_off : Icons.sync,
                  size: 20,
                  color: realtimeState.hasError ? AppColors.error : AppColors.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    realtimeState.hasError
                        ? 'Unable to connect. Messages may be delayed.'
                        : 'Connecting to server...',
                    style: TextStyle(
                      color: realtimeState.hasError
                          ? AppColors.error
                          : AppColors.warning,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (realtimeState.hasError)
                  TextButton(
                    onPressed: () {
                      context.read<RealtimeBloc>().add(const RealtimeConnect());
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Retry'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPinnedSection(
    BuildContext context,
    List<Conversation> conversations,
    String currentUserId,
  ) {
    final pinnedConversations = conversations.where((c) => c.isPinned).toList();

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'PINNED',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...pinnedConversations.map(
            (conversation) => _buildConversationTile(
              context,
              conversation,
              currentUserId,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'ALL CHATS',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(
    BuildContext context,
    List<Conversation> conversations,
    String currentUserId,
  ) {
    final unpinnedConversations =
        conversations.where((c) => !c.isPinned).toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final conversation = conversations.any((c) => c.isPinned)
              ? unpinnedConversations[index]
              : conversations[index];
          return _buildConversationTile(context, conversation, currentUserId);
        },
        childCount: conversations.any((c) => c.isPinned)
            ? unpinnedConversations.length
            : conversations.length,
      ),
    );
  }

  Widget _buildConversationTile(
    BuildContext context,
    Conversation conversation,
    String currentUserId,
  ) {
    return Dismissible(
      key: Key(conversation.id),
      background: Container(
        color: AppColors.success,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.archive, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Archive
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Chat archived'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {},
              ),
            ),
          );
          return false;
        } else {
          // Delete - show confirmation
          return await _showDeleteConfirmation(context);
        }
      },
      child: ConversationTile(
        conversation: conversation,
        currentUserId: currentUserId,
        onTap: () => context.push('/chat/${conversation.id}'),
        onLongPress: () =>
            _showConversationOptions(context, conversation, currentUserId),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete chat?'),
            content: const Text(
                'This will delete all messages in this chat. This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showConversationOptions(
    BuildContext context,
    Conversation conversation,
    String currentUserId,
  ) {
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

              // Conversation header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        _getInitials(conversation.displayName(currentUserId)),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        conversation.displayName(currentUserId),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Options
              ListTile(
                leading: Icon(
                  conversation.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                title: Text(conversation.isPinned ? 'Unpin chat' : 'Pin chat'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(conversation.isPinned
                            ? 'Chat unpinned'
                            : 'Chat pinned')),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  conversation.isMuted
                      ? Icons.notifications
                      : Icons.notifications_off_outlined,
                ),
                title: Text(
                    conversation.isMuted ? 'Unmute' : 'Mute notifications'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(conversation.isMuted
                            ? 'Notifications unmuted'
                            : 'Notifications muted')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Archive chat'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat archived')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.mark_chat_read_outlined),
                title: Text(conversation.hasUnread
                    ? 'Mark as read'
                    : 'Mark as unread'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: AppColors.error),
                title: Text('Delete chat',
                    style: TextStyle(color: AppColors.error)),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final confirm = await _showDeleteConfirmation(context);
                  if (confirm) {
                    // TODO: Delete conversation
                  }
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'new_group':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New group coming soon')),
        );
        break;
      case 'archived':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archived chats coming soon')),
        );
        break;
      case 'settings':
        context.push('/settings');
        break;
    }
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                context.read<ChatBloc>().add(const ChatLoadConversations());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
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
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No conversations yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new chat to begin messaging with friends and family',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey500,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/new-chat'),
              icon: const Icon(Icons.add),
              label: const Text('Start a chat'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.grey600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for a different name or message',
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grey100,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.grey700),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.grey700,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
