import 'package:json_annotation/json_annotation.dart';

part 'huddle_dto.g.dart';

@JsonSerializable()
class HuddleDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final String status;
  @JsonKey(name: 'participant_ids')
  final List<String> participantIds;
  @JsonKey(name: 'max_participants')
  final int maxParticipants;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const HuddleDto({
    required this.id,
    required this.channelId,
    required this.createdBy,
    this.status = 'active',
    this.participantIds = const [],
    this.maxParticipants = 50,
    this.createdAt,
  });

  factory HuddleDto.fromJson(Map<String, dynamic> json) => _$HuddleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$HuddleDtoToJson(this);
}

@JsonSerializable()
class CreateHuddleDto {
  @JsonKey(name: 'channel_id')
  final String channelId;

  const CreateHuddleDto({required this.channelId});

  factory CreateHuddleDto.fromJson(Map<String, dynamic> json) => _$CreateHuddleDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateHuddleDtoToJson(this);
}

/// Paginated huddle list response
class HuddleListDto {
  final List<HuddleDto> huddles;
  final int total;
  final int page;
  final int perPage;

  const HuddleListDto({
    required this.huddles,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory HuddleListDto.fromJson(Map<String, dynamic> json) {
    final items = json['huddles'] ?? json['data'] ?? json['items'] ?? [];
    return HuddleListDto(
      huddles: (items as List<dynamic>)
          .map((e) => HuddleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
