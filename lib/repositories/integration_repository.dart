import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/integration_dto.dart';

/// Repository for integration operations
class IntegrationRepository {
  final RestClient _client;

  IntegrationRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get all integrations
  Future<List<IntegrationDto>> getIntegrations() async {
    debugPrint('IntegrationRepository: Fetching integrations');
    return _client.getList(
      '/api/v1/integrations',
      fromJson: (json) => IntegrationDto.fromJson(json),
    );
  }

  /// Get a single integration by ID
  Future<IntegrationDto> getIntegration(String id) async {
    debugPrint('IntegrationRepository: Fetching integration $id');
    return _client.get(
      '/api/v1/integrations/$id',
      fromJson: (json) => IntegrationDto.fromJson(json),
    );
  }

  /// Update integration config
  Future<IntegrationDto> updateConfig(
      String id, Map<String, dynamic> config) async {
    debugPrint('IntegrationRepository: Updating integration $id config');
    return _client.put(
      '/api/v1/integrations/$id/config',
      data: config,
      fromJson: (json) => IntegrationDto.fromJson(json),
    );
  }
}
