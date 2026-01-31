import 'package:json_annotation/json_annotation.dart';

part 'presence_dto.g.dart';

@JsonSerializable()
class PresenceDto {
  final String odataEtag;

  final String userId;
  final PresenceAvailability availability;
  final PresenceActivity activity;
  final String? statusMessage;
  final DateTime? lastSeen;
  final DateTime? expiresAt;

  const PresenceDto({
    this.odataEtag = '',
    required this.userId,
    required this.availability,
    this.activity = PresenceActivity.available,
    this.statusMessage,
    this.lastSeen,
    this.expiresAt,
  });

  factory PresenceDto.fromJson(Map<String, dynamic> json) =>
      _$PresenceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PresenceDtoToJson(this);

  bool get isOnline => availability == PresenceAvailability.online;
  bool get isAway => availability == PresenceAvailability.away;
  bool get isOffline => availability == PresenceAvailability.offline;
  bool get isBusy => availability == PresenceAvailability.busy;
  bool get isDoNotDisturb => availability == PresenceAvailability.doNotDisturb;
}

enum PresenceAvailability {
  @JsonValue('online')
  online,
  @JsonValue('offline')
  offline,
  @JsonValue('away')
  away,
  @JsonValue('busy')
  busy,
  @JsonValue('doNotDisturb')
  doNotDisturb,
}

enum PresenceActivity {
  @JsonValue('available')
  available,
  @JsonValue('inCall')
  inCall,
  @JsonValue('inMeeting')
  inMeeting,
  @JsonValue('presenting')
  presenting,
  @JsonValue('outOfOffice')
  outOfOffice,
}

@JsonSerializable()
class UpdatePresenceDto {
  final PresenceAvailability availability;
  final PresenceActivity? activity;
  final String? statusMessage;
  final int? expiresInMinutes;

  const UpdatePresenceDto({
    required this.availability,
    this.activity,
    this.statusMessage,
    this.expiresInMinutes,
  });

  factory UpdatePresenceDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePresenceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePresenceDtoToJson(this);
}

@JsonSerializable()
class BulkPresenceDto {
  final List<PresenceDto> presences;

  const BulkPresenceDto({required this.presences});

  factory BulkPresenceDto.fromJson(Map<String, dynamic> json) =>
      _$BulkPresenceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BulkPresenceDtoToJson(this);
}
