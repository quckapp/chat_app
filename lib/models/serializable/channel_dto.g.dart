// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelDto _$ChannelDtoFromJson(Map<String, dynamic> json) => ChannelDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'public',
      workspaceId: json['workspace_id'] as String,
      createdBy: json['created_by'] as String,
      topic: json['topic'] as String?,
      avatar: json['avatar'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      isArchived: json['is_archived'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ChannelDtoToJson(ChannelDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'workspace_id': instance.workspaceId,
      'created_by': instance.createdBy,
      'topic': instance.topic,
      'avatar': instance.avatar,
      'member_count': instance.memberCount,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CreateChannelDto _$CreateChannelDtoFromJson(Map<String, dynamic> json) =>
    CreateChannelDto(
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'public',
      workspaceId: json['workspace_id'] as String,
      topic: json['topic'] as String?,
    );

Map<String, dynamic> _$CreateChannelDtoToJson(CreateChannelDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
      'workspace_id': instance.workspaceId,
      'topic': instance.topic,
    };

UpdateChannelDto _$UpdateChannelDtoFromJson(Map<String, dynamic> json) =>
    UpdateChannelDto(
      name: json['name'] as String?,
      description: json['description'] as String?,
      topic: json['topic'] as String?,
      avatar: json['avatar'] as String?,
      isArchived: json['is_archived'] as bool?,
    );

Map<String, dynamic> _$UpdateChannelDtoToJson(UpdateChannelDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'topic': instance.topic,
      'avatar': instance.avatar,
      'is_archived': instance.isArchived,
    };

ChannelMemberDto _$ChannelMemberDtoFromJson(Map<String, dynamic> json) =>
    ChannelMemberDto(
      userId: json['user_id'] as String,
      channelId: json['channel_id'] as String,
      role: json['role'] as String? ?? 'member',
      displayName: json['display_name'] as String?,
      avatar: json['avatar'] as String?,
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
    );

Map<String, dynamic> _$ChannelMemberDtoToJson(ChannelMemberDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'channel_id': instance.channelId,
      'role': instance.role,
      'display_name': instance.displayName,
      'avatar': instance.avatar,
      'joined_at': instance.joinedAt?.toIso8601String(),
    };
