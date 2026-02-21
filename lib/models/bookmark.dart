import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'bookmark.g.dart';

/// Represents a saved bookmark
@HiveType(typeId: 22)
class Bookmark extends Equatable {
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
  final List<String> folderIds;
  @HiveField(6)
  final DateTime createdAt;

  const Bookmark({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.channelId,
    this.note,
    this.folderIds = const [],
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      messageId: json['message_id'] as String? ?? json['messageId'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      note: json['note'] as String?,
      folderIds: (json['folder_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['folderIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
      'folder_ids': folderIds,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Bookmark copyWith({
    String? id,
    String? userId,
    String? messageId,
    String? channelId,
    String? note,
    List<String>? folderIds,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      messageId: messageId ?? this.messageId,
      channelId: channelId ?? this.channelId,
      note: note ?? this.note,
      folderIds: folderIds ?? this.folderIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, messageId, channelId, note, folderIds, createdAt];
}

/// Represents a bookmark folder for organizing bookmarks
@HiveType(typeId: 23)
class BookmarkFolder extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final int bookmarkCount;
  @HiveField(5)
  final DateTime createdAt;

  const BookmarkFolder({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.bookmarkCount = 0,
    required this.createdAt,
  });

  factory BookmarkFolder.fromJson(Map<String, dynamic> json) {
    return BookmarkFolder(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      bookmarkCount: (json['bookmark_count'] as num?)?.toInt() ??
          (json['bookmarkCount'] as num?)?.toInt() ?? 0,
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
      'name': name,
      'description': description,
      'bookmark_count': bookmarkCount,
      'created_at': createdAt.toIso8601String(),
    };
  }

  BookmarkFolder copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? bookmarkCount,
    DateTime? createdAt,
  }) {
    return BookmarkFolder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, description, bookmarkCount, createdAt];
}
