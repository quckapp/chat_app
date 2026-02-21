// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityReportDto _$SecurityReportDtoFromJson(Map<String, dynamic> json) =>
    SecurityReportDto(
      id: json['id'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SecurityReportDtoToJson(SecurityReportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'severity': instance.severity,
      'description': instance.description,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
    };

SecurityPolicyDto _$SecurityPolicyDtoFromJson(Map<String, dynamic> json) =>
    SecurityPolicyDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      rules: json['rules'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SecurityPolicyDtoToJson(SecurityPolicyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'rules': instance.rules,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

ThreatDto _$ThreatDtoFromJson(Map<String, dynamic> json) => ThreatDto(
      id: json['id'] as String,
      type: json['type'] as String,
      source: json['source'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String,
      detectedAt: json['detected_at'] == null
          ? null
          : DateTime.parse(json['detected_at'] as String),
    );

Map<String, dynamic> _$ThreatDtoToJson(ThreatDto instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'source': instance.source,
      'severity': instance.severity,
      'status': instance.status,
      'detected_at': instance.detectedAt?.toIso8601String(),
    };
