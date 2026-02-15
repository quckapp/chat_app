import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'attachment.dart';
import 'reaction.dart';

part 'message.g.dart';

/// Represents a chat message
@HiveType(typeId: 1)
class Message extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String conversationId;
  @HiveField(2)
  final String senderId;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final List<Attachment> attachments;
  @HiveField(6)
  final String? replyTo;
  @HiveField(7)
  final bool isEdited;
  @HiveField(8)
  final bool isDeleted;
  @HiveField(9)
  final List<Reaction> reactions;
  @HiveField(10)
  final List<String> readBy;
  @HiveField(11)
  final DateTime createdAt;
  @HiveField(12)
  final DateTime? updatedAt;

  // For optimistic UI - pending messages
  @HiveField(13)
  final bool isPending;
  @HiveField(14)
  final bool hasFailed;
  @HiveField(15)
  final String? clientId;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.type = 'text',
    required this.content,
    this.attachments = const [],
    this.replyTo,
    this.isEdited = false,
    this.isDeleted = false,
    this.reactions = const [],
    this.readBy = const [],
    required this.createdAt,
    this.updatedAt,
    this.isPending = false,
    this.hasFailed = false,
    this.clientId,
  });

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
  bool get isFile => type == 'file';
  bool get isSystem => type == 'system';

  bool isReadBy(String userId) => readBy.contains(userId);
  bool isSentBy(String userId) => senderId == userId;

  Reaction? getReaction(String emoji) {
    try {
      return reactions.firstWhere((r) => r.emoji == emoji);
    } catch (_) {
      return null;
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? json['sender_id'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String? ?? '',
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((a) => Attachment.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      replyTo: json['replyTo'] as String?,
      isEdited: json['isEdited'] as bool? ?? json['is_edited'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? json['is_deleted'] as bool? ?? false,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((r) => Reaction.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      readBy: (json['readBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          (json['read_by'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : null,
      clientId: json['clientId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'type': type,
      'content': content,
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'replyTo': replyTo,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'reactions': reactions.map((r) => r.toJson()).toList(),
      'readBy': readBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'clientId': clientId,
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? type,
    String? content,
    List<Attachment>? attachments,
    String? replyTo,
    bool? isEdited,
    bool? isDeleted,
    List<Reaction>? reactions,
    List<String>? readBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPending,
    bool? hasFailed,
    String? clientId,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      replyTo: replyTo ?? this.replyTo,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      reactions: reactions ?? this.reactions,
      readBy: readBy ?? this.readBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPending: isPending ?? this.isPending,
      hasFailed: hasFailed ?? this.hasFailed,
      clientId: clientId ?? this.clientId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        type,
        content,
        attachments,
        replyTo,
        isEdited,
        isDeleted,
        reactions,
        readBy,
        createdAt,
        updatedAt,
        isPending,
        hasFailed,
        clientId,
      ];
}
