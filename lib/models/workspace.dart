import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'workspace.g.dart';

/// Represents a workspace (top-level organizational unit)
@HiveType(typeId: 11)
class Workspace extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? iconUrl;
  @HiveField(5)
  final String ownerId;
  @HiveField(6)
  final String plan;
  @HiveField(7)
  final bool isActive;
  @HiveField(8)
  final int memberCount;
  @HiveField(9)
  final int channelCount;
  @HiveField(10)
  final String? myRole;
  @HiveField(11)
  final DateTime createdAt;
  @HiveField(12)
  final DateTime? updatedAt;

  const Workspace({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.iconUrl,
    required this.ownerId,
    this.plan = 'free',
    this.isActive = true,
    this.memberCount = 0,
    this.channelCount = 0,
    this.myRole,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isOwner => myRole == 'owner';
  bool get isAdmin => myRole == 'admin' || myRole == 'owner';

  factory Workspace.fromJson(Map<String, dynamic> json) {
    // Handle wrapped format: { "workspace": {...}, "member_count": N }
    final workspaceData = json['workspace'] as Map<String, dynamic>? ?? json;

    return Workspace(
      id: workspaceData['id'] as String? ?? '',
      name: workspaceData['name'] as String? ?? '',
      slug: workspaceData['slug'] as String? ?? '',
      description: workspaceData['description'] as String?,
      iconUrl: workspaceData['icon_url'] as String? ?? workspaceData['iconUrl'] as String?,
      ownerId: workspaceData['owner_id'] as String? ?? workspaceData['ownerId'] as String? ?? '',
      plan: workspaceData['plan'] as String? ?? 'free',
      isActive: workspaceData['is_active'] as bool? ?? workspaceData['isActive'] as bool? ?? true,
      memberCount: (json['member_count'] as num?)?.toInt() ??
          (json['memberCount'] as num?)?.toInt() ?? 0,
      channelCount: (json['channel_count'] as num?)?.toInt() ??
          (json['channelCount'] as num?)?.toInt() ?? 0,
      myRole: json['my_role'] as String? ?? json['myRole'] as String?,
      createdAt: workspaceData['created_at'] != null
          ? DateTime.parse(workspaceData['created_at'] as String)
          : workspaceData['createdAt'] != null
              ? DateTime.parse(workspaceData['createdAt'] as String)
              : DateTime.now(),
      updatedAt: workspaceData['updated_at'] != null
          ? DateTime.parse(workspaceData['updated_at'] as String)
          : workspaceData['updatedAt'] != null
              ? DateTime.parse(workspaceData['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon_url': iconUrl,
      'owner_id': ownerId,
      'plan': plan,
      'is_active': isActive,
      'member_count': memberCount,
      'channel_count': channelCount,
      'my_role': myRole,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Workspace copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? iconUrl,
    String? ownerId,
    String? plan,
    bool? isActive,
    int? memberCount,
    int? channelCount,
    String? myRole,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      ownerId: ownerId ?? this.ownerId,
      plan: plan ?? this.plan,
      isActive: isActive ?? this.isActive,
      memberCount: memberCount ?? this.memberCount,
      channelCount: channelCount ?? this.channelCount,
      myRole: myRole ?? this.myRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, slug, description, iconUrl, ownerId,
        plan, isActive, memberCount, channelCount, myRole,
        createdAt, updatedAt,
      ];
}

/// Represents a member of a workspace
@HiveType(typeId: 12)
class WorkspaceMember extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String workspaceId;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final WorkspaceRole role;
  @HiveField(4)
  final String? displayName;
  @HiveField(5)
  final String? avatar;
  @HiveField(6)
  final String? title;
  @HiveField(7)
  final bool isActive;
  @HiveField(8)
  final DateTime joinedAt;
  @HiveField(9)
  final String? invitedBy;

  const WorkspaceMember({
    required this.id,
    required this.workspaceId,
    required this.userId,
    this.role = WorkspaceRole.member,
    this.displayName,
    this.avatar,
    this.title,
    this.isActive = true,
    required this.joinedAt,
    this.invitedBy,
  });

  factory WorkspaceMember.fromJson(Map<String, dynamic> json) {
    return WorkspaceMember(
      id: json['id'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? json['workspaceId'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      role: WorkspaceRole.fromString(json['role'] as String?),
      displayName: json['display_name'] as String? ?? json['displayName'] as String?,
      avatar: json['avatar'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : json['joinedAt'] != null
              ? DateTime.parse(json['joinedAt'] as String)
              : DateTime.now(),
      invitedBy: json['invited_by'] as String? ?? json['invitedBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workspace_id': workspaceId,
      'user_id': userId,
      'role': role.name,
      'display_name': displayName,
      'avatar': avatar,
      'title': title,
      'is_active': isActive,
      'joined_at': joinedAt.toIso8601String(),
      'invited_by': invitedBy,
    };
  }

  WorkspaceMember copyWith({
    String? id,
    String? workspaceId,
    String? userId,
    WorkspaceRole? role,
    String? displayName,
    String? avatar,
    String? title,
    bool? isActive,
    DateTime? joinedAt,
    String? invitedBy,
  }) {
    return WorkspaceMember(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt ?? this.joinedAt,
      invitedBy: invitedBy ?? this.invitedBy,
    );
  }

  @override
  List<Object?> get props => [
        id, workspaceId, userId, role, displayName,
        avatar, title, isActive, joinedAt, invitedBy,
      ];
}

/// Workspace member roles
@HiveType(typeId: 13)
enum WorkspaceRole {
  @HiveField(0)
  owner,
  @HiveField(1)
  admin,
  @HiveField(2)
  member,
  @HiveField(3)
  guest;

  static WorkspaceRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'owner':
        return WorkspaceRole.owner;
      case 'admin':
        return WorkspaceRole.admin;
      case 'guest':
        return WorkspaceRole.guest;
      default:
        return WorkspaceRole.member;
    }
  }
}
