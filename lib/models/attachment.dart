import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'attachment.g.dart';

/// Represents a file attachment in a message
@HiveType(typeId: 3)
class Attachment extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final String? name;
  @HiveField(4)
  final int? size;
  @HiveField(5)
  final String? mimeType;
  @HiveField(6)
  final String? thumbnailUrl;
  @HiveField(7)
  final int? width;
  @HiveField(8)
  final int? height;
  @HiveField(9)
  final int? duration; // For audio/video in seconds

  const Attachment({
    required this.id,
    required this.type,
    required this.url,
    this.name,
    this.size,
    this.mimeType,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.duration,
  });

  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';
  bool get isAudio => type == 'audio';
  bool get isFile => type == 'file';
  bool get isDocument => type == 'file' || type == 'document';

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'file',
      url: json['url'] as String? ?? '',
      name: json['name'] as String?,
      size: json['size'] as int?,
      mimeType: json['mimeType'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      duration: json['duration'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'name': name,
      'size': size,
      'mimeType': mimeType,
      'thumbnailUrl': thumbnailUrl,
      'width': width,
      'height': height,
      'duration': duration,
    };
  }

  @override
  List<Object?> get props => [id, type, url, name, size, mimeType, thumbnailUrl, width, height, duration];
}
