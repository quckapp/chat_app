import 'package:json_annotation/json_annotation.dart';

part 'bookmark_dto.g.dart';

@JsonSerializable()
class BookmarkDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String? note;
  @JsonKey(name: 'folder_ids')
  final List<String> folderIds;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const BookmarkDto({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.channelId,
    this.note,
    this.folderIds = const [],
    this.createdAt,
  });

  factory BookmarkDto.fromJson(Map<String, dynamic> json) => _$BookmarkDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkDtoToJson(this);
}

@JsonSerializable()
class CreateBookmarkDto {
  @JsonKey(name: 'message_id')
  final String messageId;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String? note;
  @JsonKey(name: 'folder_ids')
  final List<String>? folderIds;

  const CreateBookmarkDto({
    required this.messageId,
    required this.channelId,
    this.note,
    this.folderIds,
  });

  factory CreateBookmarkDto.fromJson(Map<String, dynamic> json) => _$CreateBookmarkDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateBookmarkDtoToJson(this);
}

@JsonSerializable()
class BookmarkFolderDto {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  final String? description;
  @JsonKey(name: 'bookmark_count')
  final int bookmarkCount;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const BookmarkFolderDto({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.bookmarkCount = 0,
    this.createdAt,
  });

  factory BookmarkFolderDto.fromJson(Map<String, dynamic> json) => _$BookmarkFolderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BookmarkFolderDtoToJson(this);
}

@JsonSerializable()
class CreateBookmarkFolderDto {
  final String name;
  final String? description;

  const CreateBookmarkFolderDto({
    required this.name,
    this.description,
  });

  factory CreateBookmarkFolderDto.fromJson(Map<String, dynamic> json) => _$CreateBookmarkFolderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateBookmarkFolderDtoToJson(this);
}

/// Paginated bookmark list response
class BookmarkListDto {
  final List<BookmarkDto> bookmarks;
  final int total;
  final int page;
  final int perPage;

  const BookmarkListDto({
    required this.bookmarks,
    required this.total,
    this.page = 1,
    this.perPage = 20,
  });

  factory BookmarkListDto.fromJson(Map<String, dynamic> json) {
    final items = json['bookmarks'] ?? json['data'] ?? json['items'] ?? [];
    return BookmarkListDto(
      bookmarks: (items as List<dynamic>)
          .map((e) => BookmarkDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
