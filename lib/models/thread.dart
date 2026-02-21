import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'thread.g.dart';

/// Represents a thread (conversation around a specific message)
@HiveType(typeId: 17)
class Thread extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String parentMessageId;
  @HiveField(3)
  final String createdBy;
  @HiveField(4)
  final int replyCount;
  @HiveField(5)
  final int participantCount;
  @HiveField(6)
  final DateTime? lastReplyAt;
  @HiveField(7)
  final bool isFollowing;
  @HiveField(8)
  final bool isResolved;
  @HiveField(9)
  final DateTime createdAt;
  @HiveField(10)
  final DateTime? updatedAt;

  const Thread({
    required this.id,
    required this.channelId,
    required this.parentMessageId,
    required this.createdBy,
    this.replyCount = 0,
    this.participantCount = 0,
    this.lastReplyAt,
    this.isFollowing = false,
    this.isResolved = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      parentMessageId: json['parent_message_id'] as String? ?? json['parentMessageId'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      replyCount: (json['reply_count'] as num?)?.toInt() ??
          (json['replyCount'] as num?)?.toInt() ?? 0,
      participantCount: (json['participant_count'] as num?)?.toInt() ??
          (json['participantCount'] as num?)?.toInt() ?? 0,
      lastReplyAt: json['last_reply_at'] != null
          ? DateTime.parse(json['last_reply_at'] as String)
          : json['lastReplyAt'] != null
              ? DateTime.parse(json['lastReplyAt'] as String)
              : null,
      isFollowing: json['is_following'] as bool? ?? json['isFollowing'] as bool? ?? false,
      isResolved: json['is_resolved'] as bool? ?? json['isResolved'] as bool? ?? false,
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'channel_id': channelId,
    'parent_message_id': parentMessageId,
    'created_by': createdBy,
    'reply_count': replyCount,
    'participant_count': participantCount,
    'last_reply_at': lastReplyAt?.toIso8601String(),
    'is_following': isFollowing,
    'is_resolved': isResolved,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  Thread copyWith({
    String? id, String? channelId, String? parentMessageId, String? createdBy,
    int? replyCount, int? participantCount, DateTime? lastReplyAt,
    bool? isFollowing, bool? isResolved, DateTime? createdAt, DateTime? updatedAt,
  }) {
    return Thread(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      createdBy: createdBy ?? this.createdBy,
      replyCount: replyCount ?? this.replyCount,
      participantCount: participantCount ?? this.participantCount,
      lastReplyAt: lastReplyAt ?? this.lastReplyAt,
      isFollowing: isFollowing ?? this.isFollowing,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id, channelId, parentMessageId, createdBy, replyCount,
    participantCount, lastReplyAt, isFollowing, isResolved, createdAt, updatedAt,
  ];
}

/// Represents a reply within a thread
@HiveType(typeId: 18)
class ThreadReply extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String threadId;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final String? displayName;
  @HiveField(5)
  final String? avatar;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime? updatedAt;

  const ThreadReply({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.content,
    this.displayName,
    this.avatar,
    required this.createdAt,
    this.updatedAt,
  });

  factory ThreadReply.fromJson(Map<String, dynamic> json) {
    return ThreadReply(
      id: json['id'] as String? ?? '',
      threadId: json['thread_id'] as String? ?? json['threadId'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      displayName: json['display_name'] as String? ?? json['displayName'] as String?,
      avatar: json['avatar'] as String?,
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

  Map<String, dynamic> toJson() => {
    'id': id, 'thread_id': threadId, 'user_id': userId,
    'content': content, 'display_name': displayName, 'avatar': avatar,
    'created_at': createdAt.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, threadId, userId, content, displayName, avatar, createdAt, updatedAt];
}
