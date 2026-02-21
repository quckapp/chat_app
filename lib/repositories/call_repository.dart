import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/call_dto.dart';

/// Repository for call operations
class CallRepository {
  final RestClient _client;

  CallRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Initiate a call
  Future<CallDto> initiateCall(InitiateCallDto data) async {
    debugPrint('CallRepository: Initiating call');
    return _client.post(
      '/api/v1/calls',
      data: data.toJson(),
      fromJson: (json) => CallDto.fromJson(json),
    );
  }

  /// Answer a call
  Future<CallDto> answerCall(String callId) async {
    return _client.post(
      '/api/v1/calls/$callId/answer',
      fromJson: (json) => CallDto.fromJson(json),
    );
  }

  /// Reject a call
  Future<void> rejectCall(String callId) async {
    await _client.postVoid('/api/v1/calls/$callId/reject');
  }

  /// End a call
  Future<void> endCall(String callId) async {
    await _client.postVoid('/api/v1/calls/$callId/end');
  }

  /// Get call info
  Future<CallDto> getCallInfo(String callId) async {
    return _client.get('/api/v1/calls/$callId', fromJson: (json) => CallDto.fromJson(json));
  }

  /// Get call history
  Future<List<CallDto>> getCallHistory({int page = 1, int perPage = 20}) async {
    debugPrint('CallRepository: Fetching call history');
    final result = await _client.get(
      '/api/v1/calls',
      queryParams: {'page': page, 'per_page': perPage},
      fromJson: CallHistoryDto.fromJson,
    );
    return result.calls;
  }

  /// Get LiveKit participant token for a call.
  /// Returns a map with `token` and `url` fields needed to connect to
  /// the LiveKit room associated with the given call.
  Future<CallTokenDto> getCallToken(String callId) async {
    debugPrint('CallRepository: Fetching LiveKit token for call $callId');
    return _client.post(
      '/api/v1/calls/$callId/token',
      fromJson: (json) => CallTokenDto.fromJson(json),
    );
  }
}
