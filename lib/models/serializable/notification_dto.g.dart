// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    NotificationDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      channelId: json['channel_id'] as String?,
      messageId: json['message_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$NotificationDtoToJson(NotificationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'is_read': instance.isRead,
      'channel_id': instance.channelId,
      'message_id': instance.messageId,
      'created_at': instance.createdAt?.toIso8601String(),
    };

MarkReadDto _$MarkReadDtoFromJson(Map<String, dynamic> json) => MarkReadDto(
      notificationIds: (json['notification_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MarkReadDtoToJson(MarkReadDto instance) =>
    <String, dynamic>{
      'notification_ids': instance.notificationIds,
    };
