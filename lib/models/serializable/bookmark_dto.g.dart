// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkDto _$BookmarkDtoFromJson(Map<String, dynamic> json) => BookmarkDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      messageId: json['message_id'] as String,
      channelId: json['channel_id'] as String,
      note: json['note'] as String?,
      folderIds: (json['folder_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BookmarkDtoToJson(BookmarkDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'message_id': instance.messageId,
      'channel_id': instance.channelId,
      'note': instance.note,
      'folder_ids': instance.folderIds,
      'created_at': instance.createdAt?.toIso8601String(),
    };

CreateBookmarkDto _$CreateBookmarkDtoFromJson(Map<String, dynamic> json) =>
    CreateBookmarkDto(
      messageId: json['message_id'] as String,
      channelId: json['channel_id'] as String,
      note: json['note'] as String?,
      folderIds: (json['folder_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateBookmarkDtoToJson(CreateBookmarkDto instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'channel_id': instance.channelId,
      'note': instance.note,
      'folder_ids': instance.folderIds,
    };

BookmarkFolderDto _$BookmarkFolderDtoFromJson(Map<String, dynamic> json) =>
    BookmarkFolderDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      bookmarkCount: (json['bookmark_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$BookmarkFolderDtoToJson(BookmarkFolderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'bookmark_count': instance.bookmarkCount,
      'created_at': instance.createdAt?.toIso8601String(),
    };

CreateBookmarkFolderDto _$CreateBookmarkFolderDtoFromJson(
        Map<String, dynamic> json) =>
    CreateBookmarkFolderDto(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateBookmarkFolderDtoToJson(
        CreateBookmarkFolderDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
