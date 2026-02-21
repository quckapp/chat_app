import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/workspace/workspace_bloc.dart';
import '../../../bloc/workspace/workspace_event.dart';
import '../../../bloc/workspace/workspace_state.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/workspace/workspace_tile.dart';

class WorkspaceListScreen extends StatefulWidget {
  const WorkspaceListScreen({super.key});

  @override
  State<WorkspaceListScreen> createState() => _WorkspaceListScreenState();
}

class _WorkspaceListScreenState extends State<WorkspaceListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkspaceBloc>().add(const WorkspaceLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspaces'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/workspaces/create'),
          ),
        ],
      ),
      body: BlocConsumer<WorkspaceBloc, WorkspaceState>(
        listener: (context, state) {
          if (state.hasError && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
            context.read<WorkspaceBloc>().add(const WorkspaceClearError());
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.workspaces.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.workspaces.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WorkspaceBloc>().add(const WorkspaceLoad());
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              itemCount: state.workspaces.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final workspace = state.workspaces[index];
                return WorkspaceTile(
                  workspace: workspace,
                  isActive: state.activeWorkspace?.id == workspace.id,
                  onTap: () {
                    context
                        .read<WorkspaceBloc>()
                        .add(WorkspaceSelectActive(workspace.id));
                    context.push('/workspace/${workspace.id}');
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJoinDialog(context),
        child: const Icon(Icons.link),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspaces_outlined,
              size: 80,
              color: AppColors.grey500,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Workspaces Yet',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create a workspace or join one with an invite code.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.push('/workspaces/create'),
              icon: const Icon(Icons.add),
              label: const Text('Create Workspace'),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => _showJoinDialog(context),
              icon: const Icon(Icons.link),
              label: const Text('Join with Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Join Workspace'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Invite Code',
            hintText: 'Enter invite code',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context
                    .read<WorkspaceBloc>()
                    .add(WorkspaceJoinByCode(controller.text.trim()));
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
