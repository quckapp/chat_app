// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadDto _$ThreadDtoFromJson(Map<String, dynamic> json) => ThreadDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      parentMessageId: json['parent_message_id'] as String,
      createdBy: json['created_by'] as String,
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      participantCount: (json['participant_count'] as num?)?.toInt() ?? 0,
      lastReplyAt: json['last_reply_at'] == null
          ? null
          : DateTime.parse(json['last_reply_at'] as String),
      isFollowing: json['is_following'] as bool? ?? false,
      isResolved: json['is_resolved'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ThreadDtoToJson(ThreadDto instance) => <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'parent_message_id': instance.parentMessageId,
      'created_by': instance.createdBy,
      'reply_count': instance.replyCount,
      'participant_count': instance.participantCount,
      'last_reply_at': instance.lastReplyAt?.toIso8601String(),
      'is_following': instance.isFollowing,
      'is_resolved': instance.isResolved,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

ThreadReplyDto _$ThreadReplyDtoFromJson(Map<String, dynamic> json) =>
    ThreadReplyDto(
      id: json['id'] as String,
      threadId: json['thread_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      displayName: json['display_name'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ThreadReplyDtoToJson(ThreadReplyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'thread_id': instance.threadId,
      'user_id': instance.userId,
      'content': instance.content,
      'display_name': instance.displayName,
      'avatar': instance.avatar,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CreateThreadDto _$CreateThreadDtoFromJson(Map<String, dynamic> json) =>
    CreateThreadDto(
      channelId: json['channel_id'] as String,
      parentMessageId: json['parent_message_id'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CreateThreadDtoToJson(CreateThreadDto instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'parent_message_id': instance.parentMessageId,
      'content': instance.content,
    };

CreateThreadReplyDto _$CreateThreadReplyDtoFromJson(
        Map<String, dynamic> json) =>
    CreateThreadReplyDto(
      content: json['content'] as String,
    );

Map<String, dynamic> _$CreateThreadReplyDtoToJson(
        CreateThreadReplyDto instance) =>
    <String, dynamic>{
      'content': instance.content,
    };
