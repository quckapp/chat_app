import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_bloc.dart';
import '../../../bloc/channel_extras/channel_extras_event.dart';
import '../../../bloc/channel_extras/channel_extras_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/scheduled_message.dart';
import '../../../models/serializable/scheduled_message_dto.dart';
import '../../widgets/channel/scheduled_message_tile.dart';

class ScheduledMessagesScreen extends StatefulWidget {
  final String channelId;

  const ScheduledMessagesScreen({super.key, required this.channelId});

  @override
  State<ScheduledMessagesScreen> createState() => _ScheduledMessagesScreenState();
}

class _ScheduledMessagesScreenState extends State<ScheduledMessagesScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ChannelExtrasBloc>()
        .add(LoadScheduledMessages(channelId: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Messages'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleMessageDialog(),
        child: const Icon(Icons.schedule_send),
      ),
      body: BlocConsumer<ChannelExtrasBloc, ChannelExtrasState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.scheduledMessages.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.scheduledMessages.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ChannelExtrasBloc>()
                  .add(LoadScheduledMessages(channelId: widget.channelId));
            },
            child: ListView.separated(
              itemCount: state.scheduledMessages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final message = state.scheduledMessages[index];
                return ScheduledMessageTile(
                  message: message,
                  onCancel: () => _confirmCancel(message),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_outlined, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text('No scheduled messages', style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Schedule messages to be sent later',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(ScheduledMessage message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Scheduled Message'),
        content: const Text('Cancel this scheduled message? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChannelExtrasBloc>().add(CancelScheduledMessage(
                    channelId: widget.channelId,
                    messageId: message.id,
                  ));
            },
            child: const Text('Cancel Message'),
          ),
        ],
      ),
    );
  }

  void _showScheduleMessageDialog() {
    final contentController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Schedule Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Message content'),
                maxLines: 3,
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Scheduled time'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} '
                  '${selectedDate.hour.toString().padLeft(2, '0')}:'
                  '${selectedDate.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null && ctx.mounted) {
                    final time = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (contentController.text.trim().isNotEmpty) {
                  Navigator.pop(ctx);
                  context.read<ChannelExtrasBloc>().add(CreateScheduledMessage(
                        channelId: widget.channelId,
                        data: CreateScheduledMessageDto(
                          channelId: widget.channelId,
                          content: contentController.text.trim(),
                          scheduledAt: selectedDate,
                        ),
                      ));
                }
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
