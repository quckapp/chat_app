import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/storage/local_storage_service.dart';
import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../models/participant.dart';
import '../../repositories/conversation_repository.dart';
import '../../services/chat_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  final ConversationRepository _conversationRepository;
  final LocalStorageService? _localStorageService;
  final Map<String, StreamSubscription<Message>> _messageSubscriptions = {};
  final Map<String, StreamSubscription<Map<String, dynamic>>> _eventSubscriptions = {};

  ChatBloc({
    required ChatService chatService,
    ConversationRepository? conversationRepository,
    LocalStorageService? localStorageService,
  })  : _chatService = chatService,
        _conversationRepository = conversationRepository ?? ConversationRepository(),
        _localStorageService = localStorageService,
        super(const ChatState()) {
    on<ChatLoadConversations>(_onLoadConversations);
    on<ChatJoinConversation>(_onJoinConversation);
    on<ChatLeaveConversation>(_onLeaveConversation);
    on<ChatSendMessage>(_onSendMessage);
    on<ChatMarkAsRead>(_onMarkAsRead);
    on<ChatAddReaction>(_onAddReaction);
    on<ChatRemoveReaction>(_onRemoveReaction);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatMessageEdited>(_onMessageEdited);
    on<ChatMessageDeleted>(_onMessageDeleted);
    on<ChatConversationsLoaded>(_onConversationsLoaded);
    on<ChatSetActiveConversation>(_onSetActiveConversation);
    on<ChatClearError>(_onClearError);
  }

  Future<void> _onLoadConversations(
    ChatLoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading, error: null));

    // Step 1: Load cached conversations first (instant display)
    if (_localStorageService != null && _localStorageService!.isInitialized) {
      try {
        final cachedConversations = await _localStorageService!.getConversations();
        if (cachedConversations.isNotEmpty) {
          debugPrint('ChatBloc: Loaded ${cachedConversations.length} cached conversations');
          emit(state.copyWith(
            status: ChatStatus.loaded,
            conversations: cachedConversations,
          ));
        }
      } catch (e) {
        debugPrint('ChatBloc: Failed to load cached conversations: $e');
      }
    }

    // Step 2: Fetch from API
    try {
      debugPrint('ChatBloc: Loading conversations from API...');
      final result = await _conversationRepository.getConversations();
      debugPrint('ChatBloc: Got ${result.conversations.length} conversations');

      // Convert DTOs to domain models
      final conversations = result.conversations.map((dto) {
        // Debug: Log participant data to verify phone numbers
        if (dto.participants != null && dto.participants!.isNotEmpty) {
          for (final p in dto.participants!) {
            debugPrint('ChatBloc: Participant ${p.userId} - displayName: ${p.name}, phoneNumber: ${p.phoneNumber}, phone: ${p.phone}, effective: ${p.effectivePhoneNumber}');
          }
        }
        return Conversation(
          id: dto.id,
          type: dto.type,
          name: dto.name,
          description: dto.description,
          avatar: dto.avatar,
          participants: dto.participants?.map((p) {
            return Participant(
              id: p.userId ?? '',
              displayName: p.name,
              avatar: p.avatar,
              role: ParticipantRole.fromString(p.role),
              joinedAt: p.joinedAt ?? DateTime.now(),
              phoneNumber: p.effectivePhoneNumber,
            );
          }).toList() ?? [],
          lastMessage: dto.lastMessage != null
              ? Message(
                  id: dto.lastMessage!.id,
                  conversationId: dto.id,
                  senderId: dto.lastMessage!.senderId,
                  type: dto.lastMessage!.type,
                  content: dto.lastMessage!.content,
                  createdAt: dto.lastMessage!.createdAt,
                )
              : null,
          unreadCount: dto.unreadCount,
          isMuted: dto.isMuted,
          isPinned: dto.isPinned,
          createdAt: dto.createdAt ?? DateTime.now(),
          updatedAt: dto.updatedAt,
        );
      }).toList();

      debugPrint('ChatBloc: Converted ${conversations.length} conversations');

      // Step 3: Save to local storage
      if (_localStorageService != null && _localStorageService!.isInitialized) {
        try {
          await _localStorageService!.saveConversations(conversations);
          await _localStorageService!.setLastConversationsSyncTime(DateTime.now());
        } catch (e) {
          debugPrint('ChatBloc: Failed to cache conversations: $e');
        }
      }

      emit(state.copyWith(
        status: ChatStatus.loaded,
        conversations: conversations,
      ));
    } catch (e, stackTrace) {
      debugPrint('ChatBloc: Failed to load conversations: $e');
      debugPrint('ChatBloc: Stack trace: $stackTrace');

      // If we have cached data, don't show error state
      if (state.conversations.isNotEmpty) {
        debugPrint('ChatBloc: Using cached data due to API failure');
        emit(state.copyWith(status: ChatStatus.loaded));
      } else {
        emit(state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to load conversations: $e',
        ));
      }
    }
  }

  Future<void> _onJoinConversation(
    ChatJoinConversation event,
    Emitter<ChatState> emit,
  ) async {
    final conversationId = event.conversationId;

    // Load cached messages first
    final cachedMessages = await _loadCachedMessages(conversationId);
    if (cachedMessages.isNotEmpty) {
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[conversationId] = cachedMessages;
      emit(state.copyWith(
        messages: updatedMessages,
        activeConversationId: conversationId,
      ));
      debugPrint('ChatBloc: Loaded ${cachedMessages.length} cached messages');
    }

    final joined = await _chatService.joinConversation(conversationId);

    if (joined) {
      // Subscribe to message stream
      _messageSubscriptions[conversationId] = _chatService
          .getMessageStream(conversationId)
          .listen((message) {
        add(ChatMessageReceived(conversationId: conversationId, message: message));
      });

      // Subscribe to event stream
      _eventSubscriptions[conversationId] = _chatService
          .getEventStream(conversationId)
          .listen((event) {
        _handleChatEvent(conversationId, event);
      });

      emit(state.copyWith(activeConversationId: conversationId));
      debugPrint('ChatBloc: Joined conversation $conversationId');
    }
  }

  void _onLeaveConversation(
    ChatLeaveConversation event,
    Emitter<ChatState> emit,
  ) {
    final conversationId = event.conversationId;

    _messageSubscriptions[conversationId]?.cancel();
    _messageSubscriptions.remove(conversationId);

    _eventSubscriptions[conversationId]?.cancel();
    _eventSubscriptions.remove(conversationId);

    _chatService.leaveConversation(conversationId);

    if (state.activeConversationId == conversationId) {
      emit(state.copyWith(activeConversationId: null));
    }

    debugPrint('ChatBloc: Left conversation $conversationId');
  }

  Future<void> _onSendMessage(
    ChatSendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final clientId = DateTime.now().millisecondsSinceEpoch.toString();

    // Add pending message (optimistic update)
    final pendingMessage = Message(
      id: clientId,
      conversationId: event.conversationId,
      senderId: '',
      type: event.type,
      content: event.content,
      replyTo: event.replyTo,
      createdAt: DateTime.now(),
      isPending: true,
      clientId: clientId,
    );

    _addMessageToState(emit, event.conversationId, pendingMessage);

    // Send to server
    final reply = await _chatService.sendMessage(
      conversationId: event.conversationId,
      content: event.content,
      type: event.type,
      replyTo: event.replyTo,
      clientId: clientId,
    );

    if (!reply.isOk) {
      _updateMessageStatusInState(emit, event.conversationId, clientId, hasFailed: true);
    }
  }

  Future<void> _onMarkAsRead(
    ChatMarkAsRead event,
    Emitter<ChatState> emit,
  ) async {
    await _chatService.markAsRead(
      conversationId: event.conversationId,
      messageId: event.messageId,
    );

    // Clear unread count
    final updatedCounts = Map<String, int>.from(state.unreadCounts);
    updatedCounts.remove(event.conversationId);
    emit(state.copyWith(unreadCounts: updatedCounts));
  }

  Future<void> _onAddReaction(
    ChatAddReaction event,
    Emitter<ChatState> emit,
  ) async {
    await _chatService.addReaction(
      conversationId: event.conversationId,
      messageId: event.messageId,
      emoji: event.emoji,
    );
  }

  Future<void> _onRemoveReaction(
    ChatRemoveReaction event,
    Emitter<ChatState> emit,
  ) async {
    await _chatService.removeReaction(
      conversationId: event.conversationId,
      messageId: event.messageId,
      emoji: event.emoji,
    );
  }

  void _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final conversationId = event.conversationId;
    final message = event.message;

    // Check if this is confirming a pending message
    if (message.clientId != null) {
      final messages = List<Message>.from(state.messages[conversationId] ?? []);
      final pendingIndex = messages.indexWhere((m) => m.clientId == message.clientId);

      if (pendingIndex >= 0) {
        messages[pendingIndex] = message;
        final updatedMessages = Map<String, List<Message>>.from(state.messages);
        updatedMessages[conversationId] = messages;
        emit(state.copyWith(messages: updatedMessages));

        // Persist to local storage
        _persistMessage(conversationId, message);
        return;
      }
    }

    _addMessageToState(emit, conversationId, message);

    // Persist to local storage
    _persistMessage(conversationId, message);

    // Update unread count if not active conversation
    if (state.activeConversationId != conversationId) {
      final updatedCounts = Map<String, int>.from(state.unreadCounts);
      updatedCounts[conversationId] = (updatedCounts[conversationId] ?? 0) + 1;
      emit(state.copyWith(unreadCounts: updatedCounts));
    }
  }

  /// Persist a message to local storage
  Future<void> _persistMessage(String conversationId, Message message) async {
    if (_localStorageService == null || !_localStorageService!.isInitialized) return;

    try {
      await _localStorageService!.addMessage(conversationId, message);
    } catch (e) {
      debugPrint('ChatBloc: Failed to persist message: $e');
    }
  }

  /// Persist a conversation update to local storage
  Future<void> _persistConversation(Conversation conversation) async {
    if (_localStorageService == null || !_localStorageService!.isInitialized) return;

    try {
      await _localStorageService!.saveConversation(conversation);
    } catch (e) {
      debugPrint('ChatBloc: Failed to persist conversation: $e');
    }
  }

  /// Load cached messages for a conversation
  Future<List<Message>> _loadCachedMessages(String conversationId) async {
    if (_localStorageService == null || !_localStorageService!.isInitialized) {
      return [];
    }

    try {
      return await _localStorageService!.getMessages(conversationId);
    } catch (e) {
      debugPrint('ChatBloc: Failed to load cached messages: $e');
      return [];
    }
  }

  void _onMessageEdited(
    ChatMessageEdited event,
    Emitter<ChatState> emit,
  ) {
    final messages = List<Message>.from(state.messages[event.conversationId] ?? []);
    final index = messages.indexWhere((m) => m.id == event.messageId);
    if (index >= 0) {
      messages[index] = messages[index].copyWith(
        content: event.content,
        isEdited: true,
      );
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[event.conversationId] = messages;
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  void _onMessageDeleted(
    ChatMessageDeleted event,
    Emitter<ChatState> emit,
  ) {
    final messages = List<Message>.from(state.messages[event.conversationId] ?? []);
    final index = messages.indexWhere((m) => m.id == event.messageId);
    if (index >= 0) {
      messages[index] = messages[index].copyWith(isDeleted: true);
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[event.conversationId] = messages;
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  void _onConversationsLoaded(
    ChatConversationsLoaded event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(
      status: ChatStatus.loaded,
      conversations: event.conversations,
    ));
  }

  void _onSetActiveConversation(
    ChatSetActiveConversation event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(activeConversationId: event.conversationId));
  }

  void _onClearError(
    ChatClearError event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(error: null));
  }

  void _handleChatEvent(String conversationId, Map<String, dynamic> event) {
    final eventType = event['event'] as String?;
    final payload = event['payload'] as Map<String, dynamic>?;

    if (eventType == null || payload == null) return;

    switch (eventType) {
      case 'message_edited':
        add(ChatMessageEdited(
          conversationId: conversationId,
          messageId: payload['messageId'] as String,
          content: payload['content'] as String,
        ));
        break;
      case 'message_deleted':
        add(ChatMessageDeleted(
          conversationId: conversationId,
          messageId: payload['messageId'] as String,
        ));
        break;
    }
  }

  void _addMessageToState(Emitter<ChatState> emit, String conversationId, Message message) {
    final messages = List<Message>.from(state.messages[conversationId] ?? []);
    messages.add(message);
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final updatedMessages = Map<String, List<Message>>.from(state.messages);
    updatedMessages[conversationId] = messages;
    emit(state.copyWith(messages: updatedMessages));
  }

  void _updateMessageStatusInState(
    Emitter<ChatState> emit,
    String conversationId,
    String clientId, {
    bool hasFailed = false,
  }) {
    final messages = List<Message>.from(state.messages[conversationId] ?? []);
    final index = messages.indexWhere((m) => m.clientId == clientId);
    if (index >= 0) {
      messages[index] = messages[index].copyWith(
        isPending: false,
        hasFailed: hasFailed,
      );
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[conversationId] = messages;
      emit(state.copyWith(messages: updatedMessages));
    }
  }

  @override
  Future<void> close() {
    for (final subscription in _messageSubscriptions.values) {
      subscription.cancel();
    }
    _messageSubscriptions.clear();

    for (final subscription in _eventSubscriptions.values) {
      subscription.cancel();
    }
    _eventSubscriptions.clear();

    return super.close();
  }
}
