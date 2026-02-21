// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentUploadDto _$AttachmentUploadDtoFromJson(Map<String, dynamic> json) =>
    AttachmentUploadDto(
      messageId: json['message_id'] as String,
      fileId: json['file_id'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AttachmentUploadDtoToJson(
        AttachmentUploadDto instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'file_id': instance.fileId,
      'description': instance.description,
    };

MessageAttachmentDto _$MessageAttachmentDtoFromJson(
        Map<String, dynamic> json) =>
    MessageAttachmentDto(
      id: json['id'] as String,
      messageId: json['message_id'] as String,
      fileId: json['file_id'] as String,
      fileName: json['file_name'] as String?,
      fileUrl: json['file_url'] as String?,
      mimeType: json['mime_type'] as String?,
      size: (json['size'] as num?)?.toInt(),
      description: json['description'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MessageAttachmentDtoToJson(
        MessageAttachmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message_id': instance.messageId,
      'file_id': instance.fileId,
      'file_name': instance.fileName,
      'file_url': instance.fileUrl,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
    };
