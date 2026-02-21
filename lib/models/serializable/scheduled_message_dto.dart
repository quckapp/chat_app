import 'package:json_annotation/json_annotation.dart';

part 'scheduled_message_dto.g.dart';

@JsonSerializable()
class ScheduledMessageDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String content;
  @JsonKey(name: 'scheduled_at')
  final DateTime? scheduledAt;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ScheduledMessageDto({
    required this.id,
    required this.channelId,
    required this.content,
    this.scheduledAt,
    required this.createdBy,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
  });

  factory ScheduledMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduledMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduledMessageDtoToJson(this);
}

@JsonSerializable()
class CreateScheduledMessageDto {
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String content;
  @JsonKey(name: 'scheduled_at')
  final DateTime scheduledAt;

  const CreateScheduledMessageDto({
    required this.channelId,
    required this.content,
    required this.scheduledAt,
  });

  factory CreateScheduledMessageDto.fromJson(Map<String, dynamic> json) =>
      _$CreateScheduledMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateScheduledMessageDtoToJson(this);
}

/// Paginated scheduled message list response
class ScheduledMessageListDto {
  final List<ScheduledMessageDto> items;
  final int total;
  final int page;
  final int perPage;

  const ScheduledMessageListDto({
    required this.items,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory ScheduledMessageListDto.fromJson(Map<String, dynamic> json) {
    final items = json['items'] ?? json['data'] ?? json['scheduled_messages'] ?? [];
    return ScheduledMessageListDto(
      items: (items as List<dynamic>)
          .map((e) => ScheduledMessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
