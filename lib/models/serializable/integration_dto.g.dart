// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntegrationDto _$IntegrationDtoFromJson(Map<String, dynamic> json) =>
    IntegrationDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      config: json['config'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$IntegrationDtoToJson(IntegrationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'status': instance.status,
      'config': instance.config,
    };

IntegrationConfigDto _$IntegrationConfigDtoFromJson(
        Map<String, dynamic> json) =>
    IntegrationConfigDto(
      key: json['key'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$IntegrationConfigDtoToJson(
        IntegrationConfigDto instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };
