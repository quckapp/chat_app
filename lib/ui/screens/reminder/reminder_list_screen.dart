import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../bloc/reminder/reminder_event.dart';
import '../../../bloc/reminder/reminder_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/reminder.dart';
import '../../widgets/reminder/reminder_tile.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReminderBloc>().add(const ReminderLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.reminders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.reminders.isEmpty) {
            return _buildEmptyState();
          }

          final overdue = state.overdueReminders;
          final pending = state.pendingReminders.where((r) => !r.isOverdue).toList();
          final snoozed = state.snoozedReminders;
          final completed = state.completedReminders;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ReminderBloc>().add(const ReminderLoad());
            },
            child: ListView(
              children: [
                if (overdue.isNotEmpty) ...[
                  _buildSectionHeader('Overdue', overdue.length, AppColors.error),
                  ...overdue.map((r) => ReminderTile(
                        reminder: r,
                        onComplete: () => _onComplete(r),
                        onSnooze: () => _onSnooze(r),
                        onDelete: () => _onDelete(r),
                      )),
                ],
                if (pending.isNotEmpty) ...[
                  _buildSectionHeader('Upcoming', pending.length, AppColors.primary),
                  ...pending.map((r) => ReminderTile(
                        reminder: r,
                        onComplete: () => _onComplete(r),
                        onSnooze: () => _onSnooze(r),
                        onDelete: () => _onDelete(r),
                      )),
                ],
                if (snoozed.isNotEmpty) ...[
                  _buildSectionHeader('Snoozed', snoozed.length, AppColors.grey500),
                  ...snoozed.map((r) => ReminderTile(
                        reminder: r,
                        onComplete: () => _onComplete(r),
                        onSnooze: () => _onSnooze(r),
                        onDelete: () => _onDelete(r),
                      )),
                ],
                if (completed.isNotEmpty) ...[
                  _buildSectionHeader('Completed', completed.length, AppColors.grey400),
                  ...completed.map((r) => ReminderTile(
                        reminder: r,
                        onDelete: () => _onDelete(r),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            title,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '($count)',
            style: AppTypography.labelSmall.copyWith(color: AppColors.grey400),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm_off, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No reminders', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Set reminders on messages to follow up later',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _onComplete(Reminder reminder) {
    context.read<ReminderBloc>().add(ReminderComplete(reminderId: reminder.id));
  }

  void _onSnooze(Reminder reminder) {
    final snoozeTime = DateTime.now().add(const Duration(hours: 1));
    context.read<ReminderBloc>().add(
          ReminderSnooze(reminderId: reminder.id, snoozeUntil: snoozeTime),
        );
  }

  void _onDelete(Reminder reminder) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text('Delete this reminder? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ReminderBloc>().add(ReminderDelete(reminderId: reminder.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
