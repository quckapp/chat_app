// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'huddle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HuddleDto _$HuddleDtoFromJson(Map<String, dynamic> json) => HuddleDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      createdBy: json['created_by'] as String,
      status: json['status'] as String? ?? 'active',
      participantIds: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxParticipants: (json['max_participants'] as num?)?.toInt() ?? 50,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HuddleDtoToJson(HuddleDto instance) => <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'created_by': instance.createdBy,
      'status': instance.status,
      'participant_ids': instance.participantIds,
      'max_participants': instance.maxParticipants,
      'created_at': instance.createdAt?.toIso8601String(),
    };

CreateHuddleDto _$CreateHuddleDtoFromJson(Map<String, dynamic> json) =>
    CreateHuddleDto(
      channelId: json['channel_id'] as String,
    );

Map<String, dynamic> _$CreateHuddleDtoToJson(CreateHuddleDto instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
    };
