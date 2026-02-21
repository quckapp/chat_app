import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/huddle.dart';
import '../models/serializable/huddle_dto.dart';

/// Repository for huddle operations
class HuddleRepository {
  final RestClient _client;

  HuddleRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Create a huddle
  Future<Huddle> createHuddle(CreateHuddleDto data) async {
    debugPrint('HuddleRepository: Creating huddle');
    return _client.post(
      '/api/v1/huddles',
      data: data.toJson(),
      fromJson: (json) => Huddle.fromJson(json),
    );
  }

  /// Get a huddle
  Future<Huddle> getHuddle(String id) async {
    return _client.get('/api/v1/huddles/$id', fromJson: (json) => Huddle.fromJson(json));
  }

  /// Join a huddle
  Future<Huddle> joinHuddle(String huddleId) async {
    return _client.post(
      '/api/v1/huddles/$huddleId/join',
      fromJson: (json) => Huddle.fromJson(json),
    );
  }

  /// Leave a huddle
  Future<void> leaveHuddle(String huddleId) async {
    await _client.postVoid('/api/v1/huddles/$huddleId/leave');
  }

  /// Get active huddles for a channel
  Future<List<Huddle>> getActiveHuddles({String? channelId}) async {
    debugPrint('HuddleRepository: Fetching active huddles');
    final queryParams = <String, dynamic>{
      'status': 'active',
    };
    if (channelId != null) {
      queryParams['channel_id'] = channelId;
    }
    final result = await _client.get(
      '/api/v1/huddles',
      queryParams: queryParams,
      fromJson: HuddleListDto.fromJson,
    );
    return result.huddles.map((dto) => Huddle.fromJson(dto.toJson())).toList();
  }
}
