// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceDto _$WorkspaceDtoFromJson(Map<String, dynamic> json) => WorkspaceDto(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      ownerId: json['owner_id'] as String,
      plan: json['plan'] as String? ?? 'free',
      isActive: json['is_active'] as bool? ?? true,
      settings: json['settings'] as Map<String, dynamic>?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$WorkspaceDtoToJson(WorkspaceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'owner_id': instance.ownerId,
      'plan': instance.plan,
      'is_active': instance.isActive,
      'settings': instance.settings,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

WorkspaceMemberDto _$WorkspaceMemberDtoFromJson(Map<String, dynamic> json) =>
    WorkspaceMemberDto(
      id: json['id'] as String,
      workspaceId: json['workspace_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String? ?? 'member',
      displayName: json['display_name'] as String?,
      avatar: json['avatar'] as String?,
      title: json['title'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
      invitedBy: json['invited_by'] as String?,
    );

Map<String, dynamic> _$WorkspaceMemberDtoToJson(WorkspaceMemberDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspace_id': instance.workspaceId,
      'user_id': instance.userId,
      'role': instance.role,
      'display_name': instance.displayName,
      'avatar': instance.avatar,
      'title': instance.title,
      'is_active': instance.isActive,
      'joined_at': instance.joinedAt?.toIso8601String(),
      'invited_by': instance.invitedBy,
    };

CreateWorkspaceDto _$CreateWorkspaceDtoFromJson(Map<String, dynamic> json) =>
    CreateWorkspaceDto(
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateWorkspaceDtoToJson(CreateWorkspaceDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
    };

UpdateWorkspaceDto _$UpdateWorkspaceDtoFromJson(Map<String, dynamic> json) =>
    UpdateWorkspaceDto(
      name: json['name'] as String?,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UpdateWorkspaceDtoToJson(UpdateWorkspaceDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'settings': instance.settings,
    };

InviteMemberDto _$InviteMemberDtoFromJson(Map<String, dynamic> json) =>
    InviteMemberDto(
      email: json['email'] as String,
      role: json['role'] as String? ?? 'member',
    );

Map<String, dynamic> _$InviteMemberDtoToJson(InviteMemberDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'role': instance.role,
    };

UpdateMemberRoleDto _$UpdateMemberRoleDtoFromJson(Map<String, dynamic> json) =>
    UpdateMemberRoleDto(
      role: json['role'] as String,
    );

Map<String, dynamic> _$UpdateMemberRoleDtoToJson(
        UpdateMemberRoleDto instance) =>
    <String, dynamic>{
      'role': instance.role,
    };

CreateInviteCodeDto _$CreateInviteCodeDtoFromJson(Map<String, dynamic> json) =>
    CreateInviteCodeDto(
      role: json['role'] as String,
      maxUses: (json['max_uses'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateInviteCodeDtoToJson(
        CreateInviteCodeDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'max_uses': instance.maxUses,
    };

JoinWorkspaceDto _$JoinWorkspaceDtoFromJson(Map<String, dynamic> json) =>
    JoinWorkspaceDto(
      inviteCode: json['invite_code'] as String,
    );

Map<String, dynamic> _$JoinWorkspaceDtoToJson(JoinWorkspaceDto instance) =>
    <String, dynamic>{
      'invite_code': instance.inviteCode,
    };
