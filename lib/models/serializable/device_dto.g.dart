// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceDto _$DeviceDtoFromJson(Map<String, dynamic> json) => DeviceDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      deviceToken: json['device_token'] as String,
      platform: json['platform'] as String,
      deviceName: json['device_name'] as String?,
      lastActiveAt: json['last_active_at'] == null
          ? null
          : DateTime.parse(json['last_active_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DeviceDtoToJson(DeviceDto instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'device_token': instance.deviceToken,
      'platform': instance.platform,
      'device_name': instance.deviceName,
      'last_active_at': instance.lastActiveAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

RegisterDeviceDto _$RegisterDeviceDtoFromJson(Map<String, dynamic> json) =>
    RegisterDeviceDto(
      deviceToken: json['device_token'] as String,
      platform: json['platform'] as String,
      deviceName: json['device_name'] as String?,
    );

Map<String, dynamic> _$RegisterDeviceDtoToJson(RegisterDeviceDto instance) =>
    <String, dynamic>{
      'device_token': instance.deviceToken,
      'platform': instance.platform,
      'device_name': instance.deviceName,
    };

PreferenceDto _$PreferenceDtoFromJson(Map<String, dynamic> json) =>
    PreferenceDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      channelId: json['channel_id'] as String?,
      muteUntil: json['mute_until'] == null
          ? null
          : DateTime.parse(json['mute_until'] as String),
      pushEnabled: json['push_enabled'] as bool? ?? true,
      emailEnabled: json['email_enabled'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$PreferenceDtoToJson(PreferenceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'channel_id': instance.channelId,
      'mute_until': instance.muteUntil?.toIso8601String(),
      'push_enabled': instance.pushEnabled,
      'email_enabled': instance.emailEnabled,
      'sound_enabled': instance.soundEnabled,
    };

UpdatePreferenceDto _$UpdatePreferenceDtoFromJson(Map<String, dynamic> json) =>
    UpdatePreferenceDto(
      channelId: json['channel_id'] as String?,
      muteUntil: json['mute_until'] == null
          ? null
          : DateTime.parse(json['mute_until'] as String),
      pushEnabled: json['push_enabled'] as bool?,
      emailEnabled: json['email_enabled'] as bool?,
      soundEnabled: json['sound_enabled'] as bool?,
    );

Map<String, dynamic> _$UpdatePreferenceDtoToJson(
        UpdatePreferenceDto instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'mute_until': instance.muteUntil?.toIso8601String(),
      'push_enabled': instance.pushEnabled,
      'email_enabled': instance.emailEnabled,
      'sound_enabled': instance.soundEnabled,
    };
