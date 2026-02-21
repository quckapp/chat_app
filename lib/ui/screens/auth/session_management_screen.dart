import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/auth_2fa_dto.dart';

class SessionManagementScreen extends StatefulWidget {
  const SessionManagementScreen({super.key});

  @override
  State<SessionManagementScreen> createState() => _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  final bool _isLoading = false;
  final List<SessionDto> _sessions = [
    SessionDto(
      id: 'current',
      deviceName: 'Current Device',
      ipAddress: '127.0.0.1',
      lastActive: DateTime.now(),
      isCurrent: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Sessions'),
        actions: [
          if (_sessions.length > 1)
            TextButton(
              onPressed: () => _confirmRevokeAll(),
              child: Text(
                'Revoke All',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices, size: 64, color: AppColors.grey400),
                  const SizedBox(height: AppSpacing.md),
                  Text('No active sessions', style: AppTypography.headlineSmall),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: _sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final session = _sessions[index];
              return _buildSessionCard(session);
            },
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(SessionDto session) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: session.isCurrent
                  ? Colors.green.withValues(alpha: 0.1)
                  : AppColors.grey400.withValues(alpha: 0.1),
              child: Icon(
                _deviceIcon(session.deviceName),
                color: session.isCurrent ? Colors.green : AppColors.grey400,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.deviceName,
                          style: AppTypography.bodyLarge,
                        ),
                      ),
                      if (session.isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Current',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.green,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IP: ${session.ipAddress}',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
                  ),
                  if (session.lastActive != null)
                    Text(
                      'Last active: ${_formatDate(session.lastActive!)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.grey500,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (!session.isCurrent)
              IconButton(
                icon: Icon(Icons.logout, color: AppColors.error, size: 20),
                onPressed: () => _confirmRevoke(session),
              ),
          ],
        ),
      ),
    );
  }

  IconData _deviceIcon(String deviceName) {
    final lower = deviceName.toLowerCase();
    if (lower.contains('iphone') || lower.contains('android') || lower.contains('mobile')) {
      return Icons.phone_android;
    }
    if (lower.contains('ipad') || lower.contains('tablet')) {
      return Icons.tablet;
    }
    return Icons.computer;
  }

  void _confirmRevoke(SessionDto session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke Session'),
        content: Text('Revoke the session on "${session.deviceName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _sessions.removeWhere((s) => s.id == session.id);
              });
            },
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }

  void _confirmRevokeAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Revoke All Sessions'),
        content: const Text(
            'Revoke all other sessions? You will remain logged in on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _sessions.removeWhere((s) => !s.isCurrent);
              });
            },
            child: const Text('Revoke All'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
