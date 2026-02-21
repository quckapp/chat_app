import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'channel_id')
  final String? channelId;
  @JsonKey(name: 'message_id')
  final String? messageId;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const NotificationDto({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    this.channelId,
    this.messageId,
    this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) => _$NotificationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}

/// Paginated notification list response
class NotificationListDto {
  final List<NotificationDto> notifications;
  final int total;
  final int page;
  final int perPage;

  const NotificationListDto({
    required this.notifications,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory NotificationListDto.fromJson(Map<String, dynamic> json) {
    final items = json['notifications'] ?? json['data'] ?? json['items'] ?? [];
    return NotificationListDto(
      notifications: (items as List<dynamic>)
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}

@JsonSerializable()
class MarkReadDto {
  @JsonKey(name: 'notification_ids')
  final List<String> notificationIds;

  const MarkReadDto({required this.notificationIds});

  factory MarkReadDto.fromJson(Map<String, dynamic> json) => _$MarkReadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MarkReadDtoToJson(this);
}
