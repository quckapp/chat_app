// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => MessageDto(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      replyTo: json['replyTo'] as String?,
      isEdited: json['isEdited'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((e) => ReactionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      readBy:
          (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      clientId: json['clientId'] as String?,
    );

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'type': instance.type,
      'content': instance.content,
      'attachments': instance.attachments,
      'replyTo': instance.replyTo,
      'isEdited': instance.isEdited,
      'isDeleted': instance.isDeleted,
      'reactions': instance.reactions,
      'readBy': instance.readBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'clientId': instance.clientId,
    };

AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) =>
    AttachmentDto(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      name: json['name'] as String?,
      size: (json['size'] as num?)?.toInt(),
      mimeType: json['mimeType'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );

Map<String, dynamic> _$AttachmentDtoToJson(AttachmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'url': instance.url,
      'name': instance.name,
      'size': instance.size,
      'mimeType': instance.mimeType,
      'width': instance.width,
      'height': instance.height,
      'thumbnailUrl': instance.thumbnailUrl,
    };

ReactionDto _$ReactionDtoFromJson(Map<String, dynamic> json) => ReactionDto(
      emoji: json['emoji'] as String,
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$ReactionDtoToJson(ReactionDto instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'userIds': instance.userIds,
      'count': instance.count,
    };

SendMessageDto _$SendMessageDtoFromJson(Map<String, dynamic> json) =>
    SendMessageDto(
      conversationId: json['conversationId'] as String,
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      replyTo: json['replyTo'] as String?,
      clientId: json['clientId'] as String?,
    );

Map<String, dynamic> _$SendMessageDtoToJson(SendMessageDto instance) =>
    <String, dynamic>{
      'conversationId': instance.conversationId,
      'type': instance.type,
      'content': instance.content,
      'attachments': instance.attachments,
      'replyTo': instance.replyTo,
      'clientId': instance.clientId,
    };

MessageListDto _$MessageListDtoFromJson(Map<String, dynamic> json) =>
    MessageListDto(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      nextCursor: json['nextCursor'] as String?,
      prevCursor: json['prevCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageListDtoToJson(MessageListDto instance) =>
    <String, dynamic>{
      'messages': instance.messages,
      'total': instance.total,
      'nextCursor': instance.nextCursor,
      'prevCursor': instance.prevCursor,
      'hasMore': instance.hasMore,
    };
