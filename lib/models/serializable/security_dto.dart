import 'package:json_annotation/json_annotation.dart';

part 'security_dto.g.dart';

@JsonSerializable()
class SecurityReportDto {
  final String id;
  final String type;
  final String severity;
  final String description;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const SecurityReportDto({
    required this.id,
    required this.type,
    required this.severity,
    required this.description,
    required this.status,
    this.createdAt,
  });

  factory SecurityReportDto.fromJson(Map<String, dynamic> json) =>
      _$SecurityReportDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SecurityReportDtoToJson(this);
}

@JsonSerializable()
class SecurityPolicyDto {
  final String id;
  final String name;
  final String type;
  final String? rules;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const SecurityPolicyDto({
    required this.id,
    required this.name,
    required this.type,
    this.rules,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SecurityPolicyDto.fromJson(Map<String, dynamic> json) =>
      _$SecurityPolicyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SecurityPolicyDtoToJson(this);
}

@JsonSerializable()
class ThreatDto {
  final String id;
  final String type;
  final String source;
  final String severity;
  final String status;
  @JsonKey(name: 'detected_at')
  final DateTime? detectedAt;

  const ThreatDto({
    required this.id,
    required this.type,
    required this.source,
    required this.severity,
    required this.status,
    this.detectedAt,
  });

  factory ThreatDto.fromJson(Map<String, dynamic> json) => _$ThreatDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ThreatDtoToJson(this);
}
