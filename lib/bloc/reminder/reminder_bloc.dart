import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/reminder_repository.dart';
import 'reminder_event.dart';
import 'reminder_state.dart';

/// BLoC for managing reminder operations
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderRepository _repository;

  ReminderBloc({ReminderRepository? repository})
      : _repository = repository ?? ReminderRepository(),
        super(const ReminderState()) {
    on<ReminderLoad>(_onLoad);
    on<ReminderCreate>(_onCreate);
    on<ReminderUpdate>(_onUpdate);
    on<ReminderDelete>(_onDelete);
    on<ReminderSnooze>(_onSnooze);
    on<ReminderComplete>(_onComplete);
    on<ReminderClearError>(_onClearError);
  }

  Future<void> _onLoad(ReminderLoad event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(status: ReminderBlocStatus.loading));
    try {
      final reminders = await _repository.getReminders(
        status: event.status,
        page: event.page,
        perPage: event.perPage,
      );
      emit(state.copyWith(status: ReminderBlocStatus.loaded, reminders: reminders));
    } catch (e) {
      debugPrint('ReminderBloc: Error loading reminders: $e');
      emit(state.copyWith(status: ReminderBlocStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(ReminderCreate event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(status: ReminderBlocStatus.loading));
    try {
      final reminder = await _repository.createReminder(event.data);
      final updated = [...state.reminders, reminder];
      emit(state.copyWith(status: ReminderBlocStatus.loaded, reminders: updated));
    } catch (e) {
      debugPrint('ReminderBloc: Error creating reminder: $e');
      emit(state.copyWith(status: ReminderBlocStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUpdate(ReminderUpdate event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(status: ReminderBlocStatus.loading));
    try {
      final updated = await _repository.updateReminder(event.reminderId, event.data);
      final reminders = state.reminders
          .map((r) => r.id == event.reminderId ? updated : r)
          .toList();
      emit(state.copyWith(status: ReminderBlocStatus.loaded, reminders: reminders));
    } catch (e) {
      debugPrint('ReminderBloc: Error updating reminder: $e');
      emit(state.copyWith(status: ReminderBlocStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDelete(ReminderDelete event, Emitter<ReminderState> emit) async {
    emit(state.copyWith(status: ReminderBlocStatus.loading));
    try {
      await _repository.deleteReminder(event.reminderId);
      final reminders = state.reminders.where((r) => r.id != event.reminderId).toList();
      emit(state.copyWith(status: ReminderBlocStatus.loaded, reminders: reminders));
    } catch (e) {
      debugPrint('ReminderBloc: Error deleting reminder: $e');
      emit(state.copyWith(status: ReminderBlocStatus.error, error: e.toString()));
    }
  }

  Future<void> _onSnooze(ReminderSnooze event, Emitter<ReminderState> emit) async {
    try {
      final snoozed = await _repository.snoozeReminder(event.reminderId, event.snoozeUntil);
      final reminders = state.reminders
          .map((r) => r.id == event.reminderId ? snoozed : r)
          .toList();
      emit(state.copyWith(reminders: reminders));
    } catch (e) {
      debugPrint('ReminderBloc: Error snoozing reminder: $e');
      emit(state.copyWith(status: ReminderBlocStatus.error, error: e.toString()));
    }
  }

  Future<void> _onComplete(ReminderComplete event, Emitter<ReminderState> emit) async {
    try {
      final completed = await _repository.completeReminder(event.reminderId);
      final reminders = state.reminders
          .map((r) => r.id == event.reminderId ? completed : r)
          .toList();
      emit(state.copyWith(reminders: reminders));
    } catch (e) {
      debugPrint('ReminderBloc: Error completing reminder: $e');
      emit(state.copyWith(status: ReminderBlocStatus.error, error: e.toString()));
    }
  }

  void _onClearError(ReminderClearError event, Emitter<ReminderState> emit) {
    emit(state.copyWith(status: ReminderBlocStatus.loaded, error: null));
  }
}
