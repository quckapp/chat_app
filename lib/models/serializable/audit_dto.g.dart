// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLogDto _$AuditLogDtoFromJson(Map<String, dynamic> json) => AuditLogDto(
      id: json['id'] as String,
      action: json['action'] as String,
      userId: json['user_id'] as String,
      targetType: json['target_type'] as String,
      targetId: json['target_id'] as String,
      details: json['details'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AuditLogDtoToJson(AuditLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'user_id': instance.userId,
      'target_type': instance.targetType,
      'target_id': instance.targetId,
      'details': instance.details,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'created_at': instance.createdAt?.toIso8601String(),
    };

AuditStatsDto _$AuditStatsDtoFromJson(Map<String, dynamic> json) =>
    AuditStatsDto(
      totalEvents: (json['total_events'] as num?)?.toInt() ?? 0,
      eventsByType: json['events_by_type'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$AuditStatsDtoToJson(AuditStatsDto instance) =>
    <String, dynamic>{
      'total_events': instance.totalEvents,
      'events_by_type': instance.eventsByType,
    };
