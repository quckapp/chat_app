import 'package:json_annotation/json_annotation.dart';

part 'device_dto.g.dart';

@JsonSerializable()
class DeviceDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'device_token')
  final String deviceToken;
  final String platform;
  @JsonKey(name: 'device_name')
  final String? deviceName;
  @JsonKey(name: 'last_active_at')
  final DateTime? lastActiveAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const DeviceDto({
    required this.id,
    required this.userId,
    required this.deviceToken,
    required this.platform,
    this.deviceName,
    this.lastActiveAt,
    this.createdAt,
  });

  factory DeviceDto.fromJson(Map<String, dynamic> json) => _$DeviceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceDtoToJson(this);
}

@JsonSerializable()
class RegisterDeviceDto {
  @JsonKey(name: 'device_token')
  final String deviceToken;
  final String platform;
  @JsonKey(name: 'device_name')
  final String? deviceName;

  const RegisterDeviceDto({
    required this.deviceToken,
    required this.platform,
    this.deviceName,
  });

  factory RegisterDeviceDto.fromJson(Map<String, dynamic> json) => _$RegisterDeviceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDeviceDtoToJson(this);
}

@JsonSerializable()
class PreferenceDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'mute_until')
  final DateTime? muteUntil;
  @JsonKey(name: 'push_enabled')
  final bool pushEnabled;
  @JsonKey(name: 'email_enabled')
  final bool emailEnabled;
  @JsonKey(name: 'sound_enabled')
  final bool soundEnabled;

  const PreferenceDto({
    required this.id,
    required this.userId,
    this.channelId,
    this.muteUntil,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.soundEnabled = true,
  });

  factory PreferenceDto.fromJson(Map<String, dynamic> json) => _$PreferenceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PreferenceDtoToJson(this);
}

@JsonSerializable()
class UpdatePreferenceDto {
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'mute_until')
  final DateTime? muteUntil;
  @JsonKey(name: 'push_enabled')
  final bool? pushEnabled;
  @JsonKey(name: 'email_enabled')
  final bool? emailEnabled;
  @JsonKey(name: 'sound_enabled')
  final bool? soundEnabled;

  const UpdatePreferenceDto({
    this.channelId,
    this.muteUntil,
    this.pushEnabled,
    this.emailEnabled,
    this.soundEnabled,
  });

  factory UpdatePreferenceDto.fromJson(Map<String, dynamic> json) => _$UpdatePreferenceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePreferenceDtoToJson(this);
}
