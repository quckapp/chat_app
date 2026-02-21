import 'package:json_annotation/json_annotation.dart';

part 'audit_dto.g.dart';

@JsonSerializable()
class AuditLogDto {
  final String id;
  final String action;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'target_type')
  final String targetType;
  @JsonKey(name: 'target_id')
  final String targetId;
  final String? details;
  @JsonKey(name: 'ip_address')
  final String? ipAddress;
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const AuditLogDto({
    required this.id,
    required this.action,
    required this.userId,
    required this.targetType,
    required this.targetId,
    this.details,
    this.ipAddress,
    this.userAgent,
    this.createdAt,
  });

  factory AuditLogDto.fromJson(Map<String, dynamic> json) => _$AuditLogDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuditLogDtoToJson(this);
}

@JsonSerializable()
class AuditStatsDto {
  @JsonKey(name: 'total_events')
  final int totalEvents;
  @JsonKey(name: 'events_by_type')
  final Map<String, dynamic> eventsByType;

  const AuditStatsDto({
    this.totalEvents = 0,
    this.eventsByType = const {},
  });

  factory AuditStatsDto.fromJson(Map<String, dynamic> json) => _$AuditStatsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuditStatsDtoToJson(this);
}

/// Paginated audit log list response
class AuditLogListDto {
  final List<AuditLogDto> items;
  final int total;
  final int page;

  const AuditLogListDto({
    required this.items,
    required this.total,
    this.page = 1,
  });

  factory AuditLogListDto.fromJson(Map<String, dynamic> json) {
    final items = json['items'] ?? json['data'] ?? json['logs'] ?? [];
    return AuditLogListDto(
      items: (items as List<dynamic>)
          .map((e) => AuditLogDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
    );
  }
}
