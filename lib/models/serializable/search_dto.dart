import 'package:json_annotation/json_annotation.dart';

part 'search_dto.g.dart';

@JsonSerializable()
class SearchResultDto {
  final String id;
  final String type;
  final String title;
  final String? snippet;
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'channel_name')
  final String? channelName;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'user_name')
  final String? userName;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final double score;

  const SearchResultDto({
    required this.id,
    required this.type,
    required this.title,
    this.snippet,
    this.channelId,
    this.channelName,
    this.userId,
    this.userName,
    this.createdAt,
    this.score = 0.0,
  });

  factory SearchResultDto.fromJson(Map<String, dynamic> json) => _$SearchResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultDtoToJson(this);
}

@JsonSerializable()
class SearchQueryDto {
  final String query;
  final String? type;
  @JsonKey(name: 'channel_id')
  final String? channelId;
  final int page;
  @JsonKey(name: 'per_page')
  final int perPage;

  const SearchQueryDto({
    required this.query,
    this.type,
    this.channelId,
    this.page = 1,
    this.perPage = 20,
  });

  factory SearchQueryDto.fromJson(Map<String, dynamic> json) => _$SearchQueryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SearchQueryDtoToJson(this);
}

/// Paginated search response with facets
class SearchResponseDto {
  final List<SearchResultDto> results;
  final int total;
  final int page;
  final int perPage;
  final Map<String, dynamic> facets;

  const SearchResponseDto({
    required this.results,
    required this.total,
    this.page = 1,
    this.perPage = 20,
    this.facets = const {},
  });

  factory SearchResponseDto.fromJson(Map<String, dynamic> json) {
    final items = json['results'] ?? json['data'] ?? json['items'] ?? [];
    return SearchResponseDto(
      results: (items as List<dynamic>)
          .map((e) => SearchResultDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      facets: (json['facets'] as Map<String, dynamic>?) ?? {},
    );
  }
}
