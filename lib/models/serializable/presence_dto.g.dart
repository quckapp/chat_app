// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresenceDto _$PresenceDtoFromJson(Map<String, dynamic> json) => PresenceDto(
      odataEtag: json['odataEtag'] as String? ?? '',
      userId: json['userId'] as String,
      availability:
          $enumDecode(_$PresenceAvailabilityEnumMap, json['availability']),
      activity:
          $enumDecodeNullable(_$PresenceActivityEnumMap, json['activity']) ??
              PresenceActivity.available,
      statusMessage: json['statusMessage'] as String?,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$PresenceDtoToJson(PresenceDto instance) =>
    <String, dynamic>{
      'odataEtag': instance.odataEtag,
      'userId': instance.userId,
      'availability': _$PresenceAvailabilityEnumMap[instance.availability]!,
      'activity': _$PresenceActivityEnumMap[instance.activity]!,
      'statusMessage': instance.statusMessage,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };

const _$PresenceAvailabilityEnumMap = {
  PresenceAvailability.online: 'online',
  PresenceAvailability.offline: 'offline',
  PresenceAvailability.away: 'away',
  PresenceAvailability.busy: 'busy',
  PresenceAvailability.doNotDisturb: 'doNotDisturb',
};

const _$PresenceActivityEnumMap = {
  PresenceActivity.available: 'available',
  PresenceActivity.inCall: 'inCall',
  PresenceActivity.inMeeting: 'inMeeting',
  PresenceActivity.presenting: 'presenting',
  PresenceActivity.outOfOffice: 'outOfOffice',
};

UpdatePresenceDto _$UpdatePresenceDtoFromJson(Map<String, dynamic> json) =>
    UpdatePresenceDto(
      availability:
          $enumDecode(_$PresenceAvailabilityEnumMap, json['availability']),
      activity:
          $enumDecodeNullable(_$PresenceActivityEnumMap, json['activity']),
      statusMessage: json['statusMessage'] as String?,
      expiresInMinutes: (json['expiresInMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdatePresenceDtoToJson(UpdatePresenceDto instance) =>
    <String, dynamic>{
      'availability': _$PresenceAvailabilityEnumMap[instance.availability]!,
      'activity': _$PresenceActivityEnumMap[instance.activity],
      'statusMessage': instance.statusMessage,
      'expiresInMinutes': instance.expiresInMinutes,
    };

BulkPresenceDto _$BulkPresenceDtoFromJson(Map<String, dynamic> json) =>
    BulkPresenceDto(
      presences: (json['presences'] as List<dynamic>)
          .map((e) => PresenceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BulkPresenceDtoToJson(BulkPresenceDto instance) =>
    <String, dynamic>{
      'presences': instance.presences,
    };
