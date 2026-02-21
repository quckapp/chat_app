import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/reminder/reminder_bloc.dart';
import '../../../bloc/reminder/reminder_event.dart';
import '../../../bloc/reminder/reminder_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/reminder_dto.dart';

class CreateReminderScreen extends StatefulWidget {
  final String messageId;
  final String channelId;

  const CreateReminderScreen({
    super.key,
    required this.messageId,
    required this.channelId,
  });

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {
  final _noteController = TextEditingController();
  DateTime _remindAt = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
        actions: [
          BlocBuilder<ReminderBloc, ReminderState>(
            builder: (context, state) {
              return FilledButton(
                onPressed: state.isLoading ? null : _createReminder,
                child: state.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              );
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: BlocListener<ReminderBloc, ReminderState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Remind me at', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              // Quick presets
              Wrap(
                spacing: AppSpacing.xs,
                children: [
                  ActionChip(
                    label: const Text('In 30 min'),
                    onPressed: () => setState(() {
                      _remindAt = DateTime.now().add(const Duration(minutes: 30));
                    }),
                  ),
                  ActionChip(
                    label: const Text('In 1 hour'),
                    onPressed: () => setState(() {
                      _remindAt = DateTime.now().add(const Duration(hours: 1));
                    }),
                  ),
                  ActionChip(
                    label: const Text('In 3 hours'),
                    onPressed: () => setState(() {
                      _remindAt = DateTime.now().add(const Duration(hours: 3));
                    }),
                  ),
                  ActionChip(
                    label: const Text('Tomorrow'),
                    onPressed: () => setState(() {
                      final tomorrow = DateTime.now().add(const Duration(days: 1));
                      _remindAt = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Custom date/time picker
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  '${_remindAt.day}/${_remindAt.month}/${_remindAt.year}',
                  style: AppTypography.bodyLarge,
                ),
                subtitle: Text(
                  '${_remindAt.hour.toString().padLeft(2, '0')}:${_remindAt.minute.toString().padLeft(2, '0')}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
                ),
                trailing: const Icon(Icons.edit),
                onTap: _pickDateTime,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Note (optional)', style: AppTypography.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Add a note...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _remindAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_remindAt),
      );
      if (time != null && mounted) {
        setState(() {
          _remindAt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  void _createReminder() {
    context.read<ReminderBloc>().add(
          ReminderCreate(
            data: CreateReminderDto(
              messageId: widget.messageId,
              channelId: widget.channelId,
              note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
              remindAt: _remindAt,
            ),
          ),
        );
    Navigator.pop(context);
  }
}
