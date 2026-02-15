import 'package:equatable/equatable.dart';
import '../../models/call_record.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

/// Load call history from local storage
class CallLoadHistory extends CallEvent {
  const CallLoadHistory();
}

/// Add a new call record
class CallRecordAdded extends CallEvent {
  final CallRecord callRecord;

  const CallRecordAdded(this.callRecord);

  @override
  List<Object?> get props => [callRecord];
}

/// Update an existing call record
class CallRecordUpdated extends CallEvent {
  final CallRecord callRecord;

  const CallRecordUpdated(this.callRecord);

  @override
  List<Object?> get props => [callRecord];
}

/// Delete a call record
class CallRecordDeleted extends CallEvent {
  final String callId;

  const CallRecordDeleted(this.callId);

  @override
  List<Object?> get props => [callId];
}

/// Clear all call history
class CallClearHistory extends CallEvent {
  const CallClearHistory();
}

/// Start a new call
class CallStart extends CallEvent {
  final String recipientId;
  final String recipientName;
  final String? recipientAvatar;
  final CallType type;

  const CallStart({
    required this.recipientId,
    required this.recipientName,
    this.recipientAvatar,
    required this.type,
  });

  @override
  List<Object?> get props => [recipientId, recipientName, recipientAvatar, type];
}

/// End an ongoing call
class CallEnd extends CallEvent {
  final String callId;
  final CallStatus status;
  final int? durationSeconds;

  const CallEnd({
    required this.callId,
    required this.status,
    this.durationSeconds,
  });

  @override
  List<Object?> get props => [callId, status, durationSeconds];
}

/// Receive an incoming call
class CallIncoming extends CallEvent {
  final String callId;
  final String callerId;
  final String callerName;
  final String? callerAvatar;
  final CallType type;

  const CallIncoming({
    required this.callId,
    required this.callerId,
    required this.callerName,
    this.callerAvatar,
    required this.type,
  });

  @override
  List<Object?> get props => [callId, callerId, callerName, callerAvatar, type];
}
