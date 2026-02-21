import 'package:json_annotation/json_annotation.dart';

part 'poll_dto.g.dart';

@JsonSerializable()
class PollDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final String question;
  final List<PollOptionDto> options;
  @JsonKey(name: 'is_anonymous')
  final bool isAnonymous;
  @JsonKey(name: 'allow_multiple')
  final bool allowMultiple;
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;
  @JsonKey(name: 'total_votes')
  final int totalVotes;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'is_closed')
  final bool isClosed;

  const PollDto({
    required this.id,
    required this.channelId,
    required this.createdBy,
    required this.question,
    this.options = const [],
    this.isAnonymous = false,
    this.allowMultiple = false,
    this.expiresAt,
    this.totalVotes = 0,
    this.createdAt,
    this.isClosed = false,
  });

  factory PollDto.fromJson(Map<String, dynamic> json) => _$PollDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PollDtoToJson(this);
}

@JsonSerializable()
class PollOptionDto {
  final String id;
  final String text;
  @JsonKey(name: 'vote_count')
  final int voteCount;
  @JsonKey(name: 'voter_ids')
  final List<String> voterIds;

  const PollOptionDto({
    required this.id,
    required this.text,
    this.voteCount = 0,
    this.voterIds = const [],
  });

  factory PollOptionDto.fromJson(Map<String, dynamic> json) => _$PollOptionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PollOptionDtoToJson(this);
}

@JsonSerializable()
class CreatePollDto {
  final String question;
  final List<String> options;
  @JsonKey(name: 'is_anonymous')
  final bool isAnonymous;
  @JsonKey(name: 'allow_multiple')
  final bool allowMultiple;
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  const CreatePollDto({
    required this.question,
    required this.options,
    this.isAnonymous = false,
    this.allowMultiple = false,
    this.expiresAt,
  });

  factory CreatePollDto.fromJson(Map<String, dynamic> json) => _$CreatePollDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePollDtoToJson(this);
}

@JsonSerializable()
class VotePollDto {
  @JsonKey(name: 'option_id')
  final String optionId;

  const VotePollDto({required this.optionId});

  factory VotePollDto.fromJson(Map<String, dynamic> json) => _$VotePollDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VotePollDtoToJson(this);
}
