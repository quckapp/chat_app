// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    ConversationDto(
      id: _readId(json, '_id') as String,
      type: json['type'] as String? ?? 'direct',
      name: json['name'] as String?,
      description: json['description'] as String?,
      avatar: json['avatarUrl'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ParticipantDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageDto.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ConversationDtoToJson(ConversationDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'description': instance.description,
      'avatarUrl': instance.avatar,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'isMuted': instance.isMuted,
      'isPinned': instance.isPinned,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

ParticipantDto _$ParticipantDtoFromJson(Map<String, dynamic> json) =>
    ParticipantDto(
      userId: json['userId'] as String?,
      name: json['displayName'] as String?,
      avatar: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'member',
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ParticipantDtoToJson(ParticipantDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.name,
      'avatarUrl': instance.avatar,
      'role': instance.role,
      'joinedAt': instance.joinedAt?.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'isMuted': instance.isMuted,
      'isPinned': instance.isPinned,
      'phoneNumber': instance.phoneNumber,
      'phone': instance.phone,
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
