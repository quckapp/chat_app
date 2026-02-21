import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/bookmark.dart';
import '../models/serializable/bookmark_dto.dart';

/// Repository for bookmark operations
class BookmarkRepository {
  final RestClient _client;

  BookmarkRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List bookmarks with optional folder filter
  Future<List<Bookmark>> getBookmarks({String? folderId, int page = 1, int perPage = 20}) async {
    debugPrint('BookmarkRepository: Fetching bookmarks');
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (folderId != null) {
      queryParams['folder_id'] = folderId;
    }
    final result = await _client.get(
      '/api/bookmarks',
      queryParams: queryParams,
      fromJson: BookmarkListDto.fromJson,
    );
    return result.bookmarks.map((dto) => Bookmark.fromJson(dto.toJson())).toList();
  }

  /// Get a single bookmark
  Future<Bookmark> getBookmark(String id) async {
    return _client.get('/api/bookmarks/$id', fromJson: (json) => Bookmark.fromJson(json));
  }

  /// Create a bookmark
  Future<Bookmark> createBookmark(CreateBookmarkDto data) async {
    return _client.post('/api/bookmarks', data: data.toJson(), fromJson: (json) => Bookmark.fromJson(json));
  }

  /// Delete a bookmark
  Future<void> deleteBookmark(String id) async {
    await _client.delete('/api/bookmarks/$id');
  }

  /// List bookmark folders
  Future<List<BookmarkFolder>> getFolders() async {
    debugPrint('BookmarkRepository: Fetching bookmark folders');
    return _client.getList(
      '/api/bookmarks/folders',
      fromJson: (json) => BookmarkFolder.fromJson(json),
    );
  }

  /// Create a bookmark folder
  Future<BookmarkFolder> createFolder(CreateBookmarkFolderDto data) async {
    return _client.post(
      '/api/bookmarks/folders',
      data: data.toJson(),
      fromJson: (json) => BookmarkFolder.fromJson(json),
    );
  }

  /// Update a bookmark folder
  Future<BookmarkFolder> updateFolder(String id, CreateBookmarkFolderDto data) async {
    return _client.put(
      '/api/bookmarks/folders/$id',
      data: data.toJson(),
      fromJson: (json) => BookmarkFolder.fromJson(json),
    );
  }

  /// Delete a bookmark folder
  Future<void> deleteFolder(String id) async {
    await _client.delete('/api/bookmarks/folders/$id');
  }
}
