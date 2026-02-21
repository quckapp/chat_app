// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileDto _$FileDtoFromJson(Map<String, dynamic> json) => FileDto(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mime_type'] as String?,
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'other',
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      uploadedBy: json['uploaded_by'] as String,
      workspaceId: json['workspace_id'] as String?,
      channelId: json['channel_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FileDtoToJson(FileDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'type': instance.type,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'uploaded_by': instance.uploadedBy,
      'workspace_id': instance.workspaceId,
      'channel_id': instance.channelId,
      'created_at': instance.createdAt?.toIso8601String(),
    };

FileShareDto _$FileShareDtoFromJson(Map<String, dynamic> json) => FileShareDto(
      channelId: json['channel_id'] as String?,
      userIds: (json['user_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FileShareDtoToJson(FileShareDto instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'user_ids': instance.userIds,
    };
