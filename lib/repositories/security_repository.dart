import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/role.dart';
import '../models/serializable/security_dto.dart';

/// Repository for security operations
class SecurityRepository {
  final RestClient _client;

  SecurityRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get security report
  Future<SecurityReportDto> getReport() async {
    debugPrint('SecurityRepository: Fetching security report');
    return _client.get(
      '/api/security/report',
      fromJson: (json) => SecurityReportDto.fromJson(json),
    );
  }

  /// Get security policies
  Future<List<SecurityPolicy>> getPolicies() async {
    debugPrint('SecurityRepository: Fetching security policies');
    return _client.getList(
      '/api/security/policies',
      fromJson: (json) => SecurityPolicy.fromJson(json),
    );
  }

  /// Update a security policy
  Future<SecurityPolicy> updatePolicy(String id, SecurityPolicyDto data) async {
    debugPrint('SecurityRepository: Updating policy $id');
    return _client.put(
      '/api/security/policies/$id',
      data: data.toJson(),
      fromJson: (json) => SecurityPolicy.fromJson(json),
    );
  }

  /// Get threats with pagination
  Future<List<ThreatDto>> getThreats({int page = 1, int perPage = 20}) async {
    debugPrint('SecurityRepository: Fetching threats page $page');
    return _client.getList(
      '/api/security/threats',
      queryParams: {'page': page, 'per_page': perPage},
      fromJson: (json) => ThreatDto.fromJson(json),
    );
  }
}
