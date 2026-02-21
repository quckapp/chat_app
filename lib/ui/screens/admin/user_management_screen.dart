import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/admin/admin_bloc.dart';
import '../../../bloc/admin/admin_event.dart';
import '../../../bloc/admin/admin_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/admin_dto.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminLoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: AppColors.grey400),
                  const SizedBox(height: AppSpacing.md),
                  Text('No users found', style: AppTypography.headlineSmall),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(const AdminLoadUsers());
            },
            child: ListView.separated(
              itemCount: state.users.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = state.users[index];
                return _buildUserTile(user);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserTile(AdminUserDto user) {
    final isActive = user.status == 'active';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : AppColors.grey400.withValues(alpha: 0.1),
        child: Icon(
          Icons.person,
          color: isActive ? Colors.green : AppColors.grey400,
        ),
      ),
      title: Text(user.name, style: AppTypography.bodyLarge),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.email, style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500)),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.role,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.status,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isActive ? Colors.green : AppColors.error,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (action) => _handleUserAction(action, user),
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'role', child: Text('Change Role')),
          if (isActive)
            const PopupMenuItem(value: 'suspend', child: Text('Suspend User'))
          else
            const PopupMenuItem(value: 'activate', child: Text('Activate User')),
        ],
      ),
      isThreeLine: true,
    );
  }

  void _handleUserAction(String action, AdminUserDto user) {
    switch (action) {
      case 'role':
        _showChangeRoleDialog(user);
        break;
      case 'suspend':
        _confirmSuspend(user);
        break;
      case 'activate':
        context.read<AdminBloc>().add(AdminActivateUser(userId: user.id));
        break;
    }
  }

  void _showChangeRoleDialog(AdminUserDto user) {
    String selectedRole = user.role;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Change Role for ${user.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['admin', 'moderator', 'member', 'viewer']
                .map((role) => RadioListTile<String>(
                      title: Text(role),
                      value: role,
                      groupValue: selectedRole,
                      onChanged: (v) {
                        if (v != null) setDialogState(() => selectedRole = v);
                      },
                    ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<AdminBloc>().add(
                      AdminUpdateUserRole(userId: user.id, role: selectedRole),
                    );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSuspend(AdminUserDto user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Suspend User'),
        content: Text('Suspend ${user.name}? They will lose access.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminBloc>().add(AdminSuspendUser(userId: user.id));
            },
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }
}
