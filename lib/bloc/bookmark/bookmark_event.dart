import 'package:equatable/equatable.dart';
import '../../models/serializable/bookmark_dto.dart';

/// Base class for all bookmark events
abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object?> get props => [];
}

/// Load bookmarks with optional folder filter
class BookmarkLoad extends BookmarkEvent {
  final String? folderId;
  final int page;
  final int perPage;

  const BookmarkLoad({this.folderId, this.page = 1, this.perPage = 20});

  @override
  List<Object?> get props => [folderId, page, perPage];
}

/// Create a new bookmark
class BookmarkCreate extends BookmarkEvent {
  final CreateBookmarkDto data;

  const BookmarkCreate({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Delete a bookmark
class BookmarkDelete extends BookmarkEvent {
  final String bookmarkId;

  const BookmarkDelete({required this.bookmarkId});

  @override
  List<Object?> get props => [bookmarkId];
}

/// Load bookmark folders
class BookmarkLoadFolders extends BookmarkEvent {
  const BookmarkLoadFolders();
}

/// Create a bookmark folder
class BookmarkCreateFolder extends BookmarkEvent {
  final CreateBookmarkFolderDto data;

  const BookmarkCreateFolder({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Delete a bookmark folder
class BookmarkDeleteFolder extends BookmarkEvent {
  final String folderId;

  const BookmarkDeleteFolder({required this.folderId});

  @override
  List<Object?> get props => [folderId];
}

/// Clear error state
class BookmarkClearError extends BookmarkEvent {
  const BookmarkClearError();
}
