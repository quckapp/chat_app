// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultDto _$SearchResultDtoFromJson(Map<String, dynamic> json) =>
    SearchResultDto(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      snippet: json['snippet'] as String?,
      channelId: json['channel_id'] as String?,
      channelName: json['channel_name'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SearchResultDtoToJson(SearchResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'snippet': instance.snippet,
      'channel_id': instance.channelId,
      'channel_name': instance.channelName,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'created_at': instance.createdAt?.toIso8601String(),
      'score': instance.score,
    };

SearchQueryDto _$SearchQueryDtoFromJson(Map<String, dynamic> json) =>
    SearchQueryDto(
      query: json['query'] as String,
      type: json['type'] as String?,
      channelId: json['channel_id'] as String?,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$SearchQueryDtoToJson(SearchQueryDto instance) =>
    <String, dynamic>{
      'query': instance.query,
      'type': instance.type,
      'channel_id': instance.channelId,
      'page': instance.page,
      'per_page': instance.perPage,
    };
