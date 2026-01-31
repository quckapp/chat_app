import 'package:json_annotation/json_annotation.dart';

part 'websocket_dto.g.dart';

/// WebSocket message envelope
@JsonSerializable()
class WebSocketMessage {
  final String topic;
  final String event;
  final Map<String, dynamic> payload;
  final String? ref;
  final String? joinRef;

  const WebSocketMessage({
    required this.topic,
    required this.event,
    required this.payload,
    this.ref,
    this.joinRef,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);
}

/// Phoenix channel reply
@JsonSerializable()
class PhoenixReplyDto {
  final String status;
  final Map<String, dynamic>? response;

  const PhoenixReplyDto({
    required this.status,
    this.response,
  });

  factory PhoenixReplyDto.fromJson(Map<String, dynamic> json) =>
      _$PhoenixReplyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PhoenixReplyDtoToJson(this);

  bool get isOk => status == 'ok';
  bool get isError => status == 'error';
}

/// Typing event payload
@JsonSerializable()
class TypingEventDto {
  final String conversationId;
  final String userId;
  final String? userName;
  final DateTime timestamp;

  const TypingEventDto({
    required this.conversationId,
    required this.userId,
    this.userName,
    required this.timestamp,
  });

  factory TypingEventDto.fromJson(Map<String, dynamic> json) =>
      _$TypingEventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TypingEventDtoToJson(this);
}

/// Read receipt event payload
@JsonSerializable()
class ReadReceiptDto {
  final String conversationId;
  final String messageId;
  final String userId;
  final DateTime readAt;

  const ReadReceiptDto({
    required this.conversationId,
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  factory ReadReceiptDto.fromJson(Map<String, dynamic> json) =>
      _$ReadReceiptDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReadReceiptDtoToJson(this);
}

/// Presence update event
@JsonSerializable()
class PresenceUpdateDto {
  final String odataEtag;

  final String odataId;

  final String userId;
  final String status;
  final DateTime? lastSeen;
  final Map<String, dynamic>? metadata;

  const PresenceUpdateDto({
    this.odataEtag = '',
    this.odataId = '',
    required this.userId,
    required this.status,
    this.lastSeen,
    this.metadata,
  });

  factory PresenceUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$PresenceUpdateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PresenceUpdateDtoToJson(this);
}

/// Reaction event payload
@JsonSerializable()
class ReactionEventDto {
  final String conversationId;
  final String messageId;
  final String userId;
  final String emoji;
  final String action; // 'add' or 'remove'

  const ReactionEventDto({
    required this.conversationId,
    required this.messageId,
    required this.userId,
    required this.emoji,
    required this.action,
  });

  factory ReactionEventDto.fromJson(Map<String, dynamic> json) =>
      _$ReactionEventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReactionEventDtoToJson(this);
}

/// Message deleted event
@JsonSerializable()
class MessageDeletedDto {
  final String conversationId;
  final String messageId;
  final String deletedBy;
  final DateTime deletedAt;

  const MessageDeletedDto({
    required this.conversationId,
    required this.messageId,
    required this.deletedBy,
    required this.deletedAt,
  });

  factory MessageDeletedDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDeletedDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDeletedDtoToJson(this);
}

/// Message edited event
@JsonSerializable()
class MessageEditedDto {
  final String conversationId;
  final String messageId;
  final String content;
  final String editedBy;
  final DateTime editedAt;

  const MessageEditedDto({
    required this.conversationId,
    required this.messageId,
    required this.content,
    required this.editedBy,
    required this.editedAt,
  });

  factory MessageEditedDto.fromJson(Map<String, dynamic> json) =>
      _$MessageEditedDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageEditedDtoToJson(this);
}
