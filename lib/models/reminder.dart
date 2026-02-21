import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'reminder.g.dart';

/// Status of a reminder
@HiveType(typeId: 25)
enum ReminderStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  snoozed,
  @HiveField(2)
  completed,
  @HiveField(3)
  dismissed;

  static ReminderStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'snoozed':
        return ReminderStatus.snoozed;
      case 'completed':
        return ReminderStatus.completed;
      case 'dismissed':
        return ReminderStatus.dismissed;
      default:
        return ReminderStatus.pending;
    }
  }
}

/// Represents a reminder for a message
@HiveType(typeId: 24)
class Reminder extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String messageId;
  @HiveField(3)
  final String channelId;
  @HiveField(4)
  final String? note;
  @HiveField(5)
  final DateTime remindAt;
  @HiveField(6)
  final ReminderStatus status;
  @HiveField(7)
  final DateTime createdAt;

  const Reminder({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.channelId,
    this.note,
    required this.remindAt,
    this.status = ReminderStatus.pending,
    required this.createdAt,
  });

  bool get isPending => status == ReminderStatus.pending;
  bool get isSnoozed => status == ReminderStatus.snoozed;
  bool get isCompleted => status == ReminderStatus.completed;
  bool get isDismissed => status == ReminderStatus.dismissed;
  bool get isOverdue => isPending && remindAt.isBefore(DateTime.now());

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      messageId: json['message_id'] as String? ?? json['messageId'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      note: json['note'] as String?,
      remindAt: json['remind_at'] != null
          ? DateTime.parse(json['remind_at'] as String)
          : json['remindAt'] != null
              ? DateTime.parse(json['remindAt'] as String)
              : DateTime.now(),
      status: ReminderStatus.fromString(json['status'] as String?),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message_id': messageId,
      'channel_id': channelId,
      'note': note,
      'remind_at': remindAt.toIso8601String(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Reminder copyWith({
    String? id,
    String? userId,
    String? messageId,
    String? channelId,
    String? note,
    DateTime? remindAt,
    ReminderStatus? status,
    DateTime? createdAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      channelId: channelId ?? this.channelId,
      note: note ?? this.note,
      remindAt: remindAt ?? this.remindAt,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, messageId, channelId, note, remindAt, status, createdAt,
      ];
}
