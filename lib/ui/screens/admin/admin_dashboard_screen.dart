import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/admin/admin_bloc.dart';
import '../../../bloc/admin/admin_event.dart';
import '../../../bloc/admin/admin_state.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/admin/stat_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminLoadStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
          if (state.isLoading && state.stats == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = state.stats;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(const AdminLoadStats());
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text('Overview', style: AppTypography.headlineMedium),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      icon: Icons.people,
                      title: 'Total Users',
                      value: '${stats?.totalUsers ?? 0}',
                      color: Colors.blue,
                    ),
                    StatCard(
                      icon: Icons.person_outline,
                      title: 'Active Users',
                      value: '${stats?.activeUsers ?? 0}',
                      color: Colors.green,
                    ),
                    StatCard(
                      icon: Icons.forum,
                      title: 'Channels',
                      value: '${stats?.totalChannels ?? 0}',
                      color: Colors.orange,
                    ),
                    StatCard(
                      icon: Icons.message,
                      title: 'Messages',
                      value: '${stats?.totalMessages ?? 0}',
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Quick Actions', style: AppTypography.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                _buildActionTile(
                  icon: Icons.people_outline,
                  title: 'User Management',
                  subtitle: 'Manage users, roles, and permissions',
                  onTap: () {
                    // Navigation handled by router
                  },
                ),
                _buildActionTile(
                  icon: Icons.history,
                  title: 'Audit Logs',
                  subtitle: 'View system activity logs',
                  onTap: () {
                    // Navigation handled by router
                  },
                ),
                _buildActionTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Configure application settings',
                  onTap: () {
                    // Navigation handled by router
                  },
                ),
                _buildActionTile(
                  icon: Icons.storage,
                  title: 'Storage',
                  subtitle: '${_formatBytes(stats?.storageUsed ?? 0)} used',
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTypography.bodyLarge),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
