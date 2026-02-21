import 'package:json_annotation/json_annotation.dart';

part 'export_dto.g.dart';

@JsonSerializable()
class ExportRequestDto {
  final String type;
  final String format;
  final Map<String, dynamic>? filters;

  const ExportRequestDto({
    required this.type,
    required this.format,
    this.filters,
  });

  factory ExportRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ExportRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ExportRequestDtoToJson(this);
}

@JsonSerializable()
class ExportStatusDto {
  final String id;
  final String status;
  @JsonKey(name: 'download_url')
  final String? downloadUrl;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const ExportStatusDto({
    required this.id,
    required this.status,
    this.downloadUrl,
    this.createdAt,
  });

  factory ExportStatusDto.fromJson(Map<String, dynamic> json) =>
      _$ExportStatusDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ExportStatusDtoToJson(this);
}
