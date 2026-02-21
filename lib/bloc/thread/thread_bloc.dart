import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/thread.dart';
import '../../repositories/thread_repository.dart';
import 'thread_event.dart';
import 'thread_state.dart';

/// BLoC for managing thread operations
class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  final ThreadRepository _repository;

  ThreadBloc({ThreadRepository? repository})
      : _repository = repository ?? ThreadRepository(),
        super(const ThreadState()) {
    on<ThreadLoad>(_onLoad);
    on<ThreadCreate>(_onCreate);
    on<ThreadSelectActive>(_onSelectActive);
    on<ThreadLoadReplies>(_onLoadReplies);
    on<ThreadAddReply>(_onAddReply);
    on<ThreadFollow>(_onFollow);
    on<ThreadUnfollow>(_onUnfollow);
    on<ThreadResolve>(_onResolve);
    on<ThreadUnresolve>(_onUnresolve);
    on<ThreadClearError>(_onClearError);
  }

  Future<void> _onLoad(ThreadLoad event, Emitter<ThreadState> emit) async {
    emit(state.copyWith(status: ThreadStatus.loading));
    try {
      final threads = await _repository.getThreads(
        event.channelId,
        page: event.page,
        perPage: event.perPage,
      );
      emit(state.copyWith(status: ThreadStatus.loaded, threads: threads));
    } catch (e) {
      debugPrint('ThreadBloc: Error loading threads: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(ThreadCreate event, Emitter<ThreadState> emit) async {
    emit(state.copyWith(status: ThreadStatus.loading));
    try {
      final thread = await _repository.createThread(event.data);
      final updated = [...state.threads, thread];
      emit(state.copyWith(status: ThreadStatus.loaded, threads: updated));
    } catch (e) {
      debugPrint('ThreadBloc: Error creating thread: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onSelectActive(ThreadSelectActive event, Emitter<ThreadState> emit) async {
    try {
      final thread = await _repository.getThread(event.threadId);
      emit(state.copyWith(activeThread: thread));
      // Also load replies
      add(ThreadLoadReplies(threadId: event.threadId));
    } catch (e) {
      debugPrint('ThreadBloc: Error selecting thread: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadReplies(ThreadLoadReplies event, Emitter<ThreadState> emit) async {
    try {
      final replyList = await _repository.getReplies(event.threadId, page: event.page);
      final updatedReplies = Map<String, List<ThreadReply>>.from(state.replies);
      updatedReplies[event.threadId] = replyList;
      emit(state.copyWith(replies: updatedReplies));
    } catch (e) {
      debugPrint('ThreadBloc: Error loading replies: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onAddReply(ThreadAddReply event, Emitter<ThreadState> emit) async {
    try {
      final reply = await _repository.addReply(event.threadId, event.data);
      final updatedReplies = Map<String, List<ThreadReply>>.from(state.replies);
      updatedReplies[event.threadId] = [...(updatedReplies[event.threadId] ?? []), reply];

      // Update reply count in thread
      final threads = state.threads.map((t) {
        if (t.id == event.threadId) {
          return t.copyWith(replyCount: t.replyCount + 1, lastReplyAt: DateTime.now());
        }
        return t;
      }).toList();

      final activeThread = state.activeThread?.id == event.threadId
          ? state.activeThread!.copyWith(replyCount: state.activeThread!.replyCount + 1)
          : state.activeThread;

      emit(state.copyWith(replies: updatedReplies, threads: threads, activeThread: activeThread));
    } catch (e) {
      debugPrint('ThreadBloc: Error adding reply: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onFollow(ThreadFollow event, Emitter<ThreadState> emit) async {
    try {
      await _repository.followThread(event.threadId);
      final threads = state.threads.map((t) {
        if (t.id == event.threadId) return t.copyWith(isFollowing: true);
        return t;
      }).toList();
      final activeThread = state.activeThread?.id == event.threadId
          ? state.activeThread!.copyWith(isFollowing: true)
          : state.activeThread;
      emit(state.copyWith(threads: threads, activeThread: activeThread));
    } catch (e) {
      debugPrint('ThreadBloc: Error following thread: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUnfollow(ThreadUnfollow event, Emitter<ThreadState> emit) async {
    try {
      await _repository.unfollowThread(event.threadId);
      final threads = state.threads.map((t) {
        if (t.id == event.threadId) return t.copyWith(isFollowing: false);
        return t;
      }).toList();
      final activeThread = state.activeThread?.id == event.threadId
          ? state.activeThread!.copyWith(isFollowing: false)
          : state.activeThread;
      emit(state.copyWith(threads: threads, activeThread: activeThread));
    } catch (e) {
      debugPrint('ThreadBloc: Error unfollowing thread: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onResolve(ThreadResolve event, Emitter<ThreadState> emit) async {
    try {
      await _repository.resolveThread(event.threadId);
      final threads = state.threads.map((t) {
        if (t.id == event.threadId) return t.copyWith(isResolved: true);
        return t;
      }).toList();
      final activeThread = state.activeThread?.id == event.threadId
          ? state.activeThread!.copyWith(isResolved: true)
          : state.activeThread;
      emit(state.copyWith(threads: threads, activeThread: activeThread));
    } catch (e) {
      debugPrint('ThreadBloc: Error resolving thread: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUnresolve(ThreadUnresolve event, Emitter<ThreadState> emit) async {
    try {
      await _repository.unresolveThread(event.threadId);
      final threads = state.threads.map((t) {
        if (t.id == event.threadId) return t.copyWith(isResolved: false);
        return t;
      }).toList();
      final activeThread = state.activeThread?.id == event.threadId
          ? state.activeThread!.copyWith(isResolved: false)
          : state.activeThread;
      emit(state.copyWith(threads: threads, activeThread: activeThread));
    } catch (e) {
      debugPrint('ThreadBloc: Error unresolving thread: $e');
      emit(state.copyWith(status: ThreadStatus.error, error: e.toString()));
    }
  }

  void _onClearError(ThreadClearError event, Emitter<ThreadState> emit) {
    emit(state.copyWith(status: ThreadStatus.loaded, error: null));
  }
}
