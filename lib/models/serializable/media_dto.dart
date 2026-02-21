import 'package:json_annotation/json_annotation.dart';

part 'media_dto.g.dart';

@JsonSerializable()
class MediaDto {
  final String id;
  @JsonKey(name: 'file_id')
  final String fileId;
  @JsonKey(name: 'media_type')
  final String mediaType;
  final int? width;
  final int? height;
  final int? duration;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  final String url;
  @JsonKey(name: 'uploaded_by')
  final String? uploadedBy;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const MediaDto({
    required this.id, required this.fileId, required this.mediaType,
    this.width, this.height, this.duration,
    this.thumbnailUrl, required this.url, this.uploadedBy, this.createdAt,
  });

  factory MediaDto.fromJson(Map<String, dynamic> json) => _$MediaDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MediaDtoToJson(this);
}

@JsonSerializable()
class MediaUploadResponseDto {
  final String id;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'media_type')
  final String mediaType;

  const MediaUploadResponseDto({
    required this.id, required this.url, this.thumbnailUrl, required this.mediaType,
  });

  factory MediaUploadResponseDto.fromJson(Map<String, dynamic> json) => _$MediaUploadResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MediaUploadResponseDtoToJson(this);
}
