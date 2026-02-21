import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/admin_repository.dart';
import '../../repositories/audit_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

/// BLoC for managing admin operations
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;
  final AuditRepository _auditRepository;

  AdminBloc({
    AdminRepository? adminRepository,
    AuditRepository? auditRepository,
  })  : _adminRepository = adminRepository ?? AdminRepository(),
        _auditRepository = auditRepository ?? AuditRepository(),
        super(const AdminState()) {
    on<AdminLoadUsers>(_onLoadUsers);
    on<AdminLoadStats>(_onLoadStats);
    on<AdminLoadSettings>(_onLoadSettings);
    on<AdminUpdateUserRole>(_onUpdateUserRole);
    on<AdminSuspendUser>(_onSuspendUser);
    on<AdminActivateUser>(_onActivateUser);
    on<AdminUpdateSetting>(_onUpdateSetting);
    on<AdminLoadAuditLogs>(_onLoadAuditLogs);
    on<AdminClearError>(_onClearError);
  }

  Future<void> _onLoadUsers(AdminLoadUsers event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final users = await _adminRepository.getUsers(
        page: event.page,
        perPage: event.perPage,
      );
      emit(state.copyWith(status: AdminStatus.loaded, users: users));
    } catch (e) {
      debugPrint('AdminBloc: Error loading users: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadStats(AdminLoadStats event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final stats = await _adminRepository.getStats();
      emit(state.copyWith(status: AdminStatus.loaded, stats: stats));
    } catch (e) {
      debugPrint('AdminBloc: Error loading stats: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadSettings(AdminLoadSettings event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final settings = await _adminRepository.getSettings();
      emit(state.copyWith(status: AdminStatus.loaded, settings: settings));
    } catch (e) {
      debugPrint('AdminBloc: Error loading settings: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUpdateUserRole(
      AdminUpdateUserRole event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final updatedUser =
          await _adminRepository.updateUserRole(event.userId, event.role);
      final users =
          state.users.map((u) => u.id == event.userId ? updatedUser : u).toList();
      emit(state.copyWith(status: AdminStatus.loaded, users: users));
    } catch (e) {
      debugPrint('AdminBloc: Error updating user role: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onSuspendUser(AdminSuspendUser event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      await _adminRepository.suspendUser(event.userId);
      // Reload users to reflect the change
      final users = await _adminRepository.getUsers();
      emit(state.copyWith(status: AdminStatus.loaded, users: users));
    } catch (e) {
      debugPrint('AdminBloc: Error suspending user: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onActivateUser(AdminActivateUser event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      await _adminRepository.activateUser(event.userId);
      // Reload users to reflect the change
      final users = await _adminRepository.getUsers();
      emit(state.copyWith(status: AdminStatus.loaded, users: users));
    } catch (e) {
      debugPrint('AdminBloc: Error activating user: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUpdateSetting(
      AdminUpdateSetting event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final updated = await _adminRepository.updateSetting(event.key, event.value);
      final settings =
          state.settings.map((s) => s.key == event.key ? updated : s).toList();
      emit(state.copyWith(status: AdminStatus.loaded, settings: settings));
    } catch (e) {
      debugPrint('AdminBloc: Error updating setting: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadAuditLogs(
      AdminLoadAuditLogs event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: AdminStatus.loading));
    try {
      final logs = await _auditRepository.getLogs(
        page: event.page,
        perPage: event.perPage,
        filters: event.filters,
      );
      emit(state.copyWith(status: AdminStatus.loaded, auditLogs: logs));
    } catch (e) {
      debugPrint('AdminBloc: Error loading audit logs: $e');
      emit(state.copyWith(status: AdminStatus.error, error: e.toString()));
    }
  }

  void _onClearError(AdminClearError event, Emitter<AdminState> emit) {
    emit(state.copyWith(status: AdminStatus.loaded, error: null));
  }
}
