// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollDto _$PollDtoFromJson(Map<String, dynamic> json) => PollDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      createdBy: json['created_by'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => PollOptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      allowMultiple: json['allow_multiple'] as bool? ?? false,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      totalVotes: (json['total_votes'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      isClosed: json['is_closed'] as bool? ?? false,
    );

Map<String, dynamic> _$PollDtoToJson(PollDto instance) => <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'created_by': instance.createdBy,
      'question': instance.question,
      'options': instance.options,
      'is_anonymous': instance.isAnonymous,
      'allow_multiple': instance.allowMultiple,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'total_votes': instance.totalVotes,
      'created_at': instance.createdAt?.toIso8601String(),
      'is_closed': instance.isClosed,
    };

PollOptionDto _$PollOptionDtoFromJson(Map<String, dynamic> json) =>
    PollOptionDto(
      id: json['id'] as String,
      text: json['text'] as String,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      voterIds: (json['voter_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PollOptionDtoToJson(PollOptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'vote_count': instance.voteCount,
      'voter_ids': instance.voterIds,
    };

CreatePollDto _$CreatePollDtoFromJson(Map<String, dynamic> json) =>
    CreatePollDto(
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      allowMultiple: json['allow_multiple'] as bool? ?? false,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$CreatePollDtoToJson(CreatePollDto instance) =>
    <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'is_anonymous': instance.isAnonymous,
      'allow_multiple': instance.allowMultiple,
      'expires_at': instance.expiresAt?.toIso8601String(),
    };

VotePollDto _$VotePollDtoFromJson(Map<String, dynamic> json) => VotePollDto(
      optionId: json['option_id'] as String,
    );

Map<String, dynamic> _$VotePollDtoToJson(VotePollDto instance) =>
    <String, dynamic>{
      'option_id': instance.optionId,
    };
