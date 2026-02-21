import 'package:equatable/equatable.dart';

abstract class WorkspaceEvent extends Equatable {
  const WorkspaceEvent();

  @override
  List<Object?> get props => [];
}

/// Load all workspaces for current user
class WorkspaceLoad extends WorkspaceEvent {
  final int page;

  const WorkspaceLoad({this.page = 1});

  @override
  List<Object?> get props => [page];
}

/// Create a new workspace
class WorkspaceCreate extends WorkspaceEvent {
  final String name;
  final String slug;
  final String? description;

  const WorkspaceCreate({
    required this.name,
    required this.slug,
    this.description,
  });

  @override
  List<Object?> get props => [name, slug, description];
}

/// Update an existing workspace
class WorkspaceUpdate extends WorkspaceEvent {
  final String workspaceId;
  final String? name;
  final String? description;
  final String? iconUrl;

  const WorkspaceUpdate({
    required this.workspaceId,
    this.name,
    this.description,
    this.iconUrl,
  });

  @override
  List<Object?> get props => [workspaceId, name, description, iconUrl];
}

/// Delete a workspace
class WorkspaceDelete extends WorkspaceEvent {
  final String workspaceId;

  const WorkspaceDelete(this.workspaceId);

  @override
  List<Object?> get props => [workspaceId];
}

/// Select the active workspace
class WorkspaceSelectActive extends WorkspaceEvent {
  final String? workspaceId;

  const WorkspaceSelectActive(this.workspaceId);

  @override
  List<Object?> get props => [workspaceId];
}

/// Load members for a workspace
class WorkspaceLoadMembers extends WorkspaceEvent {
  final String workspaceId;

  const WorkspaceLoadMembers(this.workspaceId);

  @override
  List<Object?> get props => [workspaceId];
}

/// Invite a member to workspace
class WorkspaceInviteMember extends WorkspaceEvent {
  final String workspaceId;
  final String email;
  final String role;

  const WorkspaceInviteMember({
    required this.workspaceId,
    required this.email,
    this.role = 'member',
  });

  @override
  List<Object?> get props => [workspaceId, email, role];
}

/// Update a member's role
class WorkspaceUpdateMemberRole extends WorkspaceEvent {
  final String workspaceId;
  final String userId;
  final String role;

  const WorkspaceUpdateMemberRole({
    required this.workspaceId,
    required this.userId,
    required this.role,
  });

  @override
  List<Object?> get props => [workspaceId, userId, role];
}

/// Remove a member from workspace
class WorkspaceRemoveMember extends WorkspaceEvent {
  final String workspaceId;
  final String userId;

  const WorkspaceRemoveMember({
    required this.workspaceId,
    required this.userId,
  });

  @override
  List<Object?> get props => [workspaceId, userId];
}

/// Leave a workspace
class WorkspaceLeave extends WorkspaceEvent {
  final String workspaceId;

  const WorkspaceLeave(this.workspaceId);

  @override
  List<Object?> get props => [workspaceId];
}

/// Join workspace by invite code
class WorkspaceJoinByCode extends WorkspaceEvent {
  final String inviteCode;

  const WorkspaceJoinByCode(this.inviteCode);

  @override
  List<Object?> get props => [inviteCode];
}

/// Accept an invite token
class WorkspaceAcceptInvite extends WorkspaceEvent {
  final String token;

  const WorkspaceAcceptInvite(this.token);

  @override
  List<Object?> get props => [token];
}

/// Create invite code for workspace
class WorkspaceCreateInviteCode extends WorkspaceEvent {
  final String workspaceId;
  final String role;
  final int? maxUses;

  const WorkspaceCreateInviteCode({
    required this.workspaceId,
    this.role = 'member',
    this.maxUses,
  });

  @override
  List<Object?> get props => [workspaceId, role, maxUses];
}

/// Load invites for workspace
class WorkspaceLoadInvites extends WorkspaceEvent {
  final String workspaceId;

  const WorkspaceLoadInvites(this.workspaceId);

  @override
  List<Object?> get props => [workspaceId];
}

/// Clear error state
class WorkspaceClearError extends WorkspaceEvent {
  const WorkspaceClearError();
}
