// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderDto _$ReminderDtoFromJson(Map<String, dynamic> json) => ReminderDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      messageId: json['message_id'] as String,
      channelId: json['channel_id'] as String,
      note: json['note'] as String?,
      remindAt: json['remind_at'] == null
          ? null
          : DateTime.parse(json['remind_at'] as String),
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ReminderDtoToJson(ReminderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'message_id': instance.messageId,
      'channel_id': instance.channelId,
      'note': instance.note,
      'remind_at': instance.remindAt?.toIso8601String(),
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };

CreateReminderDto _$CreateReminderDtoFromJson(Map<String, dynamic> json) =>
    CreateReminderDto(
      messageId: json['message_id'] as String,
      channelId: json['channel_id'] as String,
      note: json['note'] as String?,
      remindAt: DateTime.parse(json['remind_at'] as String),
    );

Map<String, dynamic> _$CreateReminderDtoToJson(CreateReminderDto instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'channel_id': instance.channelId,
      'note': instance.note,
      'remind_at': instance.remindAt.toIso8601String(),
    };

UpdateReminderDto _$UpdateReminderDtoFromJson(Map<String, dynamic> json) =>
    UpdateReminderDto(
      note: json['note'] as String?,
      remindAt: json['remind_at'] == null
          ? null
          : DateTime.parse(json['remind_at'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UpdateReminderDtoToJson(UpdateReminderDto instance) =>
    <String, dynamic>{
      'note': instance.note,
      'remind_at': instance.remindAt?.toIso8601String(),
      'status': instance.status,
    };
