import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/workspace/workspace_bloc.dart';
import '../../../bloc/workspace/workspace_event.dart';
import '../../../bloc/workspace/workspace_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/workspace.dart';

class WorkspaceDetailScreen extends StatefulWidget {
  final String workspaceId;

  const WorkspaceDetailScreen({
    super.key,
    required this.workspaceId,
  });

  @override
  State<WorkspaceDetailScreen> createState() => _WorkspaceDetailScreenState();
}

class _WorkspaceDetailScreenState extends State<WorkspaceDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(WorkspaceLoadMembers(widget.workspaceId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceBloc, WorkspaceState>(
      builder: (context, state) {
        final workspace = state.getWorkspace(widget.workspaceId);
        if (workspace == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Workspace')),
            body: const Center(child: Text('Workspace not found')),
          );
        }

        final members = state.getMembersFor(widget.workspaceId);

        return Scaffold(
          appBar: AppBar(
            title: Text(workspace.name),
            actions: [
              if (workspace.isAdmin)
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, workspace),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Workspace'),
                    ),
                    const PopupMenuItem(
                      value: 'invite',
                      child: Text('Invite Members'),
                    ),
                    const PopupMenuItem(
                      value: 'invite_code',
                      child: Text('Create Invite Code'),
                    ),
                    const PopupMenuDivider(),
                    if (!workspace.isOwner)
                      const PopupMenuItem(
                        value: 'leave',
                        child: Text('Leave Workspace'),
                      ),
                    if (workspace.isOwner)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Workspace',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          body: ListView(
            children: [
              // Workspace Info Header
              _buildInfoHeader(workspace),
              const Divider(),

              // Stats
              _buildStats(workspace),
              const Divider(),

              // Members Section
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Members (${members.length})',
                      style: AppTypography.headlineSmall,
                    ),
                    if (workspace.isAdmin)
                      TextButton.icon(
                        onPressed: () => _showInviteDialog(context),
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Invite'),
                      ),
                  ],
                ),
              ),

              // Member List
              ...members.map((member) => ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (member.displayName ?? member.userId)
                            .substring(0, 1)
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(member.displayName ?? member.userId),
                    subtitle: Text(member.role.name),
                    trailing: member.title != null
                        ? Chip(label: Text(member.title!))
                        : null,
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoHeader(Workspace workspace) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: workspace.iconUrl != null
                ? ClipOval(
                    child: Image.network(
                      workspace.iconUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    workspace.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(workspace.name, style: AppTypography.headlineMedium),
          if (workspace.description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              workspace.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Chip(label: Text(workspace.plan.toUpperCase())),
        ],
      ),
    );
  }

  Widget _buildStats(Workspace workspace) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('Members', workspace.memberCount.toString()),
          _statItem('Channels', workspace.channelCount.toString()),
          _statItem('Role', workspace.myRole ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: AppTypography.headlineSmall),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.grey500,
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(String action, Workspace workspace) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit screen
        break;
      case 'invite':
        _showInviteDialog(context);
        break;
      case 'invite_code':
        _showCreateInviteCodeDialog(context, workspace.id);
        break;
      case 'leave':
        _showLeaveConfirmation(context, workspace.id);
        break;
      case 'delete':
        _showDeleteConfirmation(context, workspace.id);
        break;
    }
  }

  void _showInviteDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Invite Member'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter email address',
          ),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (emailController.text.trim().isNotEmpty) {
                context.read<WorkspaceBloc>().add(WorkspaceInviteMember(
                      workspaceId: widget.workspaceId,
                      email: emailController.text.trim(),
                    ));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Invite'),
          ),
        ],
      ),
    );
  }

  void _showCreateInviteCodeDialog(BuildContext context, String workspaceId) {
    context.read<WorkspaceBloc>().add(WorkspaceCreateInviteCode(
          workspaceId: workspaceId,
          role: 'member',
        ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite code created')),
    );
  }

  void _showLeaveConfirmation(BuildContext context, String workspaceId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Leave Workspace'),
        content: const Text(
          'Are you sure you want to leave this workspace?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<WorkspaceBloc>().add(WorkspaceLeave(workspaceId));
              Navigator.pop(dialogContext);
              context.go('/workspaces');
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String workspaceId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: const Text(
          'This action cannot be undone. All workspace data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<WorkspaceBloc>().add(WorkspaceDelete(workspaceId));
              Navigator.pop(dialogContext);
              context.go('/workspaces');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
