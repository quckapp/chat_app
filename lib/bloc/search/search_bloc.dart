import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/search_result.dart';
import '../../repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

/// BLoC for managing search operations with debouncing
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;
  Timer? _debounceTimer;

  SearchBloc({SearchRepository? repository})
      : _repository = repository ?? SearchRepository(),
        super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchFilterChanged>(_onFilterChanged);
    on<SearchClearResults>(_onClearResults);
    on<SearchLoadMore>(_onLoadMore);
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    _debounceTimer?.cancel();

    final query = event.query.trim();
    if (query.isEmpty) {
      emit(state.copyWith(
        status: SearchStatus.initial,
        query: '',
        results: [],
        hasMore: false,
        page: 1,
      ));
      return;
    }

    emit(state.copyWith(query: query, status: SearchStatus.loading, page: 1));

    // Debounce the actual API call
    final completer = Completer<void>();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final response = await _repository.searchAll(query, page: 1);
        final results = response.results
            .map((dto) => SearchResult.fromJson(dto.toJson()))
            .toList();
        emit(state.copyWith(
          status: SearchStatus.loaded,
          results: results,
          hasMore: results.length < response.total,
          page: 1,
        ));
      } catch (e) {
        debugPrint('SearchBloc: Error searching: $e');
        emit(state.copyWith(status: SearchStatus.error, error: e.toString()));
      }
      completer.complete();
    });

    await completer.future;
  }

  Future<void> _onFilterChanged(SearchFilterChanged event, Emitter<SearchState> emit) async {
    emit(state.copyWith(
      filterType: event.type,
      filterChannelId: event.channelId,
      clearFilterType: event.type == null,
      clearFilterChannelId: event.channelId == null,
    ));

    // Re-run search with new filters if query exists
    if (state.query.isNotEmpty) {
      add(SearchQueryChanged(query: state.query));
    }
  }

  void _onClearResults(SearchClearResults event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }

  Future<void> _onLoadMore(SearchLoadMore event, Emitter<SearchState> emit) async {
    if (!state.hasMore || state.isLoading) return;

    final nextPage = state.page + 1;
    emit(state.copyWith(status: SearchStatus.loading));

    try {
      final response = await _repository.searchAll(state.query, page: nextPage);
      final newResults = response.results
          .map((dto) => SearchResult.fromJson(dto.toJson()))
          .toList();
      final allResults = [...state.results, ...newResults];
      emit(state.copyWith(
        status: SearchStatus.loaded,
        results: allResults,
        hasMore: allResults.length < response.total,
        page: nextPage,
      ));
    } catch (e) {
      debugPrint('SearchBloc: Error loading more results: $e');
      emit(state.copyWith(status: SearchStatus.error, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
