import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../core/storage/local_storage_service.dart';
import '../../models/call_record.dart';
import 'call_event.dart';
import 'call_state.dart';

export 'call_event.dart';
export 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final LocalStorageService _localStorageService;
  final Uuid _uuid = const Uuid();

  CallBloc({
    required LocalStorageService localStorageService,
  })  : _localStorageService = localStorageService,
        super(const CallState()) {
    on<CallLoadHistory>(_onLoadHistory);
    on<CallRecordAdded>(_onRecordAdded);
    on<CallRecordUpdated>(_onRecordUpdated);
    on<CallRecordDeleted>(_onRecordDeleted);
    on<CallClearHistory>(_onClearHistory);
    on<CallStart>(_onCallStart);
    on<CallEnd>(_onCallEnd);
    on<CallIncoming>(_onIncomingCall);
  }

  Future<void> _onLoadHistory(
    CallLoadHistory event,
    Emitter<CallState> emit,
  ) async {
    emit(state.copyWith(status: CallHistoryStatus.loading));

    try {
      final callRecords = await _localStorageService.getCallRecords();
      debugPrint('CallBloc: Loaded ${callRecords.length} call records');

      emit(state.copyWith(
        status: CallHistoryStatus.loaded,
        callRecords: callRecords,
      ));
    } catch (e) {
      debugPrint('CallBloc: Failed to load call history: $e');
      emit(state.copyWith(
        status: CallHistoryStatus.error,
        error: 'Failed to load call history',
      ));
    }
  }

  Future<void> _onRecordAdded(
    CallRecordAdded event,
    Emitter<CallState> emit,
  ) async {
    try {
      await _localStorageService.saveCallRecord(event.callRecord);

      final updatedRecords = [event.callRecord, ...state.callRecords];
      emit(state.copyWith(callRecords: updatedRecords));
    } catch (e) {
      debugPrint('CallBloc: Failed to add call record: $e');
    }
  }

  Future<void> _onRecordUpdated(
    CallRecordUpdated event,
    Emitter<CallState> emit,
  ) async {
    try {
      await _localStorageService.saveCallRecord(event.callRecord);

      final updatedRecords = state.callRecords.map((record) {
        if (record.id == event.callRecord.id) {
          return event.callRecord;
        }
        return record;
      }).toList();

      emit(state.copyWith(callRecords: updatedRecords));
    } catch (e) {
      debugPrint('CallBloc: Failed to update call record: $e');
    }
  }

  Future<void> _onRecordDeleted(
    CallRecordDeleted event,
    Emitter<CallState> emit,
  ) async {
    try {
      await _localStorageService.deleteCallRecord(event.callId);

      final updatedRecords = state.callRecords
          .where((record) => record.id != event.callId)
          .toList();

      emit(state.copyWith(callRecords: updatedRecords));
    } catch (e) {
      debugPrint('CallBloc: Failed to delete call record: $e');
    }
  }

  Future<void> _onClearHistory(
    CallClearHistory event,
    Emitter<CallState> emit,
  ) async {
    try {
      for (final record in state.callRecords) {
        await _localStorageService.deleteCallRecord(record.id);
      }

      emit(state.copyWith(callRecords: []));
    } catch (e) {
      debugPrint('CallBloc: Failed to clear call history: $e');
    }
  }

  void _onCallStart(
    CallStart event,
    Emitter<CallState> emit,
  ) {
    final callRecord = CallRecord(
      id: _uuid.v4(),
      recipientId: event.recipientId,
      recipientName: event.recipientName,
      recipientAvatar: event.recipientAvatar,
      type: event.type,
      status: CallStatus.ongoing,
      timestamp: DateTime.now(),
      isOutgoing: true,
    );

    emit(state.copyWith(activeCall: callRecord));
  }

  Future<void> _onCallEnd(
    CallEnd event,
    Emitter<CallState> emit,
  ) async {
    if (state.activeCall == null || state.activeCall!.id != event.callId) {
      return;
    }

    final completedCall = state.activeCall!.copyWith(
      status: event.status,
      durationSeconds: event.durationSeconds,
    );

    try {
      await _localStorageService.saveCallRecord(completedCall);

      final updatedRecords = [completedCall, ...state.callRecords];
      emit(state.copyWith(
        callRecords: updatedRecords,
        clearActiveCall: true,
      ));
    } catch (e) {
      debugPrint('CallBloc: Failed to save completed call: $e');
      emit(state.copyWith(clearActiveCall: true));
    }
  }

  void _onIncomingCall(
    CallIncoming event,
    Emitter<CallState> emit,
  ) {
    final callRecord = CallRecord(
      id: event.callId,
      recipientId: event.callerId,
      recipientName: event.callerName,
      recipientAvatar: event.callerAvatar,
      type: event.type,
      status: CallStatus.ongoing,
      timestamp: DateTime.now(),
      isOutgoing: false,
    );

    emit(state.copyWith(activeCall: callRecord));
  }
}
