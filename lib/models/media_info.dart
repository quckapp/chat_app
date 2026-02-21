import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'media_info.g.dart';

/// Represents media (image/video/audio) with additional metadata
@HiveType(typeId: 21)
class MediaInfo extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fileId;
  @HiveField(2)
  final String mediaType;
  @HiveField(3)
  final int? width;
  @HiveField(4)
  final int? height;
  @HiveField(5)
  final int? duration;
  @HiveField(6)
  final String? thumbnailUrl;
  @HiveField(7)
  final String url;
  @HiveField(8)
  final String? uploadedBy;
  @HiveField(9)
  final DateTime createdAt;

  const MediaInfo({
    required this.id, required this.fileId, required this.mediaType,
    this.width, this.height, this.duration,
    this.thumbnailUrl, required this.url, this.uploadedBy,
    required this.createdAt,
  });

  bool get isImage => mediaType.startsWith('image');
  bool get isVideo => mediaType.startsWith('video');
  bool get isAudio => mediaType.startsWith('audio');

  factory MediaInfo.fromJson(Map<String, dynamic> json) {
    return MediaInfo(
      id: json['id'] as String? ?? '',
      fileId: json['file_id'] as String? ?? json['fileId'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? json['mediaType'] as String? ?? json['mime_type'] as String? ?? '',
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      thumbnailUrl: json['thumbnail_url'] as String? ?? json['thumbnailUrl'] as String?,
      url: json['url'] as String? ?? '',
      uploadedBy: json['uploaded_by'] as String? ?? json['uploadedBy'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'file_id': fileId, 'media_type': mediaType,
    'width': width, 'height': height, 'duration': duration,
    'thumbnail_url': thumbnailUrl, 'url': url, 'uploaded_by': uploadedBy,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, fileId, mediaType, width, height, duration, thumbnailUrl, url, uploadedBy, createdAt];
}
