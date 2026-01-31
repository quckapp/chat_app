// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    ConversationDto(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'direct',
      name: json['name'] as String?,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ParticipantDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageDto.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ConversationDtoToJson(ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'avatar': instance.avatar,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'isMuted': instance.isMuted,
      'isPinned': instance.isPinned,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

ParticipantDto _$ParticipantDtoFromJson(Map<String, dynamic> json) =>
    ParticipantDto(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'member',
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$ParticipantDtoToJson(ParticipantDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'role': instance.role,
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };

CreateConversationDto _$CreateConversationDtoFromJson(
        Map<String, dynamic> json) =>
    CreateConversationDto(
      type: json['type'] as String? ?? 'direct',
      name: json['name'] as String?,
      description: json['description'] as String?,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreateConversationDtoToJson(
        CreateConversationDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'participantIds': instance.participantIds,
    };

ConversationListDto _$ConversationListDtoFromJson(Map<String, dynamic> json) =>
    ConversationListDto(
      conversations: (json['conversations'] as List<dynamic>)
          .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$ConversationListDtoToJson(
        ConversationListDto instance) =>
    <String, dynamic>{
      'conversations': instance.conversations,
      'total': instance.total,
      'nextCursor': instance.nextCursor,
      'hasMore': instance.hasMore,
    };

UpdateConversationDto _$UpdateConversationDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateConversationDto(
      name: json['name'] as String?,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      isMuted: json['isMuted'] as bool?,
      isPinned: json['isPinned'] as bool?,
    );

Map<String, dynamic> _$UpdateConversationDtoToJson(
        UpdateConversationDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'avatar': instance.avatar,
      'isMuted': instance.isMuted,
      'isPinned': instance.isPinned,
    };
