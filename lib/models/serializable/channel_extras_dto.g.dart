// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_extras_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelLinkDto _$ChannelLinkDtoFromJson(Map<String, dynamic> json) =>
    ChannelLinkDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      url: json['url'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChannelLinkDtoToJson(ChannelLinkDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };

CreateChannelLinkDto _$CreateChannelLinkDtoFromJson(
        Map<String, dynamic> json) =>
    CreateChannelLinkDto(
      url: json['url'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateChannelLinkDtoToJson(
        CreateChannelLinkDto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'description': instance.description,
    };

ChannelTabDto _$ChannelTabDtoFromJson(Map<String, dynamic> json) =>
    ChannelTabDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ChannelTabDtoToJson(ChannelTabDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };

CreateChannelTabDto _$CreateChannelTabDtoFromJson(Map<String, dynamic> json) =>
    CreateChannelTabDto(
      name: json['name'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$CreateChannelTabDtoToJson(
        CreateChannelTabDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'url': instance.url,
    };

ChannelTemplateDto _$ChannelTemplateDtoFromJson(Map<String, dynamic> json) =>
    ChannelTemplateDto(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      name: json['name'] as String,
      content: json['content'] as String,
      createdBy: json['created_by'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ChannelTemplateDtoToJson(ChannelTemplateDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'name': instance.name,
      'content': instance.content,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

CreateChannelTemplateDto _$CreateChannelTemplateDtoFromJson(
        Map<String, dynamic> json) =>
    CreateChannelTemplateDto(
      name: json['name'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CreateChannelTemplateDtoToJson(
        CreateChannelTemplateDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'content': instance.content,
    };
