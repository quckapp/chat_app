import 'package:equatable/equatable.dart';
import '../../models/serializable/thread_dto.dart';

/// Base class for all thread events
abstract class ThreadEvent extends Equatable {
  const ThreadEvent();

  @override
  List<Object?> get props => [];
}

/// Load threads for a channel
class ThreadLoad extends ThreadEvent {
  final String channelId;
  final int page;
  final int perPage;

  const ThreadLoad({required this.channelId, this.page = 1, this.perPage = 20});

  @override
  List<Object?> get props => [channelId, page, perPage];
}

/// Create a new thread
class ThreadCreate extends ThreadEvent {
  final CreateThreadDto data;

  const ThreadCreate({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Select active thread and load its replies
class ThreadSelectActive extends ThreadEvent {
  final String threadId;

  const ThreadSelectActive({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

/// Load replies for a thread
class ThreadLoadReplies extends ThreadEvent {
  final String threadId;
  final int page;

  const ThreadLoadReplies({required this.threadId, this.page = 1});

  @override
  List<Object?> get props => [threadId, page];
}

/// Add a reply to a thread
class ThreadAddReply extends ThreadEvent {
  final String threadId;
  final CreateThreadReplyDto data;

  const ThreadAddReply({required this.threadId, required this.data});

  @override
  List<Object?> get props => [threadId, data];
}

/// Follow a thread
class ThreadFollow extends ThreadEvent {
  final String threadId;

  const ThreadFollow({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

/// Unfollow a thread
class ThreadUnfollow extends ThreadEvent {
  final String threadId;

  const ThreadUnfollow({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

/// Resolve a thread
class ThreadResolve extends ThreadEvent {
  final String threadId;

  const ThreadResolve({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

/// Unresolve a thread
class ThreadUnresolve extends ThreadEvent {
  final String threadId;

  const ThreadUnresolve({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

/// Clear error state
class ThreadClearError extends ThreadEvent {
  const ThreadClearError();
}
