import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/serializable/export_dto.dart';

/// Repository for export operations
class ExportRepository {
  final RestClient _client;

  ExportRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Request a new export
  Future<ExportStatusDto> requestExport(ExportRequestDto data) async {
    debugPrint('ExportRepository: Requesting export of type ${data.type}');
    return _client.post(
      '/api/v1/export',
      data: data.toJson(),
      fromJson: (json) => ExportStatusDto.fromJson(json),
    );
  }

  /// Get export status
  Future<ExportStatusDto> getExportStatus(String id) async {
    debugPrint('ExportRepository: Fetching export status for $id');
    return _client.get(
      '/api/v1/export/$id',
      fromJson: (json) => ExportStatusDto.fromJson(json),
    );
  }
}
