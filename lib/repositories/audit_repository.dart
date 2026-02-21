import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/audit_log.dart';
import '../models/serializable/audit_dto.dart';

/// Repository for audit log operations
class AuditRepository {
  final RestClient _client;

  AuditRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get audit logs with pagination and optional filters
  Future<List<AuditLogEntry>> getLogs({
    int page = 1,
    int perPage = 20,
    Map<String, dynamic>? filters,
  }) async {
    debugPrint('AuditRepository: Fetching audit logs page $page');
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (filters != null) {
      queryParams.addAll(filters);
    }
    final result = await _client.get(
      '/api/audit/logs',
      queryParams: queryParams,
      fromJson: AuditLogListDto.fromJson,
    );
    return result.items
        .map((dto) => AuditLogEntry.fromJson(dto.toJson()))
        .toList();
  }

  /// Get a single audit log entry
  Future<AuditLogEntry> getLog(String id) async {
    debugPrint('AuditRepository: Fetching audit log $id');
    return _client.get(
      '/api/audit/logs/$id',
      fromJson: (json) => AuditLogEntry.fromJson(json),
    );
  }

  /// Get available event types
  Future<List<String>> getEventTypes() async {
    debugPrint('AuditRepository: Fetching event types');
    return _client.getList(
      '/api/audit/event-types',
      fromJson: (json) => json['type'] as String? ?? json['name'] as String? ?? '',
    );
  }

  /// Get audit stats
  Future<AuditStatsDto> getStats() async {
    debugPrint('AuditRepository: Fetching audit stats');
    return _client.get(
      '/api/audit/stats',
      fromJson: (json) => AuditStatsDto.fromJson(json),
    );
  }
}
