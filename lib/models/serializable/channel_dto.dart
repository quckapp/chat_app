import 'package:json_annotation/json_annotation.dart';

part 'channel_dto.g.dart';

@JsonSerializable()
class ChannelDto {
  final String id;
  final String name;
  final String? description;
  final String type;
  @JsonKey(name: 'workspace_id')
  final String workspaceId;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final String? topic;
  final String? avatar;
  @JsonKey(name: 'member_count')
  final int memberCount;
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ChannelDto({
    required this.id, required this.name, this.description,
    this.type = 'public', required this.workspaceId, required this.createdBy,
    this.topic, this.avatar, this.memberCount = 0, this.isArchived = false,
    this.createdAt, this.updatedAt,
  });

  factory ChannelDto.fromJson(Map<String, dynamic> json) => _$ChannelDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelDtoToJson(this);
}

@JsonSerializable()
class CreateChannelDto {
  final String name;
  final String? description;
  final String type;
  @JsonKey(name: 'workspace_id')
  final String workspaceId;
  final String? topic;

  const CreateChannelDto({
    required this.name, this.description, this.type = 'public',
    required this.workspaceId, this.topic,
  });

  factory CreateChannelDto.fromJson(Map<String, dynamic> json) => _$CreateChannelDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChannelDtoToJson(this);
}

@JsonSerializable()
class UpdateChannelDto {
  final String? name;
  final String? description;
  final String? topic;
  final String? avatar;
  @JsonKey(name: 'is_archived')
  final bool? isArchived;

  const UpdateChannelDto({this.name, this.description, this.topic, this.avatar, this.isArchived});

  factory UpdateChannelDto.fromJson(Map<String, dynamic> json) => _$UpdateChannelDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateChannelDtoToJson(this);
}

@JsonSerializable()
class ChannelMemberDto {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'channel_id')
  final String channelId;
  final String role;
  @JsonKey(name: 'display_name')
  final String? displayName;
  final String? avatar;
  @JsonKey(name: 'joined_at')
  final DateTime? joinedAt;

  const ChannelMemberDto({
    required this.userId, required this.channelId, this.role = 'member',
    this.displayName, this.avatar, this.joinedAt,
  });

  factory ChannelMemberDto.fromJson(Map<String, dynamic> json) => _$ChannelMemberDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelMemberDtoToJson(this);
}

/// Paginated channel list response
class ChannelListDto {
  final List<ChannelDto> channels;
  final int total;
  final int page;
  final int perPage;

  const ChannelListDto({
    required this.channels, required this.total, this.page = 1, this.perPage = 20,
  });

  factory ChannelListDto.fromJson(Map<String, dynamic> json) {
    final items = json['channels'] ?? json['data'] ?? json['items'] ?? [];
    return ChannelListDto(
      channels: (items as List<dynamic>)
          .map((e) => ChannelDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
