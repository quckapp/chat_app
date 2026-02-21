import 'package:equatable/equatable.dart';
import '../../models/workspace.dart';
import '../../models/workspace_invite.dart';

enum WorkspaceStatus { initial, loading, loaded, error }

class WorkspaceState extends Equatable {
  final WorkspaceStatus status;
  final List<Workspace> workspaces;
  final Workspace? activeWorkspace;
  final Map<String, List<WorkspaceMember>> members;
  final List<WorkspaceInvite> invites;
  final String? error;

  const WorkspaceState({
    this.status = WorkspaceStatus.initial,
    this.workspaces = const [],
    this.activeWorkspace,
    this.members = const {},
    this.invites = const [],
    this.error,
  });

  bool get isLoading => status == WorkspaceStatus.loading;
  bool get hasError => status == WorkspaceStatus.error;
  bool get hasWorkspaces => workspaces.isNotEmpty;

  List<WorkspaceMember> getMembersFor(String workspaceId) {
    return members[workspaceId] ?? [];
  }

  Workspace? getWorkspace(String id) {
    try {
      return workspaces.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  WorkspaceState copyWith({
    WorkspaceStatus? status,
    List<Workspace>? workspaces,
    Workspace? activeWorkspace,
    Map<String, List<WorkspaceMember>>? members,
    List<WorkspaceInvite>? invites,
    String? error,
  }) {
    return WorkspaceState(
      status: status ?? this.status,
      workspaces: workspaces ?? this.workspaces,
      activeWorkspace: activeWorkspace ?? this.activeWorkspace,
      members: members ?? this.members,
      invites: invites ?? this.invites,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        workspaces,
        activeWorkspace,
        members,
        invites,
        error,
      ];
}
