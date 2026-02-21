// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserDto _$AdminUserDtoFromJson(Map<String, dynamic> json) => AdminUserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AdminUserDtoToJson(AdminUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'status': instance.status,
      'last_login': instance.lastLogin?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

AdminStatsDto _$AdminStatsDtoFromJson(Map<String, dynamic> json) =>
    AdminStatsDto(
      totalUsers: (json['total_users'] as num?)?.toInt() ?? 0,
      activeUsers: (json['active_users'] as num?)?.toInt() ?? 0,
      totalChannels: (json['total_channels'] as num?)?.toInt() ?? 0,
      totalMessages: (json['total_messages'] as num?)?.toInt() ?? 0,
      storageUsed: (json['storage_used'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdminStatsDtoToJson(AdminStatsDto instance) =>
    <String, dynamic>{
      'total_users': instance.totalUsers,
      'active_users': instance.activeUsers,
      'total_channels': instance.totalChannels,
      'total_messages': instance.totalMessages,
      'storage_used': instance.storageUsed,
    };

AdminSettingsDto _$AdminSettingsDtoFromJson(Map<String, dynamic> json) =>
    AdminSettingsDto(
      key: json['key'] as String,
      value: json['value'] as String,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AdminSettingsDtoToJson(AdminSettingsDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
