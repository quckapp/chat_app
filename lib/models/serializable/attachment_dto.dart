import 'package:json_annotation/json_annotation.dart';

part 'attachment_dto.g.dart';

@JsonSerializable()
class AttachmentUploadDto {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'file_id')
  final String fileId;
  final String? description;

  const AttachmentUploadDto({required this.messageId, required this.fileId, this.description});

  factory AttachmentUploadDto.fromJson(Map<String, dynamic> json) => _$AttachmentUploadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentUploadDtoToJson(this);
}

@JsonSerializable()
class MessageAttachmentDto {
  final String id;
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'file_id')
  final String fileId;
  @JsonKey(name: 'file_name')
  final String? fileName;
  @JsonKey(name: 'file_url')
  final String? fileUrl;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  final int? size;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const MessageAttachmentDto({
    required this.id, required this.messageId, required this.fileId,
    this.fileName, this.fileUrl, this.mimeType, this.size,
    this.description, this.createdAt,
  });

  factory MessageAttachmentDto.fromJson(Map<String, dynamic> json) => _$MessageAttachmentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageAttachmentDtoToJson(this);
}
