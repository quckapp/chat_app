import 'package:equatable/equatable.dart';
import '../../models/search_result.dart';

/// Status of search operations
enum SearchStatus { initial, loading, loaded, error }

/// State for the search BLoC
class SearchState extends Equatable {
  final SearchStatus status;
  final String query;
  final List<SearchResult> results;
  final String? filterType;
  final String? filterChannelId;
  final bool hasMore;
  final int page;
  final String? error;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.filterType,
    this.filterChannelId,
    this.hasMore = false,
    this.page = 1,
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == SearchStatus.loading;

  /// Whether there's an error
  bool get hasError => status == SearchStatus.error && error != null;

  /// Whether there are results
  bool get hasResults => results.isNotEmpty;

  /// Get results filtered by type
  List<SearchResult> resultsByType(SearchResultType type) =>
      results.where((r) => r.type == type).toList();

  /// Get message results
  List<SearchResult> get messageResults => resultsByType(SearchResultType.message);

  /// Get user results
  List<SearchResult> get userResults => resultsByType(SearchResultType.user);

  /// Get channel results
  List<SearchResult> get channelResults => resultsByType(SearchResultType.channel);

  /// Get file results
  List<SearchResult> get fileResults => resultsByType(SearchResultType.file);

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<SearchResult>? results,
    String? filterType,
    String? filterChannelId,
    bool? hasMore,
    int? page,
    String? error,
    bool clearFilterType = false,
    bool clearFilterChannelId = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      filterChannelId: clearFilterChannelId ? null : (filterChannelId ?? this.filterChannelId),
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status, query, results, filterType, filterChannelId, hasMore, page, error,
      ];
}
