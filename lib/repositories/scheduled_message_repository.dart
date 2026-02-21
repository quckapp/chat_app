import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/scheduled_message.dart';
import '../models/serializable/scheduled_message_dto.dart';

/// Repository for scheduled message operations
class ScheduledMessageRepository {
  final RestClient _client;

  ScheduledMessageRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get scheduled messages for a channel
  Future<List<ScheduledMessage>> getScheduledMessages(String channelId) async {
    debugPrint('ScheduledMessageRepository: Fetching scheduled messages for channel $channelId');
    final result = await _client.get(
      '/api/v1/channels/$channelId/scheduled-messages',
      fromJson: ScheduledMessageListDto.fromJson,
    );
    return result.items
        .map((dto) => ScheduledMessage.fromJson(dto.toJson()))
        .toList();
  }

  /// Create a scheduled message
  Future<ScheduledMessage> createScheduledMessage(
      String channelId, CreateScheduledMessageDto data) async {
    debugPrint('ScheduledMessageRepository: Creating scheduled message in channel $channelId');
    return _client.post(
      '/api/v1/channels/$channelId/scheduled-messages',
      data: data.toJson(),
      fromJson: (json) => ScheduledMessage.fromJson(json),
    );
  }

  /// Update a scheduled message
  Future<ScheduledMessage> updateScheduledMessage(
      String channelId, String messageId, Map<String, dynamic> data) async {
    debugPrint('ScheduledMessageRepository: Updating scheduled message $messageId');
    return _client.put(
      '/api/v1/channels/$channelId/scheduled-messages/$messageId',
      data: data,
      fromJson: (json) => ScheduledMessage.fromJson(json),
    );
  }

  /// Cancel a scheduled message
  Future<void> cancelScheduledMessage(String channelId, String messageId) async {
    debugPrint('ScheduledMessageRepository: Cancelling scheduled message $messageId');
    await _client.delete('/api/v1/channels/$channelId/scheduled-messages/$messageId');
  }
}
