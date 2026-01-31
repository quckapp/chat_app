// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) =>
    WebSocketMessage(
      topic: json['topic'] as String,
      event: json['event'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      ref: json['ref'] as String?,
      joinRef: json['joinRef'] as String?,
    );

Map<String, dynamic> _$WebSocketMessageToJson(WebSocketMessage instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'event': instance.event,
      'payload': instance.payload,
      'ref': instance.ref,
      'joinRef': instance.joinRef,
    };

PhoenixReplyDto _$PhoenixReplyDtoFromJson(Map<String, dynamic> json) =>
    PhoenixReplyDto(
      status: json['status'] as String,
      response: json['response'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PhoenixReplyDtoToJson(PhoenixReplyDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'response': instance.response,
    };

TypingEventDto _$TypingEventDtoFromJson(Map<String, dynamic> json) =>
    TypingEventDto(
      conversationId: json['conversationId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TypingEventDtoToJson(TypingEventDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'userId': instance.userId,
      'userName': instance.userName,
      'timestamp': instance.timestamp.toIso8601String(),
    };

ReadReceiptDto _$ReadReceiptDtoFromJson(Map<String, dynamic> json) =>
    ReadReceiptDto(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      readAt: DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$ReadReceiptDtoToJson(ReadReceiptDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageId': instance.messageId,
      'userId': instance.userId,
      'readAt': instance.readAt.toIso8601String(),
    };

PresenceUpdateDto _$PresenceUpdateDtoFromJson(Map<String, dynamic> json) =>
    PresenceUpdateDto(
      odataEtag: json['odataEtag'] as String? ?? '',
      odataId: json['odataId'] as String? ?? '',
      userId: json['userId'] as String,
      status: json['status'] as String,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PresenceUpdateDtoToJson(PresenceUpdateDto instance) =>
    <String, dynamic>{
      'odataEtag': instance.odataEtag,
      'odataId': instance.odataId,
      'userId': instance.userId,
      'status': instance.status,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'metadata': instance.metadata,
    };

ReactionEventDto _$ReactionEventDtoFromJson(Map<String, dynamic> json) =>
    ReactionEventDto(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
      userId: json['userId'] as String,
      emoji: json['emoji'] as String,
      action: json['action'] as String,
    );

Map<String, dynamic> _$ReactionEventDtoToJson(ReactionEventDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageId': instance.messageId,
      'userId': instance.userId,
      'emoji': instance.emoji,
      'action': instance.action,
    };

MessageDeletedDto _$MessageDeletedDtoFromJson(Map<String, dynamic> json) =>
    MessageDeletedDto(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
      deletedBy: json['deletedBy'] as String,
      deletedAt: DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$MessageDeletedDtoToJson(MessageDeletedDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageId': instance.messageId,
      'deletedBy': instance.deletedBy,
      'deletedAt': instance.deletedAt.toIso8601String(),
    };

MessageEditedDto _$MessageEditedDtoFromJson(Map<String, dynamic> json) =>
    MessageEditedDto(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
      content: json['content'] as String,
      editedBy: json['editedBy'] as String,
      editedAt: DateTime.parse(json['editedAt'] as String),
    );

Map<String, dynamic> _$MessageEditedDtoToJson(MessageEditedDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'messageId': instance.messageId,
      'content': instance.content,
      'editedBy': instance.editedBy,
      'editedAt': instance.editedAt.toIso8601String(),
    };
