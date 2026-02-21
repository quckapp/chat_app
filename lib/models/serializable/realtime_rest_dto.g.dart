// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_rest_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealtimeDeviceDto _$RealtimeDeviceDtoFromJson(Map<String, dynamic> json) =>
    RealtimeDeviceDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      deviceType: json['device_type'] as String,
      connectedAt: json['connected_at'] == null
          ? null
          : DateTime.parse(json['connected_at'] as String),
    );

Map<String, dynamic> _$RealtimeDeviceDtoToJson(RealtimeDeviceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'device_type': instance.deviceType,
      'connected_at': instance.connectedAt?.toIso8601String(),
    };

SignalingDto _$SignalingDtoFromJson(Map<String, dynamic> json) => SignalingDto(
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      targetUserId: json['target_user_id'] as String,
    );

Map<String, dynamic> _$SignalingDtoToJson(SignalingDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
      'target_user_id': instance.targetUserId,
    };
