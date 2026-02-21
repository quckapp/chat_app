import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'channel.g.dart';

/// Represents a channel within a workspace
@HiveType(typeId: 14)
class Channel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final ChannelType type;
  @HiveField(4)
  final String workspaceId;
  @HiveField(5)
  final String createdBy;
  @HiveField(6)
  final String? topic;
  @HiveField(7)
  final String? avatar;
  @HiveField(8)
  final int memberCount;
  @HiveField(9)
  final bool isArchived;
  @HiveField(10)
  final DateTime createdAt;
  @HiveField(11)
  final DateTime? updatedAt;

  const Channel({
    required this.id,
    required this.name,
    this.description,
    this.type = ChannelType.public,
    required this.workspaceId,
    required this.createdBy,
    this.topic,
    this.avatar,
    this.memberCount = 0,
    this.isArchived = false,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isPublic => type == ChannelType.public;
  bool get isPrivate => type == ChannelType.private;
  bool get isDm => type == ChannelType.dm;

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      type: ChannelType.fromString(json['type'] as String?),
      workspaceId: json['workspace_id'] as String? ?? json['workspaceId'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      topic: json['topic'] as String?,
      avatar: json['avatar'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt() ??
          (json['memberCount'] as num?)?.toInt() ?? 0,
      isArchived: json['is_archived'] as bool? ?? json['isArchived'] as bool? ?? false,
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
      'name': name,
      'description': description,
      'type': type.name,
      'workspace_id': workspaceId,
      'created_by': createdBy,
      'topic': topic,
      'avatar': avatar,
      'member_count': memberCount,
      'is_archived': isArchived,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Channel copyWith({
    String? id, String? name, String? description, ChannelType? type,
    String? workspaceId, String? createdBy, String? topic, String? avatar,
    int? memberCount, bool? isArchived, DateTime? createdAt, DateTime? updatedAt,
  }) {
    return Channel(
      id: id ?? this.id, name: name ?? this.name,
      description: description ?? this.description, type: type ?? this.type,
      workspaceId: workspaceId ?? this.workspaceId, createdBy: createdBy ?? this.createdBy,
      topic: topic ?? this.topic, avatar: avatar ?? this.avatar,
      memberCount: memberCount ?? this.memberCount, isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt, updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, description, type, workspaceId, createdBy,
        topic, avatar, memberCount, isArchived, createdAt, updatedAt,
      ];
}

@HiveType(typeId: 15)
enum ChannelType {
  @HiveField(0)
  public,
  @HiveField(1)
  private,
  @HiveField(2)
  dm;

  static ChannelType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'private': return ChannelType.private;
      case 'dm': return ChannelType.dm;
      default: return ChannelType.public;
    }
  }
}

@HiveType(typeId: 16)
class ChannelMember extends Equatable {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String role;
  @HiveField(3)
  final String? displayName;
  @HiveField(4)
  final String? avatar;
  @HiveField(5)
  final DateTime joinedAt;

  const ChannelMember({
    required this.userId, required this.channelId, this.role = 'member',
    this.displayName, this.avatar, required this.joinedAt,
  });

  factory ChannelMember.fromJson(Map<String, dynamic> json) {
    return ChannelMember(
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      displayName: json['display_name'] as String? ?? json['displayName'] as String?,
      avatar: json['avatar'] as String?,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : json['joinedAt'] != null
              ? DateTime.parse(json['joinedAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId, 'channel_id': channelId, 'role': role,
    'display_name': displayName, 'avatar': avatar, 'joined_at': joinedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [userId, channelId, role, displayName, avatar, joinedAt];
}
