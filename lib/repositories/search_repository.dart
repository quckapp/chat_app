import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/search_result.dart';
import '../models/serializable/search_dto.dart';

/// Repository for search operations
class SearchRepository {
  final RestClient _client;

  SearchRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// Search across all types
  Future<SearchResponseDto> searchAll(String query, {int page = 1, int perPage = 20}) async {
    debugPrint('SearchRepository: Searching all for "$query"');
    return _client.get(
      '/api/v1/search',
      queryParams: {'q': query, 'page': page, 'per_page': perPage},
      fromJson: SearchResponseDto.fromJson,
    );
  }

  /// Search messages
  Future<List<SearchResult>> searchMessages(String query, {String? channelId, int page = 1, int perPage = 20}) async {
    debugPrint('SearchRepository: Searching messages for "$query"');
    final queryParams = <String, dynamic>{
      'q': query,
      'type': 'message',
      'page': page,
      'per_page': perPage,
    };
    if (channelId != null) {
      queryParams['channel_id'] = channelId;
    }
    final result = await _client.get(
      '/api/v1/search',
      queryParams: queryParams,
      fromJson: SearchResponseDto.fromJson,
    );
    return result.results.map((dto) => SearchResult.fromJson(dto.toJson())).toList();
  }

  /// Search users
  Future<List<SearchResult>> searchUsers(String query, {int page = 1, int perPage = 20}) async {
    debugPrint('SearchRepository: Searching users for "$query"');
    final result = await _client.get(
      '/api/v1/search',
      queryParams: {'q': query, 'type': 'user', 'page': page, 'per_page': perPage},
      fromJson: SearchResponseDto.fromJson,
    );
    return result.results.map((dto) => SearchResult.fromJson(dto.toJson())).toList();
  }

  /// Search channels
  Future<List<SearchResult>> searchChannels(String query, {int page = 1, int perPage = 20}) async {
    debugPrint('SearchRepository: Searching channels for "$query"');
    final result = await _client.get(
      '/api/v1/search',
      queryParams: {'q': query, 'type': 'channel', 'page': page, 'per_page': perPage},
      fromJson: SearchResponseDto.fromJson,
    );
    return result.results.map((dto) => SearchResult.fromJson(dto.toJson())).toList();
  }

  /// Search files
  Future<List<SearchResult>> searchFiles(String query, {int page = 1, int perPage = 20}) async {
    debugPrint('SearchRepository: Searching files for "$query"');
    final result = await _client.get(
      '/api/v1/search',
      queryParams: {'q': query, 'type': 'file', 'page': page, 'per_page': perPage},
      fromJson: SearchResponseDto.fromJson,
    );
    return result.results.map((dto) => SearchResult.fromJson(dto.toJson())).toList();
  }
}
