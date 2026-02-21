import 'package:equatable/equatable.dart';
import '../../models/audit_log.dart';
import '../../models/serializable/admin_dto.dart';

/// Status of admin operations
enum AdminStatus { initial, loading, loaded, error }

/// State for the admin BLoC
class AdminState extends Equatable {
  final AdminStatus status;
  final List<AdminUserDto> users;
  final AdminStatsDto? stats;
  final List<AdminSettingsDto> settings;
  final List<AuditLogEntry> auditLogs;
  final String? error;

  const AdminState({
    this.status = AdminStatus.initial,
    this.users = const [],
    this.stats,
    this.settings = const [],
    this.auditLogs = const [],
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == AdminStatus.loading;

  /// Whether there's an error
  bool get hasError => status == AdminStatus.error && error != null;

  AdminState copyWith({
    AdminStatus? status,
    List<AdminUserDto>? users,
    AdminStatsDto? stats,
    List<AdminSettingsDto>? settings,
    List<AuditLogEntry>? auditLogs,
    String? error,
  }) {
    return AdminState(
      status: status ?? this.status,
      users: users ?? this.users,
      stats: stats ?? this.stats,
      settings: settings ?? this.settings,
      auditLogs: auditLogs ?? this.auditLogs,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, users, stats, settings, auditLogs, error];
}
