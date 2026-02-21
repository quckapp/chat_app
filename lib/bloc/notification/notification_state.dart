import 'package:equatable/equatable.dart';
import '../../models/notification.dart';
import '../../models/notification_preference.dart';

/// Status of notification operations
enum NotificationStatus { initial, loading, loaded, error }

/// State for the notification BLoC
class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final int unreadCount;
  final List<NotificationPreference> preferences;
  final String? error;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.preferences = const [],
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == NotificationStatus.loading;

  /// Whether there's an error
  bool get hasError => status == NotificationStatus.error && error != null;

  /// Whether there are unread notifications
  bool get hasUnread => unreadCount > 0;

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    int? unreadCount,
    List<NotificationPreference>? preferences,
    String? error,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      preferences: preferences ?? this.preferences,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, notifications, unreadCount, preferences, error];
}
