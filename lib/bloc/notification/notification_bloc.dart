import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

/// BLoC for managing notification operations
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository(),
        super(const NotificationState()) {
    on<NotificationLoad>(_onLoad);
    on<NotificationMarkRead>(_onMarkRead);
    on<NotificationMarkAllRead>(_onMarkAllRead);
    on<NotificationDelete>(_onDelete);
    on<NotificationReceived>(_onReceived);
    on<NotificationClearError>(_onClearError);
  }

  Future<void> _onLoad(NotificationLoad event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final notifications = await _repository.getNotifications(
        page: event.page,
        perPage: event.perPage,
      );
      final unreadCount = notifications.where((n) => n.isUnread).length;
      emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      debugPrint('NotificationBloc: Error loading notifications: $e');
      emit(state.copyWith(status: NotificationStatus.error, error: e.toString()));
    }
  }

  Future<void> _onMarkRead(NotificationMarkRead event, Emitter<NotificationState> emit) async {
    try {
      await _repository.markRead(event.notificationId);
      final notifications = state.notifications.map((n) {
        if (n.id == event.notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      final unreadCount = notifications.where((n) => n.isUnread).length;
      emit(state.copyWith(notifications: notifications, unreadCount: unreadCount));
    } catch (e) {
      debugPrint('NotificationBloc: Error marking notification read: $e');
      emit(state.copyWith(status: NotificationStatus.error, error: e.toString()));
    }
  }

  Future<void> _onMarkAllRead(NotificationMarkAllRead event, Emitter<NotificationState> emit) async {
    try {
      await _repository.markAllRead();
      final notifications = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(state.copyWith(notifications: notifications, unreadCount: 0));
    } catch (e) {
      debugPrint('NotificationBloc: Error marking all notifications read: $e');
      emit(state.copyWith(status: NotificationStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDelete(NotificationDelete event, Emitter<NotificationState> emit) async {
    try {
      await _repository.deleteNotification(event.notificationId);
      final notifications = state.notifications
          .where((n) => n.id != event.notificationId)
          .toList();
      final unreadCount = notifications.where((n) => n.isUnread).length;
      emit(state.copyWith(notifications: notifications, unreadCount: unreadCount));
    } catch (e) {
      debugPrint('NotificationBloc: Error deleting notification: $e');
      emit(state.copyWith(status: NotificationStatus.error, error: e.toString()));
    }
  }

  void _onReceived(NotificationReceived event, Emitter<NotificationState> emit) {
    final notifications = [event.notification, ...state.notifications];
    final unreadCount = notifications.where((n) => n.isUnread).length;
    emit(state.copyWith(notifications: notifications, unreadCount: unreadCount));
  }

  void _onClearError(NotificationClearError event, Emitter<NotificationState> emit) {
    emit(state.copyWith(status: NotificationStatus.loaded, error: null));
  }
}
