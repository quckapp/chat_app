import 'package:json_annotation/json_annotation.dart';

part 'event_dto.g.dart';

@JsonSerializable()
class BroadcastEventDto {
  final String type;
  final Map<String, dynamic> payload;
  @JsonKey(name: 'target_user_ids')
  final List<String>? targetUserIds;

  const BroadcastEventDto({
    required this.type,
    required this.payload,
    this.targetUserIds,
  });

  factory BroadcastEventDto.fromJson(Map<String, dynamic> json) =>
      _$BroadcastEventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BroadcastEventDtoToJson(this);
}

@JsonSerializable()
class EventDto {
  final String id;
  final String type;
  final Map<String, dynamic> payload;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const EventDto({
    required this.id,
    required this.type,
    required this.payload,
    this.createdAt,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) => _$EventDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EventDtoToJson(this);
}

/// Paginated event list response
class EventListDto {
  final List<EventDto> items;
  final int total;
  final int page;
  final int perPage;

  const EventListDto({
    required this.items,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory EventListDto.fromJson(Map<String, dynamic> json) {
    final items = json['items'] ?? json['data'] ?? json['events'] ?? [];
    return EventListDto(
      items: (items as List<dynamic>)
          .map((e) => EventDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
