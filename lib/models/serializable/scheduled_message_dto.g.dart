// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledMessageDto _$ScheduledMessageDtoFromJson(Map<String, dynamic> json) =>
    ScheduledMessageDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      content: json['content'] as String,
      scheduledAt: json['scheduled_at'] == null
          ? null
          : DateTime.parse(json['scheduled_at'] as String),
      createdBy: json['created_by'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ScheduledMessageDtoToJson(
        ScheduledMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'content': instance.content,
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CreateScheduledMessageDto _$CreateScheduledMessageDtoFromJson(
        Map<String, dynamic> json) =>
    CreateScheduledMessageDto(
      channelId: json['channel_id'] as String,
      content: json['content'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
    );

Map<String, dynamic> _$CreateScheduledMessageDtoToJson(
        CreateScheduledMessageDto instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'content': instance.content,
      'scheduled_at': instance.scheduledAt.toIso8601String(),
    };
