import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/file_info.dart';
import '../models/serializable/file_dto.dart';

/// Repository for file operations
class FileRepository {
  final RestClient _client;

  FileRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List files
  Future<List<FileInfo>> getFiles({String? workspaceId, String? channelId, int page = 1, int perPage = 20}) async {
    debugPrint('FileRepository: Fetching files');
    final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};
    if (workspaceId != null) queryParams['workspace_id'] = workspaceId;
    if (channelId != null) queryParams['channel_id'] = channelId;

    final result = await _client.get(
      '/api/v1/files',
      queryParams: queryParams,
      fromJson: FileListDto.fromJson,
    );
    return result.files.map((dto) => FileInfo.fromJson(dto.toJson())).toList();
  }

  /// Get a single file
  Future<FileInfo> getFile(String id) async {
    return _client.get('/api/v1/files/$id', fromJson: (json) => FileInfo.fromJson(json));
  }

  /// Delete a file
  Future<void> deleteFile(String id) async {
    await _client.delete('/api/v1/files/$id');
  }

  /// Share a file
  Future<void> shareFile(String id, FileShareDto data) async {
    await _client.postVoid('/api/v1/files/$id/share', data: data.toJson());
  }
}
