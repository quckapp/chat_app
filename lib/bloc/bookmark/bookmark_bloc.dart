import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/bookmark_repository.dart';
import 'bookmark_event.dart';
import 'bookmark_state.dart';

/// BLoC for managing bookmark operations
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkRepository _repository;

  BookmarkBloc({BookmarkRepository? repository})
      : _repository = repository ?? BookmarkRepository(),
        super(const BookmarkState()) {
    on<BookmarkLoad>(_onLoad);
    on<BookmarkCreate>(_onCreate);
    on<BookmarkDelete>(_onDelete);
    on<BookmarkLoadFolders>(_onLoadFolders);
    on<BookmarkCreateFolder>(_onCreateFolder);
    on<BookmarkDeleteFolder>(_onDeleteFolder);
    on<BookmarkClearError>(_onClearError);
  }

  Future<void> _onLoad(BookmarkLoad event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      final bookmarks = await _repository.getBookmarks(
        folderId: event.folderId,
        page: event.page,
        perPage: event.perPage,
      );
      emit(state.copyWith(status: BookmarkStatus.loaded, bookmarks: bookmarks));
    } catch (e) {
      debugPrint('BookmarkBloc: Error loading bookmarks: $e');
      emit(state.copyWith(status: BookmarkStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreate(BookmarkCreate event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      final bookmark = await _repository.createBookmark(event.data);
      final updated = [...state.bookmarks, bookmark];
      emit(state.copyWith(status: BookmarkStatus.loaded, bookmarks: updated));
    } catch (e) {
      debugPrint('BookmarkBloc: Error creating bookmark: $e');
      emit(state.copyWith(status: BookmarkStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDelete(BookmarkDelete event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      await _repository.deleteBookmark(event.bookmarkId);
      final bookmarks = state.bookmarks.where((b) => b.id != event.bookmarkId).toList();
      emit(state.copyWith(status: BookmarkStatus.loaded, bookmarks: bookmarks));
    } catch (e) {
      debugPrint('BookmarkBloc: Error deleting bookmark: $e');
      emit(state.copyWith(status: BookmarkStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadFolders(BookmarkLoadFolders event, Emitter<BookmarkState> emit) async {
    try {
      final folders = await _repository.getFolders();
      emit(state.copyWith(folders: folders));
    } catch (e) {
      debugPrint('BookmarkBloc: Error loading folders: $e');
      emit(state.copyWith(status: BookmarkStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateFolder(BookmarkCreateFolder event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      final folder = await _repository.createFolder(event.data);
      final updated = [...state.folders, folder];
      emit(state.copyWith(status: BookmarkStatus.loaded, folders: updated));
    } catch (e) {
      debugPrint('BookmarkBloc: Error creating folder: $e');
      emit(state.copyWith(status: BookmarkStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteFolder(BookmarkDeleteFolder event, Emitter<BookmarkState> emit) async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      await _repository.deleteFolder(event.folderId);
      final folders = state.folders.where((f) => f.id != event.folderId).toList();
      emit(state.copyWith(status: BookmarkStatus.loaded, folders: folders));
    } catch (e) {
      debugPrint('BookmarkBloc: Error deleting folder: $e');
      emit(state.copyWith(status: BookmarkStatus.error, error: e.toString()));
    }
  }

  void _onClearError(BookmarkClearError event, Emitter<BookmarkState> emit) {
    emit(state.copyWith(status: BookmarkStatus.loaded, error: null));
  }
}
