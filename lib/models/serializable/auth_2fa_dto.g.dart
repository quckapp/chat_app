// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_2fa_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enable2faDto _$Enable2faDtoFromJson(Map<String, dynamic> json) => Enable2faDto(
      method: json['method'] as String,
    );

Map<String, dynamic> _$Enable2faDtoToJson(Enable2faDto instance) =>
    <String, dynamic>{
      'method': instance.method,
    };

Verify2faDto _$Verify2faDtoFromJson(Map<String, dynamic> json) => Verify2faDto(
      code: json['code'] as String,
    );

Map<String, dynamic> _$Verify2faDtoToJson(Verify2faDto instance) =>
    <String, dynamic>{
      'code': instance.code,
    };

TwoFactorStatusDto _$TwoFactorStatusDtoFromJson(Map<String, dynamic> json) =>
    TwoFactorStatusDto(
      isEnabled: json['is_enabled'] as bool? ?? false,
      method: json['method'] as String?,
      backupCodes: (json['backup_codes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TwoFactorStatusDtoToJson(TwoFactorStatusDto instance) =>
    <String, dynamic>{
      'is_enabled': instance.isEnabled,
      'method': instance.method,
      'backup_codes': instance.backupCodes,
    };

SessionDto _$SessionDtoFromJson(Map<String, dynamic> json) => SessionDto(
      id: json['id'] as String,
      deviceName: json['device_name'] as String,
      ipAddress: json['ip_address'] as String,
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
      isCurrent: json['is_current'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SessionDtoToJson(SessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_name': instance.deviceName,
      'ip_address': instance.ipAddress,
      'last_active': instance.lastActive?.toIso8601String(),
      'is_current': instance.isCurrent,
      'created_at': instance.createdAt?.toIso8601String(),
    };

AuthDeviceDto _$AuthDeviceDtoFromJson(Map<String, dynamic> json) =>
    AuthDeviceDto(
      id: json['id'] as String,
      deviceName: json['device_name'] as String,
      deviceType: json['device_type'] as String,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AuthDeviceDtoToJson(AuthDeviceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_name': instance.deviceName,
      'device_type': instance.deviceType,
      'last_login': instance.lastLogin?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
