import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'scheduled_message.g.dart';

/// Represents a scheduled message in a channel
@HiveType(typeId: 36)
class ScheduledMessage extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime scheduledAt;
  @HiveField(4)
  final String createdBy;
  @HiveField(5)
  final String status;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime? updatedAt;

  const ScheduledMessage({
    required this.id,
    required this.channelId,
    required this.content,
    required this.scheduledAt,
    required this.createdBy,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  factory ScheduledMessage.fromJson(Map<String, dynamic> json) {
    return ScheduledMessage(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.parse(json['scheduled_at'] as String)
          : json['scheduledAt'] != null
              ? DateTime.parse(json['scheduledAt'] as String)
              : DateTime.now(),
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'content': content,
      'scheduled_at': scheduledAt.toIso8601String(),
      'created_by': createdBy,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ScheduledMessage copyWith({
    String? id,
    String? channelId,
    String? content,
    DateTime? scheduledAt,
    String? createdBy,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduledMessage(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      content: content ?? this.content,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        channelId,
        content,
        scheduledAt,
        createdBy,
        status,
        createdAt,
        updatedAt,
      ];
}
