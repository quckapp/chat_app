import 'package:json_annotation/json_annotation.dart';

part 'auth_2fa_dto.g.dart';

@JsonSerializable()
class Enable2faDto {
  final String method;

  const Enable2faDto({required this.method});

  factory Enable2faDto.fromJson(Map<String, dynamic> json) => _$Enable2faDtoFromJson(json);
  Map<String, dynamic> toJson() => _$Enable2faDtoToJson(this);
}

@JsonSerializable()
class Verify2faDto {
  final String code;

  const Verify2faDto({required this.code});

  factory Verify2faDto.fromJson(Map<String, dynamic> json) => _$Verify2faDtoFromJson(json);
  Map<String, dynamic> toJson() => _$Verify2faDtoToJson(this);
}

@JsonSerializable()
class TwoFactorStatusDto {
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;
  final String? method;
  @JsonKey(name: 'backup_codes')
  final List<String> backupCodes;

  const TwoFactorStatusDto({
    this.isEnabled = false,
    this.method,
    this.backupCodes = const [],
  });

  factory TwoFactorStatusDto.fromJson(Map<String, dynamic> json) =>
      _$TwoFactorStatusDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TwoFactorStatusDtoToJson(this);
}

@JsonSerializable()
class SessionDto {
  final String id;
  @JsonKey(name: 'device_name')
  final String deviceName;
  @JsonKey(name: 'ip_address')
  final String ipAddress;
  @JsonKey(name: 'last_active')
  final DateTime? lastActive;
  @JsonKey(name: 'is_current')
  final bool isCurrent;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const SessionDto({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    this.lastActive,
    this.isCurrent = false,
    this.createdAt,
  });

  factory SessionDto.fromJson(Map<String, dynamic> json) => _$SessionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SessionDtoToJson(this);
}

@JsonSerializable()
class AuthDeviceDto {
  final String id;
  @JsonKey(name: 'device_name')
  final String deviceName;
  @JsonKey(name: 'device_type')
  final String deviceType;
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const AuthDeviceDto({
    required this.id,
    required this.deviceName,
    required this.deviceType,
    this.lastLogin,
    this.createdAt,
  });

  factory AuthDeviceDto.fromJson(Map<String, dynamic> json) => _$AuthDeviceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthDeviceDtoToJson(this);
}
