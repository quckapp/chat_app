import 'package:equatable/equatable.dart';
import '../../models/notification.dart';

/// Base class for all notification events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load notifications
class NotificationLoad extends NotificationEvent {
  final int page;
  final int perPage;

  const NotificationLoad({this.page = 1, this.perPage = 20});

  @override
  List<Object?> get props => [page, perPage];
}

/// Mark a notification as read
class NotificationMarkRead extends NotificationEvent {
  final String notificationId;

  const NotificationMarkRead({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read
class NotificationMarkAllRead extends NotificationEvent {
  const NotificationMarkAllRead();
}

/// Delete a notification
class NotificationDelete extends NotificationEvent {
  final String notificationId;

  const NotificationDelete({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// A new notification was received (e.g., from WebSocket)
class NotificationReceived extends NotificationEvent {
  final AppNotification notification;

  const NotificationReceived({required this.notification});

  @override
  List<Object?> get props => [notification];
}

/// Clear error state
class NotificationClearError extends NotificationEvent {
  const NotificationClearError();
}
