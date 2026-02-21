// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDto _$MediaDtoFromJson(Map<String, dynamic> json) => MediaDto(
      id: json['id'] as String,
      fileId: json['file_id'] as String,
      mediaType: json['media_type'] as String,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnail_url'] as String?,
      url: json['url'] as String,
      uploadedBy: json['uploaded_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MediaDtoToJson(MediaDto instance) => <String, dynamic>{
      'id': instance.id,
      'file_id': instance.fileId,
      'media_type': instance.mediaType,
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
      'thumbnail_url': instance.thumbnailUrl,
      'url': instance.url,
      'uploaded_by': instance.uploadedBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };

MediaUploadResponseDto _$MediaUploadResponseDtoFromJson(
        Map<String, dynamic> json) =>
    MediaUploadResponseDto(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      mediaType: json['media_type'] as String,
    );

Map<String, dynamic> _$MediaUploadResponseDtoToJson(
        MediaUploadResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'media_type': instance.mediaType,
    };
