import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/media_info.dart';

/// Repository for media operations
class MediaRepository {
  final RestClient _client;

  MediaRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Get media info
  Future<MediaInfo> getMediaInfo(String id) async {
    debugPrint('MediaRepository: Fetching media info for $id');
    return _client.get('/api/v1/media/$id', fromJson: (json) => MediaInfo.fromJson(json));
  }

  /// Delete media
  Future<void> deleteMedia(String id) async {
    await _client.delete('/api/v1/media/$id');
  }

  /// Get media thumbnail URL
  String getThumbnailUrl(String id) {
    return '${ApiConstants.kongBaseUrl}/api/v1/media/$id/thumbnail';
  }

  /// Get media stream URL
  String getStreamUrl(String id) {
    return '${ApiConstants.kongBaseUrl}/api/v1/media/$id/stream';
  }
}
