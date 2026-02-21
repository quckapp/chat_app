import 'package:json_annotation/json_annotation.dart';

part 'role_dto.g.dart';

@JsonSerializable()
class RoleDto {
  final String id;
  final String name;
  final String? description;
  final List<String> permissions;
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const RoleDto({
    required this.id,
    required this.name,
    this.description,
    this.permissions = const [],
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  factory RoleDto.fromJson(Map<String, dynamic> json) => _$RoleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RoleDtoToJson(this);
}

@JsonSerializable()
class CreateRoleDto {
  final String name;
  final String? description;
  final List<String> permissions;

  const CreateRoleDto({
    required this.name,
    this.description,
    this.permissions = const [],
  });

  factory CreateRoleDto.fromJson(Map<String, dynamic> json) => _$CreateRoleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRoleDtoToJson(this);
}

@JsonSerializable()
class UserPermissionDto {
  @JsonKey(name: 'user_id')
  final String userId;
  final List<String> permissions;

  const UserPermissionDto({
    required this.userId,
    this.permissions = const [],
  });

  factory UserPermissionDto.fromJson(Map<String, dynamic> json) =>
      _$UserPermissionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserPermissionDtoToJson(this);
}

@JsonSerializable()
class PermissionCheckDto {
  @JsonKey(name: 'user_id')
  final String userId;
  final String permission;
  final bool allowed;

  const PermissionCheckDto({
    required this.userId,
    required this.permission,
    this.allowed = false,
  });

  factory PermissionCheckDto.fromJson(Map<String, dynamic> json) =>
      _$PermissionCheckDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PermissionCheckDtoToJson(this);
}
