import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/workspace_dto.dart';
import '../models/workspace.dart';
import '../models/workspace_invite.dart';

/// Repository for workspace operations
class WorkspaceRepository {
  final RestClient _client;

  WorkspaceRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get all workspaces for current user
  Future<List<Workspace>> getWorkspaces({
    int page = 1,
    int perPage = 20,
  }) async {
    debugPrint('WorkspaceRepository: Fetching workspaces');
    try {
      final result = await _client.get(
        '/api/v1/workspaces',
        queryParams: {
          'page': page,
          'per_page': perPage,
        },
        fromJson: WorkspaceListDto.fromJson,
      );
      return result.workspaces
          .map((json) => Workspace.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('WorkspaceRepository: Error fetching workspaces: $e');
      debugPrint('WorkspaceRepository: Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get a single workspace by ID
  Future<Workspace> getWorkspace(String id) async {
    return _client.get(
      '/api/v1/workspaces/$id',
      fromJson: (json) => Workspace.fromJson(json),
    );
  }

  /// Create a new workspace
  Future<Workspace> createWorkspace(CreateWorkspaceDto data) async {
    return _client.post(
      '/api/v1/workspaces',
      data: data.toJson(),
      fromJson: (json) => Workspace.fromJson(json),
    );
  }

  /// Update a workspace
  Future<Workspace> updateWorkspace(String id, UpdateWorkspaceDto data) async {
    return _client.put(
      '/api/v1/workspaces/$id',
      data: data.toJson(),
      fromJson: (json) => Workspace.fromJson(json),
    );
  }

  /// Delete a workspace
  Future<void> deleteWorkspace(String id) async {
    await _client.delete('/api/v1/workspaces/$id');
  }

  // ============ Member Management ============

  /// Get workspace members
  Future<List<WorkspaceMember>> getMembers(
    String workspaceId, {
    int page = 1,
    int perPage = 50,
  }) async {
    final result = await _client.get(
      '/api/v1/workspaces/$workspaceId/members',
      queryParams: {
        'page': page,
        'per_page': perPage,
      },
      fromJson: MemberListDto.fromJson,
    );
    return result.members
        .map((dto) => WorkspaceMember.fromJson(dto.toJson()))
        .toList();
  }

  /// Invite member by email
  Future<WorkspaceInvite> inviteMember(
    String workspaceId,
    InviteMemberDto data,
  ) async {
    return _client.post(
      '/api/v1/workspaces/$workspaceId/members/invite',
      data: data.toJson(),
      fromJson: (json) => WorkspaceInvite.fromJson(json),
    );
  }

  /// Update member role
  Future<void> updateMemberRole(
    String workspaceId,
    String userId,
    UpdateMemberRoleDto data,
  ) async {
    await _client.put(
      '/api/v1/workspaces/$workspaceId/members/$userId/role',
      data: data.toJson(),
      fromJson: (json) => json,
    );
  }

  /// Remove member from workspace
  Future<void> removeMember(String workspaceId, String userId) async {
    await _client.delete('/api/v1/workspaces/$workspaceId/members/$userId');
  }

  /// Leave workspace
  Future<void> leaveWorkspace(String workspaceId) async {
    await _client.postVoid('/api/v1/workspaces/$workspaceId/leave');
  }

  // ============ Invites ============

  /// Get pending invites for workspace
  Future<List<WorkspaceInvite>> getInvites(String workspaceId) async {
    return _client.getList(
      '/api/v1/workspaces/$workspaceId/invites',
      fromJson: (json) => WorkspaceInvite.fromJson(json),
    );
  }

  /// Revoke an invite
  Future<void> revokeInvite(String workspaceId, String inviteId) async {
    await _client.delete('/api/v1/workspaces/$workspaceId/invites/$inviteId');
  }

  // ============ Invite Codes ============

  /// Create invite code
  Future<WorkspaceInvite> createInviteCode(
    String workspaceId,
    CreateInviteCodeDto data,
  ) async {
    return _client.post(
      '/api/v1/workspaces/$workspaceId/invite-codes',
      data: data.toJson(),
      fromJson: (json) => WorkspaceInvite.fromJson(json),
    );
  }

  /// List invite codes
  Future<List<WorkspaceInvite>> getInviteCodes(String workspaceId) async {
    return _client.getList(
      '/api/v1/workspaces/$workspaceId/invite-codes',
      fromJson: (json) => WorkspaceInvite.fromJson(json),
    );
  }

  /// Revoke invite code
  Future<void> revokeInviteCode(String workspaceId, String codeId) async {
    await _client.delete('/api/v1/workspaces/$workspaceId/invite-codes/$codeId');
  }

  /// Join workspace by invite code
  Future<Workspace> joinByCode(String inviteCode) async {
    return _client.post(
      '/api/v1/join',
      data: JoinWorkspaceDto(inviteCode: inviteCode).toJson(),
      fromJson: (json) => Workspace.fromJson(json),
    );
  }

  /// Accept invite by token
  Future<Workspace> acceptInvite(String token) async {
    return _client.post(
      '/api/v1/invites/$token/accept',
      data: {},
      fromJson: (json) => Workspace.fromJson(json),
    );
  }
}
