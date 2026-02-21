import 'package:json_annotation/json_annotation.dart';

part 'admin_dto.g.dart';

@JsonSerializable()
class AdminUserDto {
  final String id;
  final String email;
  final String name;
  final String role;
  final String status;
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const AdminUserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.status,
    this.lastLogin,
    this.createdAt,
  });

  factory AdminUserDto.fromJson(Map<String, dynamic> json) => _$AdminUserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserDtoToJson(this);
}

@JsonSerializable()
class AdminStatsDto {
  @JsonKey(name: 'total_users')
  final int totalUsers;
  @JsonKey(name: 'active_users')
  final int activeUsers;
  @JsonKey(name: 'total_channels')
  final int totalChannels;
  @JsonKey(name: 'total_messages')
  final int totalMessages;
  @JsonKey(name: 'storage_used')
  final int storageUsed;

  const AdminStatsDto({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.totalChannels = 0,
    this.totalMessages = 0,
    this.storageUsed = 0,
  });

  factory AdminStatsDto.fromJson(Map<String, dynamic> json) => _$AdminStatsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AdminStatsDtoToJson(this);
}

@JsonSerializable()
class AdminSettingsDto {
  final String key;
  final String value;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const AdminSettingsDto({
    required this.key,
    required this.value,
    this.updatedAt,
  });

  factory AdminSettingsDto.fromJson(Map<String, dynamic> json) => _$AdminSettingsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AdminSettingsDtoToJson(this);
}
