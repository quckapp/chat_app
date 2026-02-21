import 'package:json_annotation/json_annotation.dart';

part 'workspace_dto.g.dart';

@JsonSerializable()
class WorkspaceDto {
  final String id;
  final String name;
  final String slug;
  final String? description;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @JsonKey(defaultValue: 'free')
  final String plan;
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;
  final Map<String, dynamic>? settings;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const WorkspaceDto({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.iconUrl,
    required this.ownerId,
    this.plan = 'free',
    this.isActive = true,
    this.settings,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkspaceDto.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceDtoToJson(this);
}

@JsonSerializable()
class WorkspaceMemberDto {
  final String id;
  @JsonKey(name: 'workspace_id')
  final String workspaceId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(defaultValue: 'member')
  final String role;
  @JsonKey(name: 'display_name')
  final String? displayName;
  final String? avatar;
  final String? title;
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;
  @JsonKey(name: 'joined_at')
  final DateTime? joinedAt;
  @JsonKey(name: 'invited_by')
  final String? invitedBy;

  const WorkspaceMemberDto({
    required this.id,
    required this.workspaceId,
    required this.userId,
    this.role = 'member',
    this.displayName,
    this.avatar,
    this.title,
    this.isActive = true,
    this.joinedAt,
    this.invitedBy,
  });

  factory WorkspaceMemberDto.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceMemberDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceMemberDtoToJson(this);
}

@JsonSerializable()
class CreateWorkspaceDto {
  final String name;
  final String slug;
  final String? description;

  const CreateWorkspaceDto({
    required this.name,
    required this.slug,
    this.description,
  });

  factory CreateWorkspaceDto.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkspaceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateWorkspaceDtoToJson(this);
}

@JsonSerializable()
class UpdateWorkspaceDto {
  final String? name;
  final String? description;
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  final Map<String, dynamic>? settings;

  const UpdateWorkspaceDto({
    this.name,
    this.description,
    this.iconUrl,
    this.settings,
  });

  factory UpdateWorkspaceDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateWorkspaceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateWorkspaceDtoToJson(this);
}

@JsonSerializable()
class InviteMemberDto {
  final String email;
  @JsonKey(defaultValue: 'member')
  final String role;

  const InviteMemberDto({
    required this.email,
    this.role = 'member',
  });

  factory InviteMemberDto.fromJson(Map<String, dynamic> json) =>
      _$InviteMemberDtoFromJson(json);
  Map<String, dynamic> toJson() => _$InviteMemberDtoToJson(this);
}

@JsonSerializable()
class UpdateMemberRoleDto {
  final String role;

  const UpdateMemberRoleDto({required this.role});

  factory UpdateMemberRoleDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMemberRoleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateMemberRoleDtoToJson(this);
}

@JsonSerializable()
class CreateInviteCodeDto {
  final String role;
  @JsonKey(name: 'max_uses')
  final int? maxUses;

  const CreateInviteCodeDto({
    required this.role,
    this.maxUses,
  });

  factory CreateInviteCodeDto.fromJson(Map<String, dynamic> json) =>
      _$CreateInviteCodeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateInviteCodeDtoToJson(this);
}

@JsonSerializable()
class JoinWorkspaceDto {
  @JsonKey(name: 'invite_code')
  final String inviteCode;

  const JoinWorkspaceDto({required this.inviteCode});

  factory JoinWorkspaceDto.fromJson(Map<String, dynamic> json) =>
      _$JoinWorkspaceDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JoinWorkspaceDtoToJson(this);
}

/// Backend returns paginated workspace list
class WorkspaceListDto {
  final List<Map<String, dynamic>> workspaces;
  final int total;
  final int page;
  final int perPage;

  const WorkspaceListDto({
    required this.workspaces,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory WorkspaceListDto.fromJson(Map<String, dynamic> json) {
    final items = json['workspaces'] ?? json['data'] ?? json['items'] ?? [];
    return WorkspaceListDto(
      workspaces: (items as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ??
          (json['perPage'] as num?)?.toInt() ?? 20,
    );
  }
}

/// Backend returns paginated member list
class MemberListDto {
  final List<WorkspaceMemberDto> members;
  final int total;

  const MemberListDto({
    required this.members,
    required this.total,
  });

  factory MemberListDto.fromJson(Map<String, dynamic> json) {
    final items = json['members'] ?? json['data'] ?? json['items'] ?? [];
    return MemberListDto(
      members: (items as List<dynamic>)
          .map((e) => WorkspaceMemberDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
