import 'package:equatable/equatable.dart';
import '../../models/bookmark.dart';

/// Status of bookmark operations
enum BookmarkStatus { initial, loading, loaded, error }

/// State for the bookmark BLoC
class BookmarkState extends Equatable {
  final BookmarkStatus status;
  final List<Bookmark> bookmarks;
  final List<BookmarkFolder> folders;
  final String? error;

  const BookmarkState({
    this.status = BookmarkStatus.initial,
    this.bookmarks = const [],
    this.folders = const [],
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == BookmarkStatus.loading;

  /// Whether there's an error
  bool get hasError => status == BookmarkStatus.error && error != null;

  BookmarkState copyWith({
    BookmarkStatus? status,
    List<Bookmark>? bookmarks,
    List<BookmarkFolder>? folders,
    String? error,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      bookmarks: bookmarks ?? this.bookmarks,
      folders: folders ?? this.folders,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, bookmarks, folders, error];
}
