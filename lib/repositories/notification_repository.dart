import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/notification.dart';
import '../models/serializable/notification_dto.dart';

/// Repository for notification operations
class NotificationRepository {
  final RestClient _client;

  NotificationRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List notifications
  Future<List<AppNotification>> getNotifications({int page = 1, int perPage = 20}) async {
    debugPrint('NotificationRepository: Fetching notifications');
    final result = await _client.get(
      '/api/notifications',
      queryParams: {'page': page, 'per_page': perPage},
      fromJson: NotificationListDto.fromJson,
    );
    return result.notifications
        .map((dto) => AppNotification.fromJson(dto.toJson()))
        .toList();
  }

  /// Mark a notification as read
  Future<void> markRead(String notificationId) async {
    await _client.postVoid(
      '/api/notifications/$notificationId/read',
    );
  }

  /// Mark all notifications as read
  Future<void> markAllRead() async {
    await _client.postVoid('/api/notifications/read-all');
  }

  /// Delete a notification
  Future<void> deleteNotification(String id) async {
    await _client.delete('/api/notifications/$id');
  }
}
