import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/user.dart';
import '../../repositories/conversation_repository.dart';
import '../../repositories/user_repository.dart';

/// Screen for starting a new conversation
class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _searchController = TextEditingController();
  final _userRepository = UserRepository();
  final _conversationRepository = ConversationRepository();
  List<User> _searchResults = [];
  bool _isSearching = false;
  bool _isStartingChat = false;
  String? _error;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchUsers(query);
    });
  }

  Future<void> _searchUsers(String query) async {
    debugPrint('NewChatScreen: _searchUsers called with query: "$query"');

    if (query.isEmpty || query.length < 2) {
      debugPrint('NewChatScreen: Query too short, clearing results');
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
    });

    try {
      debugPrint('NewChatScreen: Calling userRepository.searchUsers("$query")');
      final result = await _userRepository.searchUsers(query);
      debugPrint('NewChatScreen: Got ${result.users.length} users, total: ${result.total}');

      for (final user in result.users) {
        debugPrint('NewChatScreen: User found - id: ${user.id}, username: ${user.username}, displayName: ${user.displayName}');
      }

      setState(() {
        _searchResults = result.users.map((dto) => User(
          id: dto.id,
          phoneNumber: '', // Not available in summary
          username: dto.username,
          displayName: dto.displayName,
          avatar: dto.avatar,
          status: UserStatus.fromString(dto.status),
        )).toList();
        _isSearching = false;
      });
      debugPrint('NewChatScreen: setState complete, _searchResults.length = ${_searchResults.length}');
    } catch (e, stackTrace) {
      debugPrint('NewChatScreen: Search error: $e');
      debugPrint('NewChatScreen: Stack trace: $stackTrace');
      setState(() {
        _error = 'Failed to search users';
        _isSearching = false;
      });
    }
  }

  Future<void> _startConversation(User user) async {
    if (_isStartingChat) return;

    setState(() {
      _isStartingChat = true;
    });

    try {
      debugPrint('NewChatScreen: Creating/getting direct conversation with user ${user.id}');
      final conversation = await _conversationRepository.getOrCreateDirect(user.id);
      debugPrint('NewChatScreen: Got conversation ${conversation.id}');

      if (mounted) {
        // Navigate to chat screen
        context.go('/chat/${conversation.id}');
      }
    } catch (e, stackTrace) {
      debugPrint('NewChatScreen: Error starting conversation: $e');
      debugPrint('NewChatScreen: Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start chat: $e')),
        );
        setState(() {
          _isStartingChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by name or username',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchUsers('');
                        },
                      )
                    : null,
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Results
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: Colors.red[600]),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _searchUsers(_searchController.text),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return _buildSuggestionsState();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptySearchState();
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildSuggestionsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Search for users',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find people by name or username',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
        child: user.avatar == null
            ? Text(
                user.initials,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : null,
      ),
      title: Text(user.fullName),
      subtitle: user.username != null ? Text('@${user.username}') : null,
      trailing: _isStartingChat ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ) : null,
      onTap: _isStartingChat ? null : () => _startConversation(user),
    );
  }
}
