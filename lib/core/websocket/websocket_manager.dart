import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/serializable/websocket_dto.dart';
import '../../models/serializable/message_dto.dart';
import '../../models/serializable/presence_dto.dart';
import '../constants/websocket_constants.dart';
import 'phoenix_socket.dart';
import 'phoenix_channel.dart';

/// Typed WebSocket event
sealed class WebSocketEvent {}

class MessageReceivedEvent extends WebSocketEvent {
  final MessageDto message;
  MessageReceivedEvent(this.message);
}

class MessageEditedEvent extends WebSocketEvent {
  final MessageEditedDto data;
  MessageEditedEvent(this.data);
}

class MessageDeletedEvent extends WebSocketEvent {
  final MessageDeletedDto data;
  MessageDeletedEvent(this.data);
}

class ReactionEvent extends WebSocketEvent {
  final ReactionEventDto data;
  ReactionEvent(this.data);
}

class TypingStartEvent extends WebSocketEvent {
  final TypingEventDto data;
  TypingStartEvent(this.data);
}

class TypingStopEvent extends WebSocketEvent {
  final TypingEventDto data;
  TypingStopEvent(this.data);
}

class ReadReceiptEvent extends WebSocketEvent {
  final ReadReceiptDto data;
  ReadReceiptEvent(this.data);
}

class PresenceChangedEvent extends WebSocketEvent {
  final PresenceUpdateDto data;
  PresenceChangedEvent(this.data);
}

class ConnectionStateEvent extends WebSocketEvent {
  final SocketState state;
  ConnectionStateEvent(this.state);
}

class ErrorEvent extends WebSocketEvent {
  final String message;
  ErrorEvent(this.message);
}

/// Manages WebSocket connections with typed events
class WebSocketManager {
  final PhoenixSocket _socket;
  final StreamController<WebSocketEvent> _eventController =
      StreamController<WebSocketEvent>.broadcast();

  final Map<String, PhoenixChannel> _conversationChannels = {};
  PhoenixChannel? _userChannel;

  StreamSubscription? _stateSubscription;
  StreamSubscription? _errorSubscription;

  String? _currentUserId;

  WebSocketManager({PhoenixSocket? socket})
      : _socket = socket ?? PhoenixSocket();

  /// Stream of all WebSocket events
  Stream<WebSocketEvent> get events => _eventController.stream;

  /// Stream of specific event type
  Stream<T> on<T extends WebSocketEvent>() =>
      events.where((e) => e is T).cast<T>();

  /// Current connection state
  SocketState get state => _socket.state;

  /// Whether connected
  bool get isConnected => _socket.isConnected;

  /// Connect to WebSocket
  Future<void> connect(String token, String userId) async {
    _currentUserId = userId;

    _stateSubscription?.cancel();
    _stateSubscription = _socket.stateStream.listen((state) {
      _eventController.add(ConnectionStateEvent(state));

      if (state == SocketState.connected) {
        _rejoinChannels();
      }
    });

    _errorSubscription?.cancel();
    _errorSubscription = _socket.errorStream.listen((error) {
      if (error != null) {
        _eventController.add(ErrorEvent(error));
      }
    });

    await _socket.connect(token);

    if (_socket.isConnected) {
      await _joinUserChannel(userId);
    }
  }

  /// Disconnect from WebSocket
  void disconnect() {
    _leaveAllChannels();
    _socket.disconnect();
    _stateSubscription?.cancel();
    _errorSubscription?.cancel();
  }

  /// Update token (for refresh)
  void updateToken(String token) {
    _socket.updateToken(token);
  }

  /// Join a conversation channel
  Future<bool> joinConversation(String conversationId) async {
    if (_conversationChannels.containsKey(conversationId)) {
      return true;
    }

    final channel = _socket.channel('conversation:$conversationId');
    final reply = await channel.join();

    if (reply.isOk) {
      _conversationChannels[conversationId] = channel;
      _setupConversationHandlers(conversationId, channel);
      debugPrint('WebSocketManager: Joined conversation $conversationId');
      return true;
    }

    debugPrint('WebSocketManager: Failed to join conversation $conversationId');
    return false;
  }

  /// Leave a conversation channel
  void leaveConversation(String conversationId) {
    final channel = _conversationChannels.remove(conversationId);
    if (channel != null) {
      channel.leave();
      _socket.removeChannel('conversation:$conversationId');
    }
  }

  /// Send message via WebSocket
  Future<PhoenixReply> sendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
    List<AttachmentDto>? attachments,
    String? replyTo,
    String? clientId,
  }) async {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) {
      return PhoenixReply(status: 'error', response: {'reason': 'not_joined'});
    }

    return channel.push(WebSocketConstants.messageSend, {
      'conversationId': conversationId,
      'type': type,
      'content': content,
      if (attachments != null)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (replyTo != null) 'replyTo': replyTo,
      if (clientId != null) 'clientId': clientId,
    });
  }

  /// Edit message via WebSocket
  Future<PhoenixReply> editMessage({
    required String conversationId,
    required String messageId,
    required String content,
  }) async {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) {
      return PhoenixReply(status: 'error', response: {'reason': 'not_joined'});
    }

    return channel.push(WebSocketConstants.messageEdit, {
      'messageId': messageId,
      'content': content,
    });
  }

  /// Delete message via WebSocket
  Future<PhoenixReply> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) {
      return PhoenixReply(status: 'error', response: {'reason': 'not_joined'});
    }

    return channel.push(WebSocketConstants.messageDelete, {
      'messageId': messageId,
    });
  }

  /// Add reaction via WebSocket
  Future<PhoenixReply> addReaction({
    required String conversationId,
    required String messageId,
    required String emoji,
  }) async {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) {
      return PhoenixReply(status: 'error', response: {'reason': 'not_joined'});
    }

    return channel.push(WebSocketConstants.messageReactionAdd, {
      'messageId': messageId,
      'emoji': emoji,
    });
  }

  /// Remove reaction via WebSocket
  Future<PhoenixReply> removeReaction({
    required String conversationId,
    required String messageId,
    required String emoji,
  }) async {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) {
      return PhoenixReply(status: 'error', response: {'reason': 'not_joined'});
    }

    return channel.push(WebSocketConstants.messageReactionRemove, {
      'messageId': messageId,
      'emoji': emoji,
    });
  }

  /// Mark message as read via WebSocket
  Future<PhoenixReply> markAsRead({
    required String conversationId,
    required String messageId,
  }) async {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) {
      return PhoenixReply(status: 'error', response: {'reason': 'not_joined'});
    }

    return channel.push(WebSocketConstants.messageRead, {
      'messageId': messageId,
      'conversationId': conversationId,
    });
  }

  /// Send typing indicator
  void sendTypingStart(String conversationId) {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) return;

    channel.pushNoReply(WebSocketConstants.typingStart, {
      'conversationId': conversationId,
    });
  }

  /// Stop typing indicator
  void sendTypingStop(String conversationId) {
    final channel = _conversationChannels[conversationId];
    if (channel == null || !channel.isJoined) return;

    channel.pushNoReply(WebSocketConstants.typingStop, {
      'conversationId': conversationId,
    });
  }

  /// Update presence
  void updatePresence(PresenceAvailability availability, {String? statusMessage}) {
    _userChannel?.pushNoReply('presence:update', {
      'availability': availability.name,
      if (statusMessage != null) 'statusMessage': statusMessage,
    });
  }

  Future<void> _joinUserChannel(String userId) async {
    _userChannel = _socket.channel('user:$userId');
    final reply = await _userChannel!.join();

    if (reply.isOk) {
      _setupUserHandlers(_userChannel!);
      debugPrint('WebSocketManager: Joined user channel');
    } else {
      debugPrint('WebSocketManager: Failed to join user channel');
    }
  }

  void _setupUserHandlers(PhoenixChannel channel) {
    // Handle presence updates
    channel.on('presence:update', (payload) {
      try {
        final data = PresenceUpdateDto.fromJson(payload);
        _eventController.add(PresenceChangedEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing presence update: $e');
      }
    });

    // Handle new conversation invites, etc.
    channel.on('conversation:invite', (payload) {
      debugPrint('WebSocketManager: Received conversation invite: $payload');
    });
  }

  void _setupConversationHandlers(String conversationId, PhoenixChannel channel) {
    // New message
    channel.on(WebSocketConstants.messageNew, (payload) {
      try {
        final message = MessageDto.fromJson(payload);
        _eventController.add(MessageReceivedEvent(message));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing message: $e');
      }
    });

    // Message edited
    channel.on(WebSocketConstants.messageEdited, (payload) {
      try {
        final data = MessageEditedDto.fromJson(payload);
        _eventController.add(MessageEditedEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing edited message: $e');
      }
    });

    // Message deleted
    channel.on(WebSocketConstants.messageDeleted, (payload) {
      try {
        final data = MessageDeletedDto.fromJson(payload);
        _eventController.add(MessageDeletedEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing deleted message: $e');
      }
    });

    // Reaction added
    channel.on(WebSocketConstants.messageReactionAdded, (payload) {
      try {
        final data = ReactionEventDto.fromJson({...payload, 'action': 'add'});
        _eventController.add(ReactionEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing reaction: $e');
      }
    });

    // Reaction removed
    channel.on(WebSocketConstants.messageReactionRemoved, (payload) {
      try {
        final data = ReactionEventDto.fromJson({...payload, 'action': 'remove'});
        _eventController.add(ReactionEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing reaction: $e');
      }
    });

    // Read receipt
    channel.on(WebSocketConstants.messageReadEvent, (payload) {
      try {
        final data = ReadReceiptDto.fromJson(payload);
        _eventController.add(ReadReceiptEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing read receipt: $e');
      }
    });

    // Typing start
    channel.on(WebSocketConstants.typingStartEvent, (payload) {
      try {
        final data = TypingEventDto.fromJson(payload);
        _eventController.add(TypingStartEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing typing start: $e');
      }
    });

    // Typing stop
    channel.on(WebSocketConstants.typingStopEvent, (payload) {
      try {
        final data = TypingEventDto.fromJson(payload);
        _eventController.add(TypingStopEvent(data));
      } catch (e) {
        debugPrint('WebSocketManager: Error parsing typing stop: $e');
      }
    });
  }

  void _rejoinChannels() {
    if (_currentUserId != null) {
      _joinUserChannel(_currentUserId!);
    }

    for (final conversationId in _conversationChannels.keys.toList()) {
      joinConversation(conversationId);
    }
  }

  void _leaveAllChannels() {
    _userChannel?.leave();
    _userChannel = null;

    for (final channel in _conversationChannels.values) {
      channel.leave();
    }
    _conversationChannels.clear();
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
