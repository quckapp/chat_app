// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastEventDto _$BroadcastEventDtoFromJson(Map<String, dynamic> json) =>
    BroadcastEventDto(
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      targetUserIds: (json['target_user_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BroadcastEventDtoToJson(BroadcastEventDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
      'target_user_ids': instance.targetUserIds,
    };

EventDto _$EventDtoFromJson(Map<String, dynamic> json) => EventDto(
      id: json['id'] as String,
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EventDtoToJson(EventDto instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'payload': instance.payload,
      'created_at': instance.createdAt?.toIso8601String(),
    };
