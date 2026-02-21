// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportRequestDto _$ExportRequestDtoFromJson(Map<String, dynamic> json) =>
    ExportRequestDto(
      type: json['type'] as String,
      format: json['format'] as String,
      filters: json['filters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ExportRequestDtoToJson(ExportRequestDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'format': instance.format,
      'filters': instance.filters,
    };

ExportStatusDto _$ExportStatusDtoFromJson(Map<String, dynamic> json) =>
    ExportStatusDto(
      id: json['id'] as String,
      status: json['status'] as String,
      downloadUrl: json['download_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ExportStatusDtoToJson(ExportStatusDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'download_url': instance.downloadUrl,
      'created_at': instance.createdAt?.toIso8601String(),
    };
