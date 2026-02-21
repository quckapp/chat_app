import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'channel_extras.g.dart';

/// Represents a link shared in a channel
@HiveType(typeId: 37)
class ChannelLink extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final String createdBy;
  @HiveField(6)
  final DateTime createdAt;

  const ChannelLink({
    required this.id,
    required this.channelId,
    required this.url,
    required this.title,
    this.description,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChannelLink.fromJson(Map<String, dynamic> json) {
    return ChannelLink(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      url: json['url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'url': url,
      'title': title,
      'description': description,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChannelLink copyWith({
    String? id,
    String? channelId,
    String? url,
    String? title,
    String? description,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return ChannelLink(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, channelId, url, title, description, createdBy, createdAt];
}

/// Represents a tab in a channel
@HiveType(typeId: 38)
class ChannelTab extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final String url;
  @HiveField(5)
  final String createdBy;
  @HiveField(6)
  final DateTime createdAt;

  const ChannelTab({
    required this.id,
    required this.channelId,
    required this.name,
    required this.type,
    required this.url,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChannelTab.fromJson(Map<String, dynamic> json) {
    return ChannelTab(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'custom',
      url: json['url'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'name': name,
      'type': type,
      'url': url,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChannelTab copyWith({
    String? id,
    String? channelId,
    String? name,
    String? type,
    String? url,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return ChannelTab(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, channelId, name, type, url, createdBy, createdAt];
}

/// Represents a message template in a channel
@HiveType(typeId: 39)
class ChannelTemplate extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final String createdBy;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime? updatedAt;

  const ChannelTemplate({
    required this.id,
    required this.channelId,
    required this.name,
    required this.content,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChannelTemplate.fromJson(Map<String, dynamic> json) {
    return ChannelTemplate(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'name': name,
      'content': content,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ChannelTemplate copyWith({
    String? id,
    String? channelId,
    String? name,
    String? content,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChannelTemplate(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      name: name ?? this.name,
      content: content ?? this.content,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, channelId, name, content, createdBy, createdAt, updatedAt];
}
