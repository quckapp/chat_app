import 'package:equatable/equatable.dart';

/// Base class for all search events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Query text changed (debounced)
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Filter changed (type filter)
class SearchFilterChanged extends SearchEvent {
  final String? type;
  final String? channelId;

  const SearchFilterChanged({this.type, this.channelId});

  @override
  List<Object?> get props => [type, channelId];
}

/// Clear all search results
class SearchClearResults extends SearchEvent {
  const SearchClearResults();
}

/// Load more results (pagination)
class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}
