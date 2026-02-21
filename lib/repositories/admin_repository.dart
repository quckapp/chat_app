import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/admin_dto.dart';

/// Repository for admin operations
class AdminRepository {
  final RestClient _client;

  AdminRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get users with pagination
  Future<List<AdminUserDto>> getUsers({int page = 1, int perPage = 20}) async {
    debugPrint('AdminRepository: Fetching users page $page');
    return _client.getList(
      '/api/admin/users',
      queryParams: {'page': page, 'per_page': perPage},
      fromJson: (json) => AdminUserDto.fromJson(json),
    );
  }

  /// Get a single user by ID
  Future<AdminUserDto> getUser(String userId) async {
    debugPrint('AdminRepository: Fetching user $userId');
    return _client.get(
      '/api/admin/users/$userId',
      fromJson: (json) => AdminUserDto.fromJson(json),
    );
  }

  /// Update a user's role
  Future<AdminUserDto> updateUserRole(String userId, String role) async {
    debugPrint('AdminRepository: Updating user $userId role to $role');
    return _client.put(
      '/api/admin/users/$userId/role',
      data: {'role': role},
      fromJson: (json) => AdminUserDto.fromJson(json),
    );
  }

  /// Suspend a user
  Future<void> suspendUser(String userId) async {
    debugPrint('AdminRepository: Suspending user $userId');
    await _client.postVoid('/api/admin/users/$userId/suspend');
  }

  /// Activate a user
  Future<void> activateUser(String userId) async {
    debugPrint('AdminRepository: Activating user $userId');
    await _client.postVoid('/api/admin/users/$userId/activate');
  }

  /// Get admin stats
  Future<AdminStatsDto> getStats() async {
    debugPrint('AdminRepository: Fetching admin stats');
    return _client.get(
      '/api/admin/stats',
      fromJson: (json) => AdminStatsDto.fromJson(json),
    );
  }

  /// Get admin settings
  Future<List<AdminSettingsDto>> getSettings() async {
    debugPrint('AdminRepository: Fetching admin settings');
    return _client.getList(
      '/api/admin/settings',
      fromJson: (json) => AdminSettingsDto.fromJson(json),
    );
  }

  /// Update a setting
  Future<AdminSettingsDto> updateSetting(String key, String value) async {
    debugPrint('AdminRepository: Updating setting $key');
    return _client.put(
      '/api/admin/settings/$key',
      data: {'value': value},
      fromJson: (json) => AdminSettingsDto.fromJson(json),
    );
  }
}
