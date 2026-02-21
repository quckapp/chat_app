import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'notification.g.dart';

/// Type of notification
@HiveType(typeId: 29)
enum NotificationType {
  @HiveField(0)
  message,
  @HiveField(1)
  mention,
  @HiveField(2)
  reaction,
  @HiveField(3)
  threadReply,
  @HiveField(4)
  channelInvite,
  @HiveField(5)
  system;

  static NotificationType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'mention':
        return NotificationType.mention;
      case 'reaction':
        return NotificationType.reaction;
      case 'thread_reply':
      case 'threadreply':
        return NotificationType.threadReply;
      case 'channel_invite':
      case 'channelinvite':
        return NotificationType.channelInvite;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.message;
    }
  }
}

/// Represents an in-app notification
@HiveType(typeId: 28)
class AppNotification extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final NotificationType type;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String body;
  @HiveField(5)
  final Map<String, dynamic> data;
  @HiveField(6)
  final bool isRead;
  @HiveField(7)
  final String? channelId;
  @HiveField(8)
  final String? messageId;
  @HiveField(9)
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data = const {},
    this.isRead = false,
    this.channelId,
    this.messageId,
    required this.createdAt,
  });

  bool get isUnread => !isRead;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      type: NotificationType.fromString(json['type'] as String?),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: (json['data'] as Map<String, dynamic>?) ?? {},
      isRead: json['is_read'] as bool? ?? json['isRead'] as bool? ?? false,
      channelId: json['channel_id'] as String? ?? json['channelId'] as String?,
      messageId: json['message_id'] as String? ?? json['messageId'] as String?,
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
      'type': type.name,
      'title': title,
      'body': body,
      'data': data,
      'is_read': isRead,
      'channel_id': channelId,
      'message_id': messageId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    String? channelId,
    String? messageId,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      channelId: channelId ?? this.channelId,
      messageId: messageId ?? this.messageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, type, title, body, data, isRead,
        channelId, messageId, createdAt,
      ];
}
