import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/realtime_rest_dto.dart';

/// Repository for realtime REST operations
class RealtimeRestRepository {
  final RestClient _client;

  RealtimeRestRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get connected devices
  Future<List<RealtimeDeviceDto>> getDevices() async {
    debugPrint('RealtimeRestRepository: Fetching connected devices');
    return _client.getList(
      '/api/realtime/devices',
      fromJson: (json) => RealtimeDeviceDto.fromJson(json),
    );
  }

  /// Send a signaling message
  Future<void> sendSignal(SignalingDto data) async {
    debugPrint('RealtimeRestRepository: Sending signal to ${data.targetUserId}');
    await _client.postVoid(
      '/api/realtime/signal',
      data: data.toJson(),
    );
  }
}
