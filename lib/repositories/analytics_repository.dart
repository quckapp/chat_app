import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/analytics_dto.dart';

/// Repository for analytics operations
class AnalyticsRepository {
  final RestClient _client;

  AnalyticsRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Track an analytics event
  Future<void> trackEvent(AnalyticsEventDto data) async {
    debugPrint('AnalyticsRepository: Tracking event ${data.event}');
    await _client.postVoid(
      '/api/v1/analytics',
      data: data.toJson(),
    );
  }

  /// Get analytics results
  Future<AnalyticsResultDto> getResults(String metric, String period) async {
    debugPrint('AnalyticsRepository: Fetching results for $metric ($period)');
    return _client.get(
      '/api/v1/analytics',
      queryParams: {'metric': metric, 'period': period},
      fromJson: (json) => AnalyticsResultDto.fromJson(json),
    );
  }
}
