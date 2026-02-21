import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/channel.dart';
import '../models/pin.dart';
import '../models/serializable/channel_dto.dart';

/// Repository for channel operations
class ChannelRepository {
  final RestClient _client;

  ChannelRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List channels for a workspace
  Future<List<Channel>> getChannels(String workspaceId, {int page = 1, int perPage = 20}) async {
    debugPrint('ChannelRepository: Fetching channels for workspace $workspaceId');
    final result = await _client.get(
      '/api/v1/channels',
      queryParams: {'workspace_id': workspaceId, 'page': page, 'per_page': perPage},
      fromJson: ChannelListDto.fromJson,
    );
    return result.channels.map((dto) => Channel.fromJson(dto.toJson())).toList();
  }

  /// Get a single channel
  Future<Channel> getChannel(String id) async {
    return _client.get('/api/v1/channels/$id', fromJson: (json) => Channel.fromJson(json));
  }

  /// Create a channel
  Future<Channel> createChannel(CreateChannelDto data) async {
    return _client.post('/api/v1/channels', data: data.toJson(), fromJson: (json) => Channel.fromJson(json));
  }

  /// Update a channel
  Future<Channel> updateChannel(String id, UpdateChannelDto data) async {
    return _client.put('/api/v1/channels/$id', data: data.toJson(), fromJson: (json) => Channel.fromJson(json));
  }

  /// Delete a channel
  Future<void> deleteChannel(String id) async {
    await _client.delete('/api/v1/channels/$id');
  }

  /// Join a channel
  Future<void> joinChannel(String channelId) async {
    await _client.postVoid('/api/v1/channels/$channelId/join');
  }

  /// Leave a channel
  Future<void> leaveChannel(String channelId) async {
    await _client.postVoid('/api/v1/channels/$channelId/leave');
  }

  /// Get channel members
  Future<List<ChannelMember>> getMembers(String channelId) async {
    return _client.getList(
      '/api/v1/channels/$channelId/members',
      fromJson: (json) => ChannelMember.fromJson(json),
    );
  }

  /// Add member to channel
  Future<void> addMember(String channelId, String userId) async {
    await _client.postVoid('/api/v1/channels/$channelId/members', data: {'user_id': userId});
  }

  /// Remove member from channel
  Future<void> removeMember(String channelId, String userId) async {
    await _client.delete('/api/v1/channels/$channelId/members/$userId');
  }

  /// Get pinned messages
  Future<List<PinnedMessage>> getPins(String channelId) async {
    return _client.getList(
      '/api/v1/channels/$channelId/pins',
      fromJson: (json) => PinnedMessage.fromJson(json),
    );
  }

  /// Pin a message
  Future<void> pinMessage(String channelId, String messageId) async {
    await _client.postVoid('/api/v1/channels/$channelId/pins', data: {'message_id': messageId});
  }

  /// Unpin a message
  Future<void> unpinMessage(String channelId, String pinId) async {
    await _client.delete('/api/v1/channels/$channelId/pins/$pinId');
  }
}
