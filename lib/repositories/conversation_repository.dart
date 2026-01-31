import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/conversation_dto.dart';
import '../models/serializable/message_dto.dart';

/// Repository for conversation operations
class ConversationRepository {
  final RestClient _client;

  ConversationRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.messageServiceBaseUrl);

  /// Get all conversations for current user
  Future<ConversationListDto> getConversations({
    int? limit,
    String? cursor,
    bool? includeArchived,
  }) async {
    return _client.get(
      '/conversations',
      queryParams: {
        if (limit != null) 'limit': limit,
        if (cursor != null) 'cursor': cursor,
        if (includeArchived != null) 'includeArchived': includeArchived,
      },
      fromJson: ConversationListDto.fromJson,
    );
  }

  /// Get a single conversation by ID
  Future<ConversationDto> getConversation(String id) async {
    return _client.get(
      '/conversations/$id',
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Create a new conversation
  Future<ConversationDto> createConversation(CreateConversationDto data) async {
    return _client.post(
      '/conversations',
      data: data.toJson(),
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Create or get direct conversation with user
  Future<ConversationDto> getOrCreateDirect(String userId) async {
    return _client.post(
      '/conversations/direct',
      data: {'userId': userId},
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Update conversation
  Future<ConversationDto> updateConversation(
    String id,
    UpdateConversationDto data,
  ) async {
    return _client.patch(
      '/conversations/$id',
      data: data.toJson(),
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Delete/leave conversation
  Future<void> deleteConversation(String id) async {
    await _client.delete('/conversations/$id');
  }

  /// Add participants to group conversation
  Future<ConversationDto> addParticipants(
    String conversationId,
    List<String> userIds,
  ) async {
    return _client.post(
      '/conversations/$conversationId/participants',
      data: {'userIds': userIds},
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Remove participant from group conversation
  Future<void> removeParticipant(String conversationId, String userId) async {
    await _client.delete('/conversations/$conversationId/participants/$userId');
  }

  /// Get messages for a conversation
  Future<MessageListDto> getMessages(
    String conversationId, {
    int? limit,
    String? before,
    String? after,
  }) async {
    return _client.get(
      '/conversations/$conversationId/messages',
      queryParams: {
        if (limit != null) 'limit': limit,
        if (before != null) 'before': before,
        if (after != null) 'after': after,
      },
      fromJson: MessageListDto.fromJson,
    );
  }

  /// Send message to conversation (REST fallback)
  Future<MessageDto> sendMessage(
    String conversationId,
    SendMessageDto message,
  ) async {
    return _client.post(
      '/conversations/$conversationId/messages',
      data: message.toJson(),
      fromJson: MessageDto.fromJson,
    );
  }

  /// Edit a message
  Future<MessageDto> editMessage(
    String conversationId,
    String messageId,
    String content,
  ) async {
    return _client.patch(
      '/conversations/$conversationId/messages/$messageId',
      data: {'content': content},
      fromJson: MessageDto.fromJson,
    );
  }

  /// Delete a message
  Future<void> deleteMessage(String conversationId, String messageId) async {
    await _client.delete('/conversations/$conversationId/messages/$messageId');
  }

  /// Mark messages as read
  Future<void> markAsRead(String conversationId, String messageId) async {
    await _client.postVoid(
      '/conversations/$conversationId/messages/$messageId/read',
    );
  }

  /// Mark all messages in conversation as read
  Future<void> markAllAsRead(String conversationId) async {
    await _client.postVoid('/conversations/$conversationId/read');
  }

  /// Mute conversation
  Future<ConversationDto> muteConversation(
    String id, {
    Duration? duration,
  }) async {
    return _client.post(
      '/conversations/$id/mute',
      data: {
        if (duration != null) 'durationMinutes': duration.inMinutes,
      },
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Unmute conversation
  Future<ConversationDto> unmuteConversation(String id) async {
    return _client.post(
      '/conversations/$id/unmute',
      data: {},
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Pin conversation
  Future<ConversationDto> pinConversation(String id) async {
    return _client.post(
      '/conversations/$id/pin',
      data: {},
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Unpin conversation
  Future<ConversationDto> unpinConversation(String id) async {
    return _client.post(
      '/conversations/$id/unpin',
      data: {},
      fromJson: ConversationDto.fromJson,
    );
  }

  /// Archive conversation
  Future<void> archiveConversation(String id) async {
    await _client.postVoid('/conversations/$id/archive');
  }

  /// Unarchive conversation
  Future<void> unarchiveConversation(String id) async {
    await _client.postVoid('/conversations/$id/unarchive');
  }

  /// Search messages in conversation
  Future<MessageListDto> searchMessages(
    String conversationId,
    String query, {
    int? limit,
    String? cursor,
  }) async {
    return _client.get(
      '/conversations/$conversationId/messages/search',
      queryParams: {
        'q': query,
        if (limit != null) 'limit': limit,
        if (cursor != null) 'cursor': cursor,
      },
      fromJson: MessageListDto.fromJson,
    );
  }
}
