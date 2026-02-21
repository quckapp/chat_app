import 'package:json_annotation/json_annotation.dart';

part 'channel_extras_dto.g.dart';

@JsonSerializable()
class ChannelLinkDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String url;
  final String title;
  final String? description;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const ChannelLinkDto({
    required this.id,
    required this.channelId,
    required this.url,
    required this.title,
    this.description,
    required this.createdBy,
    this.createdAt,
  });

  factory ChannelLinkDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelLinkDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelLinkDtoToJson(this);
}

@JsonSerializable()
class CreateChannelLinkDto {
  final String url;
  final String title;
  final String? description;

  const CreateChannelLinkDto({
    required this.url,
    required this.title,
    this.description,
  });

  factory CreateChannelLinkDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChannelLinkDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChannelLinkDtoToJson(this);
}

@JsonSerializable()
class ChannelTabDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String name;
  final String type;
  final String url;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const ChannelTabDto({
    required this.id,
    required this.channelId,
    required this.name,
    required this.type,
    required this.url,
    required this.createdBy,
    this.createdAt,
  });

  factory ChannelTabDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelTabDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelTabDtoToJson(this);
}

@JsonSerializable()
class CreateChannelTabDto {
  final String name;
  final String type;
  final String url;

  const CreateChannelTabDto({
    required this.name,
    required this.type,
    required this.url,
  });

  factory CreateChannelTabDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChannelTabDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChannelTabDtoToJson(this);
}

@JsonSerializable()
class ChannelTemplateDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String name;
  final String content;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ChannelTemplateDto({
    required this.id,
    required this.channelId,
    required this.name,
    required this.content,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ChannelTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$ChannelTemplateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelTemplateDtoToJson(this);
}

@JsonSerializable()
class CreateChannelTemplateDto {
  final String name;
  final String content;

  const CreateChannelTemplateDto({
    required this.name,
    required this.content,
  });

  factory CreateChannelTemplateDto.fromJson(Map<String, dynamic> json) =>
      _$CreateChannelTemplateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChannelTemplateDtoToJson(this);
}
