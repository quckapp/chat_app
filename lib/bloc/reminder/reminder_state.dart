import 'package:equatable/equatable.dart';
import '../../models/reminder.dart';

/// Status of reminder operations
enum ReminderBlocStatus { initial, loading, loaded, error }

/// State for the reminder BLoC
class ReminderState extends Equatable {
  final ReminderBlocStatus status;
  final List<Reminder> reminders;
  final String? error;

  const ReminderState({
    this.status = ReminderBlocStatus.initial,
    this.reminders = const [],
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == ReminderBlocStatus.loading;

  /// Whether there's an error
  bool get hasError => status == ReminderBlocStatus.error && error != null;

  /// Get pending reminders
  List<Reminder> get pendingReminders =>
      reminders.where((r) => r.isPending).toList();

  /// Get snoozed reminders
  List<Reminder> get snoozedReminders =>
      reminders.where((r) => r.isSnoozed).toList();

  /// Get completed reminders
  List<Reminder> get completedReminders =>
      reminders.where((r) => r.isCompleted).toList();

  /// Get overdue reminders
  List<Reminder> get overdueReminders =>
      reminders.where((r) => r.isOverdue).toList();

  ReminderState copyWith({
    ReminderBlocStatus? status,
    List<Reminder>? reminders,
    String? error,
  }) {
    return ReminderState(
      status: status ?? this.status,
      reminders: reminders ?? this.reminders,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, reminders, error];
}
