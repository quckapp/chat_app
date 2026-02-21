import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/thread.dart';
import '../models/serializable/thread_dto.dart';

/// Repository for thread operations
class ThreadRepository {
  final RestClient _client;

  ThreadRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List threads for a channel
  Future<List<Thread>> getThreads(String channelId, {int page = 1, int perPage = 20}) async {
    debugPrint('ThreadRepository: Fetching threads for channel $channelId');
    final result = await _client.get(
      '/api/v1/threads',
      queryParams: {'channel_id': channelId, 'page': page, 'per_page': perPage},
      fromJson: ThreadListDto.fromJson,
    );
    return result.threads.map((dto) => Thread.fromJson(dto.toJson())).toList();
  }

  /// Get a single thread
  Future<Thread> getThread(String id) async {
    return _client.get('/api/v1/threads/$id', fromJson: (json) => Thread.fromJson(json));
  }

  /// Create a thread
  Future<Thread> createThread(CreateThreadDto data) async {
    return _client.post('/api/v1/threads', data: data.toJson(), fromJson: (json) => Thread.fromJson(json));
  }

  /// Get replies for a thread
  Future<List<ThreadReply>> getReplies(String threadId, {int page = 1, int perPage = 50}) async {
    return _client.getList(
      '/api/v1/threads/$threadId/replies',
      queryParams: {'page': page, 'per_page': perPage},
      fromJson: (json) => ThreadReply.fromJson(json),
    );
  }

  /// Add a reply to a thread
  Future<ThreadReply> addReply(String threadId, CreateThreadReplyDto data) async {
    return _client.post(
      '/api/v1/threads/$threadId/replies',
      data: data.toJson(),
      fromJson: (json) => ThreadReply.fromJson(json),
    );
  }

  /// Follow a thread
  Future<void> followThread(String threadId) async {
    await _client.postVoid('/api/v1/threads/$threadId/follow');
  }

  /// Unfollow a thread
  Future<void> unfollowThread(String threadId) async {
    await _client.postVoid('/api/v1/threads/$threadId/unfollow');
  }

  /// Resolve a thread
  Future<void> resolveThread(String threadId) async {
    await _client.postVoid('/api/v1/threads/$threadId/resolve');
  }

  /// Unresolve a thread
  Future<void> unresolveThread(String threadId) async {
    await _client.postVoid('/api/v1/threads/$threadId/unresolve');
  }
}
