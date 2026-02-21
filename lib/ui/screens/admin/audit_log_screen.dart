import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/admin/admin_bloc.dart';
import '../../../bloc/admin/admin_event.dart';
import '../../../bloc/admin/admin_state.dart';
import '../../../core/theme/theme.dart';
import '../../widgets/admin/audit_log_tile.dart';

class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  String? _selectedAction;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    final filters = <String, dynamic>{};
    if (_selectedAction != null) {
      filters['action'] = _selectedAction;
    }
    context.read<AdminBloc>().add(AdminLoadAuditLogs(
          filters: filters.isNotEmpty ? filters : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Logs'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (action) {
              setState(() => _selectedAction = action);
              _loadLogs();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Actions')),
              const PopupMenuItem(value: 'user.login', child: Text('Logins')),
              const PopupMenuItem(value: 'user.create', child: Text('User Created')),
              const PopupMenuItem(value: 'user.update', child: Text('User Updated')),
              const PopupMenuItem(value: 'channel.create', child: Text('Channel Created')),
              const PopupMenuItem(value: 'message.send', child: Text('Messages Sent')),
            ],
          ),
        ],
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
          if (state.isLoading && state.auditLogs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.auditLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.grey400),
                  const SizedBox(height: AppSpacing.md),
                  Text('No audit logs', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Activity logs will appear here',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadLogs(),
            child: ListView.separated(
              itemCount: state.auditLogs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final log = state.auditLogs[index];
                return AuditLogTile(entry: log);
              },
            ),
          );
        },
      ),
    );
  }
}
