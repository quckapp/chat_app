// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsEventDto _$AnalyticsEventDtoFromJson(Map<String, dynamic> json) =>
    AnalyticsEventDto(
      event: json['event'] as String,
      properties: json['properties'] as Map<String, dynamic>? ?? const {},
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$AnalyticsEventDtoToJson(AnalyticsEventDto instance) =>
    <String, dynamic>{
      'event': instance.event,
      'properties': instance.properties,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

AnalyticsResultDto _$AnalyticsResultDtoFromJson(Map<String, dynamic> json) =>
    AnalyticsResultDto(
      metric: json['metric'] as String,
      value: (json['value'] as num).toDouble(),
      period: json['period'] as String,
    );

Map<String, dynamic> _$AnalyticsResultDtoToJson(AnalyticsResultDto instance) =>
    <String, dynamic>{
      'metric': instance.metric,
      'value': instance.value,
      'period': instance.period,
    };
