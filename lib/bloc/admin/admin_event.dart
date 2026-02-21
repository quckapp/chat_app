import 'package:equatable/equatable.dart';

/// Base class for all admin events
abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

/// Load admin users
class AdminLoadUsers extends AdminEvent {
  final int page;
  final int perPage;

  const AdminLoadUsers({this.page = 1, this.perPage = 20});

  @override
  List<Object?> get props => [page, perPage];
}

/// Load admin stats
class AdminLoadStats extends AdminEvent {
  const AdminLoadStats();
}

/// Load admin settings
class AdminLoadSettings extends AdminEvent {
  const AdminLoadSettings();
}

/// Update a user's role
class AdminUpdateUserRole extends AdminEvent {
  final String userId;
  final String role;

  const AdminUpdateUserRole({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}

/// Suspend a user
class AdminSuspendUser extends AdminEvent {
  final String userId;

  const AdminSuspendUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Activate a user
class AdminActivateUser extends AdminEvent {
  final String userId;

  const AdminActivateUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Update an admin setting
class AdminUpdateSetting extends AdminEvent {
  final String key;
  final String value;

  const AdminUpdateSetting({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

/// Load audit logs
class AdminLoadAuditLogs extends AdminEvent {
  final int page;
  final int perPage;
  final Map<String, dynamic>? filters;

  const AdminLoadAuditLogs({this.page = 1, this.perPage = 20, this.filters});

  @override
  List<Object?> get props => [page, perPage, filters];
}

/// Clear error state
class AdminClearError extends AdminEvent {
  const AdminClearError();
}
