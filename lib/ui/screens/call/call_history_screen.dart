import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/call_dto.dart';
import '../../../repositories/call_repository.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  final CallRepository _repository = CallRepository();
  List<CallDto> _calls = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCallHistory();
  }

  Future<void> _loadCallHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final calls = await _repository.getCallHistory();
      setState(() {
        _calls = calls;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call History')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load call history', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: _loadCallHistory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_calls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call_outlined, size: 64, color: AppColors.grey400),
            const SizedBox(height: AppSpacing.md),
            Text('No call history', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your calls will appear here',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCallHistory,
      child: ListView.separated(
        itemCount: _calls.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final call = _calls[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: _statusColor(call.status).withValues(alpha: 0.1),
              child: Icon(
                call.type == 'video' ? Icons.videocam : Icons.call,
                color: _statusColor(call.status),
                size: 20,
              ),
            ),
            title: Text(
              call.calleeId,
              style: AppTypography.bodyLarge,
            ),
            subtitle: Row(
              children: [
                Icon(
                  _statusIcon(call.status),
                  size: 14,
                  color: _statusColor(call.status),
                ),
                const SizedBox(width: 4),
                Text(
                  call.status,
                  style: AppTypography.bodySmall.copyWith(
                    color: _statusColor(call.status),
                  ),
                ),
                if (call.duration != null) ...[
                  Text(
                    ' - ${_formatDuration(call.duration!)}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                  ),
                ],
              ],
            ),
            trailing: Text(
              _formatDate(call.startedAt),
              style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.primary;
      case 'missed':
        return AppColors.error;
      case 'declined':
        return AppColors.grey500;
      case 'ongoing':
        return Colors.green;
      default:
        return AppColors.grey400;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.call_made;
      case 'missed':
        return Icons.call_missed;
      case 'declined':
        return Icons.call_end;
      case 'ongoing':
        return Icons.call;
      default:
        return Icons.call;
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}';
  }
}
