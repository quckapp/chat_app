import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/role.dart';
import '../models/serializable/role_dto.dart';

/// Repository for permission and role operations
class PermissionRepository {
  final RestClient _client;

  PermissionRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get all roles
  Future<List<AppRole>> getRoles() async {
    debugPrint('PermissionRepository: Fetching roles');
    return _client.getList(
      '/api/permissions/roles',
      fromJson: (json) => AppRole.fromJson(json),
    );
  }

  /// Create a new role
  Future<AppRole> createRole(CreateRoleDto data) async {
    debugPrint('PermissionRepository: Creating role ${data.name}');
    return _client.post(
      '/api/permissions/roles',
      data: data.toJson(),
      fromJson: (json) => AppRole.fromJson(json),
    );
  }

  /// Update a role
  Future<AppRole> updateRole(String id, CreateRoleDto data) async {
    debugPrint('PermissionRepository: Updating role $id');
    return _client.put(
      '/api/permissions/roles/$id',
      data: data.toJson(),
      fromJson: (json) => AppRole.fromJson(json),
    );
  }

  /// Delete a role
  Future<void> deleteRole(String id) async {
    debugPrint('PermissionRepository: Deleting role $id');
    await _client.delete('/api/permissions/roles/$id');
  }

  /// Get a user's permissions
  Future<UserPermissionDto> getUserPermissions(String userId) async {
    debugPrint('PermissionRepository: Fetching permissions for user $userId');
    return _client.get(
      '/api/permissions/users/$userId',
      fromJson: (json) => UserPermissionDto.fromJson(json),
    );
  }

  /// Update a user's permissions
  Future<UserPermissionDto> updateUserPermissions(
      String userId, List<String> permissions) async {
    debugPrint('PermissionRepository: Updating permissions for user $userId');
    return _client.put(
      '/api/permissions/users/$userId',
      data: {'permissions': permissions},
      fromJson: (json) => UserPermissionDto.fromJson(json),
    );
  }

  /// Check if a user has a specific permission
  Future<PermissionCheckDto> checkPermission(String userId, String permission) async {
    debugPrint('PermissionRepository: Checking permission $permission for user $userId');
    return _client.get(
      '/api/permissions/check',
      queryParams: {'user_id': userId, 'permission': permission},
      fromJson: (json) => PermissionCheckDto.fromJson(json),
    );
  }
}
