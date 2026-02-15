import 'package:equatable/equatable.dart';
import '../../models/call_record.dart';

enum CallHistoryStatus { initial, loading, loaded, error }

class CallState extends Equatable {
  final CallHistoryStatus status;
  final List<CallRecord> callRecords;
  final CallRecord? activeCall;
  final String? error;

  const CallState({
    this.status = CallHistoryStatus.initial,
    this.callRecords = const [],
    this.activeCall,
    this.error,
  });

  bool get isLoading => status == CallHistoryStatus.loading;
  bool get hasError => status == CallHistoryStatus.error;
  bool get hasActiveCall => activeCall != null;

  /// Get today's calls
  List<CallRecord> get todaysCalls {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return callRecords.where((call) {
      final callDate = DateTime(
        call.timestamp.year,
        call.timestamp.month,
        call.timestamp.day,
      );
      return callDate.isAtSameMomentAs(today);
    }).toList();
  }

  /// Get missed calls
  List<CallRecord> get missedCalls {
    return callRecords.where((call) => call.isMissed).toList();
  }

  /// Get recent calls (last 20)
  List<CallRecord> get recentCalls {
    if (callRecords.length <= 20) return callRecords;
    return callRecords.sublist(0, 20);
  }

  CallState copyWith({
    CallHistoryStatus? status,
    List<CallRecord>? callRecords,
    CallRecord? activeCall,
    String? error,
    bool clearActiveCall = false,
  }) {
    return CallState(
      status: status ?? this.status,
      callRecords: callRecords ?? this.callRecords,
      activeCall: clearActiveCall ? null : (activeCall ?? this.activeCall),
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, callRecords, activeCall, error];
}
