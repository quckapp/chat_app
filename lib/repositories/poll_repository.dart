import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/poll.dart';
import '../models/serializable/poll_dto.dart';

/// Repository for poll operations
class PollRepository {
  final RestClient _client;

  PollRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get polls for a channel
  Future<List<Poll>> getPolls(String channelId) async {
    debugPrint('PollRepository: Fetching polls for channel $channelId');
    return _client.getList(
      '/api/v1/channels/$channelId/polls',
      fromJson: (json) => Poll.fromJson(json),
    );
  }

  /// Create a new poll in a channel
  Future<Poll> createPoll(String channelId, CreatePollDto data) async {
    debugPrint('PollRepository: Creating poll in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/polls',
      data: data.toJson(),
      fromJson: (json) => Poll.fromJson(json),
    );
  }

  /// Vote on a poll option
  Future<Poll> votePoll(String channelId, String pollId, VotePollDto data) async {
    debugPrint('PollRepository: Voting on poll $pollId in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/polls/$pollId/vote',
      data: data.toJson(),
      fromJson: (json) => Poll.fromJson(json),
    );
  }

  /// Close a poll
  Future<Poll> closePoll(String channelId, String pollId) async {
    debugPrint('PollRepository: Closing poll $pollId in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/polls/$pollId/close',
      fromJson: (json) => Poll.fromJson(json),
    );
  }
}
