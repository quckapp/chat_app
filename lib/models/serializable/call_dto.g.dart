// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallDto _$CallDtoFromJson(Map<String, dynamic> json) => CallDto(
      id: json['id'] as String,
      callerId: json['caller_id'] as String,
      calleeId: json['callee_id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CallDtoToJson(CallDto instance) => <String, dynamic>{
      'id': instance.id,
      'caller_id': instance.callerId,
      'callee_id': instance.calleeId,
      'type': instance.type,
      'status': instance.status,
      'started_at': instance.startedAt?.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'duration': instance.duration,
    };

InitiateCallDto _$InitiateCallDtoFromJson(Map<String, dynamic> json) =>
    InitiateCallDto(
      calleeId: json['callee_id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$InitiateCallDtoToJson(InitiateCallDto instance) =>
    <String, dynamic>{
      'callee_id': instance.calleeId,
      'type': instance.type,
    };
