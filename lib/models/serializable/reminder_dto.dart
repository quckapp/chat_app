import 'package:json_annotation/json_annotation.dart';

part 'reminder_dto.g.dart';

@JsonSerializable()
class ReminderDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String? note;
  @JsonKey(name: 'remind_at')
  final DateTime? remindAt;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const ReminderDto({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.channelId,
    this.note,
    this.remindAt,
    this.status = 'pending',
    this.createdAt,
  });

  factory ReminderDto.fromJson(Map<String, dynamic> json) => _$ReminderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderDtoToJson(this);
}

@JsonSerializable()
class CreateReminderDto {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String? note;
  @JsonKey(name: 'remind_at')
  final DateTime remindAt;

  const CreateReminderDto({
    required this.messageId,
    required this.channelId,
    this.note,
    required this.remindAt,
  });

  factory CreateReminderDto.fromJson(Map<String, dynamic> json) => _$CreateReminderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateReminderDtoToJson(this);
}

@JsonSerializable()
class UpdateReminderDto {
  final String? note;
  @JsonKey(name: 'remind_at')
  final DateTime? remindAt;
  final String? status;

  const UpdateReminderDto({
    this.note,
    this.remindAt,
    this.status,
  });

  factory UpdateReminderDto.fromJson(Map<String, dynamic> json) => _$UpdateReminderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateReminderDtoToJson(this);
}

/// Paginated reminder list response
class ReminderListDto {
  final List<ReminderDto> reminders;
  final int total;
  final int page;
  final int perPage;

  const ReminderListDto({
    required this.reminders,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory ReminderListDto.fromJson(Map<String, dynamic> json) {
    final items = json['reminders'] ?? json['data'] ?? json['items'] ?? [];
    return ReminderListDto(
      reminders: (items as List<dynamic>)
          .map((e) => ReminderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
