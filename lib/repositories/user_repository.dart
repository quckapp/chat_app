import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/user_dto.dart';
import '../models/serializable/presence_dto.dart';

/// Repository for user operations
class UserRepository {
  final RestClient _client;

  UserRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.userServiceBaseUrl);

  /// Get user by ID
  Future<UserDto> getUser(String id) async {
    return _client.get(
      '/api/users/$id',
      fromJson: UserDto.fromJson,
    );
  }

  /// Get multiple users by IDs
  Future<List<UserDto>> getUsers(List<String> ids) async {
    return _client.getList(
      '/api/users/v1',
      queryParams: {'ids': ids.join(',')},
      fromJson: UserDto.fromJson,
      dataKey: 'users',
    );
  }

  /// Search users
  Future<UserSearchResultDto> searchUsers(
    String query, {
    int page = 0,
    int size = 20,
  }) async {
    debugPrint('UserRepository: searchUsers called with query="$query", page=$page, size=$size');
    debugPrint('UserRepository: baseUrl=${ApiConstants.userServiceBaseUrl}');
    debugPrint('UserRepository: full URL=${ApiConstants.userServiceBaseUrl}/api/users/search?query=$query&page=$page&size=$size');

    final result = await _client.get(
      '/api/users/search',
      queryParams: {
        'query': query,
        'page': page,
        'size': size,
      },
      fromJson: UserSearchResultDto.fromJson,
    );

    debugPrint('UserRepository: searchUsers returned ${result.users.length} users');
    return result;
  }

  /// Get user by phone number
  Future<UserDto?> getUserByPhone(String phoneNumber) async {
    try {
      return await _client.get(
        '/api/users/phone/$phoneNumber',
        fromJson: UserDto.fromJson,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get user by username
  Future<UserDto?> getUserByUsername(String username) async {
    try {
      return await _client.get(
        '/api/users/username/$username',
        fromJson: UserDto.fromJson,
      );
    } catch (_) {
      return null;
    }
  }

  /// Update current user profile
  Future<UserDto> updateProfile(UserProfileUpdateDto profile) async {
    return _client.put(
      '/api/users/profile',
      data: profile.toJson(),
      fromJson: UserDto.fromJson,
    );
  }

  /// Upload avatar
  Future<UserDto> uploadAvatar(String filePath) async {
    return _client.uploadFile(
      '/api/users/profile/avatar',
      filePath: filePath,
      fieldName: 'avatar',
      fromJson: UserDto.fromJson,
    );
  }

  /// Delete avatar
  Future<void> deleteAvatar() async {
    await _client.delete('/api/users/profile/avatar');
  }

  /// Get user contacts
  Future<List<UserDto>> getContacts() async {
    return _client.getList(
      '/api/users/contacts',
      fromJson: UserDto.fromJson,
      dataKey: 'contacts',
    );
  }

  /// Add contact
  Future<void> addContact(String userId) async {
    await _client.postVoid(
      '/api/users/contacts',
      data: {'userId': userId},
    );
  }

  /// Remove contact
  Future<void> removeContact(String userId) async {
    await _client.delete('/api/users/contacts/$userId');
  }

  /// Block user
  Future<void> blockUser(String userId) async {
    await _client.postVoid(
      '/api/users/blocked',
      data: {'userId': userId},
    );
  }

  /// Unblock user
  Future<void> unblockUser(String userId) async {
    await _client.delete('/api/users/blocked/$userId');
  }

  /// Get blocked users
  Future<List<UserDto>> getBlockedUsers() async {
    return _client.getList(
      '/api/users/blocked',
      fromJson: UserDto.fromJson,
      dataKey: 'users',
    );
  }

  /// Get user presence
  Future<PresenceDto> getUserPresence(String userId) async {
    return _client.get(
      '/api/users/$userId/presence',
      fromJson: PresenceDto.fromJson,
    );
  }

  /// Get presence for multiple users
  Future<BulkPresenceDto> getBulkPresence(List<String> userIds) async {
    return _client.post(
      '/api/users/presence/bulk',
      data: {'userIds': userIds},
      fromJson: BulkPresenceDto.fromJson,
    );
  }

  /// Update my presence
  Future<PresenceDto> updatePresence(UpdatePresenceDto presence) async {
    return _client.put(
      '/api/users/presence',
      data: presence.toJson(),
      fromJson: PresenceDto.fromJson,
    );
  }
}
