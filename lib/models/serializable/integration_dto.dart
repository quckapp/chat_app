import 'package:json_annotation/json_annotation.dart';

part 'integration_dto.g.dart';

@JsonSerializable()
class IntegrationDto {
  final String id;
  final String name;
  final String type;
  final String status;
  final Map<String, dynamic>? config;

  const IntegrationDto({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.config,
  });

  factory IntegrationDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$IntegrationDtoToJson(this);
}

@JsonSerializable()
class IntegrationConfigDto {
  final String key;
  final String value;

  const IntegrationConfigDto({
    required this.key,
    required this.value,
  });

  factory IntegrationConfigDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationConfigDtoFromJson(json);
  Map<String, dynamic> toJson() => _$IntegrationConfigDtoToJson(this);
}
