import 'package:equatable/equatable.dart';
import '../../models/serializable/reminder_dto.dart';

/// Base class for all reminder events
abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

/// Load reminders with optional status filter
class ReminderLoad extends ReminderEvent {
  final String? status;
  final int page;
  final int perPage;

  const ReminderLoad({this.status, this.page = 1, this.perPage = 20});

  @override
  List<Object?> get props => [status, page, perPage];
}

/// Create a new reminder
class ReminderCreate extends ReminderEvent {
  final CreateReminderDto data;

  const ReminderCreate({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Update an existing reminder
class ReminderUpdate extends ReminderEvent {
  final String reminderId;
  final UpdateReminderDto data;

  const ReminderUpdate({required this.reminderId, required this.data});

  @override
  List<Object?> get props => [reminderId, data];
}

/// Delete a reminder
class ReminderDelete extends ReminderEvent {
  final String reminderId;

  const ReminderDelete({required this.reminderId});

  @override
  List<Object?> get props => [reminderId];
}

/// Snooze a reminder
class ReminderSnooze extends ReminderEvent {
  final String reminderId;
  final DateTime snoozeUntil;

  const ReminderSnooze({required this.reminderId, required this.snoozeUntil});

  @override
  List<Object?> get props => [reminderId, snoozeUntil];
}

/// Mark a reminder as completed
class ReminderComplete extends ReminderEvent {
  final String reminderId;

  const ReminderComplete({required this.reminderId});

  @override
  List<Object?> get props => [reminderId];
}

/// Clear error state
class ReminderClearError extends ReminderEvent {
  const ReminderClearError();
}
