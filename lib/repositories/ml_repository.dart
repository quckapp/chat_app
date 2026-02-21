import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/ml_dto.dart';

/// Repository for ML operations
class MLRepository {
  final RestClient _client;

  MLRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get a prediction
  Future<MLPredictionDto> predict(MLPredictionDto data) async {
    debugPrint('MLRepository: Requesting prediction of type ${data.type}');
    return _client.post(
      '/api/v1/ml/predict',
      data: data.toJson(),
      fromJson: (json) => MLPredictionDto.fromJson(json),
    );
  }

  /// Get smart replies for a message
  Future<SmartReplyDto> getSmartReplies(String messageId) async {
    debugPrint('MLRepository: Fetching smart replies for message $messageId');
    return _client.get(
      '/api/v1/ml/smart-replies/$messageId',
      fromJson: (json) => SmartReplyDto.fromJson(json),
    );
  }
}
