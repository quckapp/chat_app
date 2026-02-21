import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'file_info.g.dart';

@HiveType(typeId: 20)
enum FileType {
  @HiveField(0)
  image,
  @HiveField(1)
  video,
  @HiveField(2)
  audio,
  @HiveField(3)
  document,
  @HiveField(4)
  archive,
  @HiveField(5)
  other;

  static FileType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'image': return FileType.image;
      case 'video': return FileType.video;
      case 'audio': return FileType.audio;
      case 'document': return FileType.document;
      case 'archive': return FileType.archive;
      default: return FileType.other;
    }
  }
}

/// Represents a file uploaded to the system
@HiveType(typeId: 19)
class FileInfo extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? mimeType;
  @HiveField(3)
  final int size;
  @HiveField(4)
  final FileType type;
  @HiveField(5)
  final String url;
  @HiveField(6)
  final String? thumbnailUrl;
  @HiveField(7)
  final String uploadedBy;
  @HiveField(8)
  final String? workspaceId;
  @HiveField(9)
  final String? channelId;
  @HiveField(10)
  final DateTime createdAt;

  const FileInfo({
    required this.id, required this.name, this.mimeType,
    this.size = 0, this.type = FileType.other, required this.url,
    this.thumbnailUrl, required this.uploadedBy,
    this.workspaceId, this.channelId, required this.createdAt,
  });

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? json['file_name'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? json['mimeType'] as String?,
      size: (json['size'] as num?)?.toInt() ?? (json['file_size'] as num?)?.toInt() ?? 0,
      type: FileType.fromString(json['type'] as String? ?? json['file_type'] as String?),
      url: json['url'] as String? ?? json['file_url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? json['thumbnailUrl'] as String?,
      uploadedBy: json['uploaded_by'] as String? ?? json['uploadedBy'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? json['workspaceId'] as String?,
      channelId: json['channel_id'] as String? ?? json['channelId'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'mime_type': mimeType, 'size': size,
    'type': type.name, 'url': url, 'thumbnail_url': thumbnailUrl,
    'uploaded_by': uploadedBy, 'workspace_id': workspaceId,
    'channel_id': channelId, 'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, mimeType, size, type, url, thumbnailUrl, uploadedBy, workspaceId, channelId, createdAt];
}
