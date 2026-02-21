import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/serializable/workspace_dto.dart';
import '../../repositories/workspace_repository.dart';
import 'workspace_event.dart';
import 'workspace_state.dart';

class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final WorkspaceRepository _repository;

  WorkspaceBloc({
    WorkspaceRepository? repository,
  })  : _repository = repository ?? WorkspaceRepository(),
        super(const WorkspaceState()) {
    on<WorkspaceLoad>(_onLoad);
    on<WorkspaceCreate>(_onCreate);
    on<WorkspaceUpdate>(_onUpdate);
    on<WorkspaceDelete>(_onDelete);
    on<WorkspaceSelectActive>(_onSelectActive);
    on<WorkspaceLoadMembers>(_onLoadMembers);
    on<WorkspaceInviteMember>(_onInviteMember);
    on<WorkspaceUpdateMemberRole>(_onUpdateMemberRole);
    on<WorkspaceRemoveMember>(_onRemoveMember);
    on<WorkspaceLeave>(_onLeave);
    on<WorkspaceJoinByCode>(_onJoinByCode);
    on<WorkspaceAcceptInvite>(_onAcceptInvite);
    on<WorkspaceCreateInviteCode>(_onCreateInviteCode);
    on<WorkspaceLoadInvites>(_onLoadInvites);
    on<WorkspaceClearError>(_onClearError);
  }

  Future<void> _onLoad(
    WorkspaceLoad event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: WorkspaceStatus.loading, error: null));
    try {
      final workspaces = await _repository.getWorkspaces(page: event.page);
      debugPrint('WorkspaceBloc: Loaded ${workspaces.length} workspaces');
      emit(state.copyWith(
        status: WorkspaceStatus.loaded,
        workspaces: workspaces,
        activeWorkspace: workspaces.isNotEmpty
            ? (state.activeWorkspace ?? workspaces.first)
            : null,
      ));
    } catch (e) {
      debugPrint('WorkspaceBloc: Error loading workspaces: $e');
      emit(state.copyWith(
        status: WorkspaceStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCreate(
    WorkspaceCreate event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: WorkspaceStatus.loading, error: null));
    try {
      final workspace = await _repository.createWorkspace(
        CreateWorkspaceDto(
          name: event.name,
          slug: event.slug,
          description: event.description,
        ),
      );
      final updated = [...state.workspaces, workspace];
      emit(state.copyWith(
        status: WorkspaceStatus.loaded,
        workspaces: updated,
        activeWorkspace: workspace,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WorkspaceStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdate(
    WorkspaceUpdate event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final workspace = await _repository.updateWorkspace(
        event.workspaceId,
        UpdateWorkspaceDto(
          name: event.name,
          description: event.description,
          iconUrl: event.iconUrl,
        ),
      );
      final updated = state.workspaces
          .map((w) => w.id == event.workspaceId ? workspace : w)
          .toList();
      emit(state.copyWith(
        workspaces: updated,
        activeWorkspace: state.activeWorkspace?.id == event.workspaceId
            ? workspace
            : state.activeWorkspace,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(
    WorkspaceDelete event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _repository.deleteWorkspace(event.workspaceId);
      final updated =
          state.workspaces.where((w) => w.id != event.workspaceId).toList();
      emit(state.copyWith(
        workspaces: updated,
        activeWorkspace: state.activeWorkspace?.id == event.workspaceId
            ? (updated.isNotEmpty ? updated.first : null)
            : state.activeWorkspace,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onSelectActive(
    WorkspaceSelectActive event,
    Emitter<WorkspaceState> emit,
  ) async {
    if (event.workspaceId == null) {
      emit(state.copyWith(activeWorkspace: null));
      return;
    }
    final workspace = state.getWorkspace(event.workspaceId!);
    if (workspace != null) {
      emit(state.copyWith(activeWorkspace: workspace));
    }
  }

  Future<void> _onLoadMembers(
    WorkspaceLoadMembers event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final members = await _repository.getMembers(event.workspaceId);
      final updatedMembers = Map<String, List>.from(state.members);
      updatedMembers[event.workspaceId] = members;
      emit(state.copyWith(
        members: Map<String, List<dynamic>>.from(updatedMembers).map(
          (key, value) => MapEntry(
            key,
            value.cast<dynamic>().map((e) => e as dynamic).toList().cast(),
          ),
        ),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onInviteMember(
    WorkspaceInviteMember event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _repository.inviteMember(
        event.workspaceId,
        InviteMemberDto(email: event.email, role: event.role),
      );
      // Reload invites after successful invite
      add(WorkspaceLoadInvites(event.workspaceId));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdateMemberRole(
    WorkspaceUpdateMemberRole event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _repository.updateMemberRole(
        event.workspaceId,
        event.userId,
        UpdateMemberRoleDto(role: event.role),
      );
      // Reload members after role update
      add(WorkspaceLoadMembers(event.workspaceId));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRemoveMember(
    WorkspaceRemoveMember event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _repository.removeMember(event.workspaceId, event.userId);
      // Remove member from local state
      final currentMembers =
          List.from(state.members[event.workspaceId] ?? []);
      currentMembers.removeWhere((m) => m.userId == event.userId);
      final updatedMembers =
          Map<String, List<dynamic>>.from(state.members);
      updatedMembers[event.workspaceId] = currentMembers.cast();
      emit(state.copyWith(members: updatedMembers.cast()));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLeave(
    WorkspaceLeave event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _repository.leaveWorkspace(event.workspaceId);
      final updated =
          state.workspaces.where((w) => w.id != event.workspaceId).toList();
      emit(state.copyWith(
        workspaces: updated,
        activeWorkspace: state.activeWorkspace?.id == event.workspaceId
            ? (updated.isNotEmpty ? updated.first : null)
            : state.activeWorkspace,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onJoinByCode(
    WorkspaceJoinByCode event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: WorkspaceStatus.loading, error: null));
    try {
      final workspace = await _repository.joinByCode(event.inviteCode);
      final updated = [...state.workspaces, workspace];
      emit(state.copyWith(
        status: WorkspaceStatus.loaded,
        workspaces: updated,
        activeWorkspace: workspace,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WorkspaceStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAcceptInvite(
    WorkspaceAcceptInvite event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(state.copyWith(status: WorkspaceStatus.loading, error: null));
    try {
      final workspace = await _repository.acceptInvite(event.token);
      final updated = [...state.workspaces, workspace];
      emit(state.copyWith(
        status: WorkspaceStatus.loaded,
        workspaces: updated,
        activeWorkspace: workspace,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WorkspaceStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onCreateInviteCode(
    WorkspaceCreateInviteCode event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _repository.createInviteCode(
        event.workspaceId,
        CreateInviteCodeDto(role: event.role, maxUses: event.maxUses),
      );
      // Reload invites
      add(WorkspaceLoadInvites(event.workspaceId));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadInvites(
    WorkspaceLoadInvites event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final invites = await _repository.getInvites(event.workspaceId);
      emit(state.copyWith(invites: invites));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onClearError(
    WorkspaceClearError event,
    Emitter<WorkspaceState> emit,
  ) {
    emit(state.copyWith(error: null));
  }
}
