import 'package:json_annotation/json_annotation.dart';

part 'file_dto.g.dart';

@JsonSerializable()
class FileDto {
  final String id;
  final String name;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  final int size;
  final String type;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @JsonKey(name: 'uploaded_by')
  final String uploadedBy;
  @JsonKey(name: 'workspace_id')
  final String? workspaceId;
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const FileDto({
    required this.id, required this.name, this.mimeType, this.size = 0,
    this.type = 'other', required this.url, this.thumbnailUrl,
    required this.uploadedBy, this.workspaceId, this.channelId, this.createdAt,
  });

  factory FileDto.fromJson(Map<String, dynamic> json) => _$FileDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FileDtoToJson(this);
}

@JsonSerializable()
class FileShareDto {
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'user_ids')
  final List<String>? userIds;

  const FileShareDto({this.channelId, this.userIds});

  factory FileShareDto.fromJson(Map<String, dynamic> json) => _$FileShareDtoFromJson(json);
  Map<String, dynamic> toJson() => _$FileShareDtoToJson(this);
}

/// Paginated file list response
class FileListDto {
  final List<FileDto> files;
  final int total;
  final int page;
  final int perPage;

  const FileListDto({required this.files, required this.total, this.page = 1, this.perPage = 20});

  factory FileListDto.fromJson(Map<String, dynamic> json) {
    final items = json['files'] ?? json['data'] ?? json['items'] ?? [];
    return FileListDto(
      files: (items as List<dynamic>).map((e) => FileDto.fromJson(e as Map<String, dynamic>)).toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
