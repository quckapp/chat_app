// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleDto _$RoleDtoFromJson(Map<String, dynamic> json) => RoleDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$RoleDtoToJson(RoleDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'permissions': instance.permissions,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CreateRoleDto _$CreateRoleDtoFromJson(Map<String, dynamic> json) =>
    CreateRoleDto(
      name: json['name'] as String,
      description: json['description'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CreateRoleDtoToJson(CreateRoleDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'permissions': instance.permissions,
    };

UserPermissionDto _$UserPermissionDtoFromJson(Map<String, dynamic> json) =>
    UserPermissionDto(
      userId: json['user_id'] as String,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserPermissionDtoToJson(UserPermissionDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'permissions': instance.permissions,
    };

PermissionCheckDto _$PermissionCheckDtoFromJson(Map<String, dynamic> json) =>
    PermissionCheckDto(
      userId: json['user_id'] as String,
      permission: json['permission'] as String,
      allowed: json['allowed'] as bool? ?? false,
    );

Map<String, dynamic> _$PermissionCheckDtoToJson(PermissionCheckDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'permission': instance.permission,
      'allowed': instance.allowed,
    };
