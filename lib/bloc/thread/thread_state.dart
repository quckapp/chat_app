import 'package:equatable/equatable.dart';
import '../../models/thread.dart';

/// Status of thread operations
enum ThreadStatus { initial, loading, loaded, error }

/// State for the thread BLoC
class ThreadState extends Equatable {
  final ThreadStatus status;
  final List<Thread> threads;
  final Thread? activeThread;
  final Map<String, List<ThreadReply>> replies;
  final String? error;

  const ThreadState({
    this.status = ThreadStatus.initial,
    this.threads = const [],
    this.activeThread,
    this.replies = const {},
    this.error,
  });

  /// Get replies for a specific thread
  List<ThreadReply> repliesFor(String threadId) => replies[threadId] ?? [];

  /// Whether the state is in loading status
  bool get isLoading => status == ThreadStatus.loading;

  /// Whether there's an error
  bool get hasError => status == ThreadStatus.error && error != null;

  ThreadState copyWith({
    ThreadStatus? status,
    List<Thread>? threads,
    Thread? activeThread,
    Map<String, List<ThreadReply>>? replies,
    String? error,
  }) {
    return ThreadState(
      status: status ?? this.status,
      threads: threads ?? this.threads,
      activeThread: activeThread ?? this.activeThread,
      replies: replies ?? this.replies,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, threads, activeThread, replies, error];
}
