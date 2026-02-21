import 'package:json_annotation/json_annotation.dart';

part 'thread_dto.g.dart';

@JsonSerializable()
class ThreadDto {
  final String id;
  @JsonKey(name: 'channel_id')
  final String channelId;
  @JsonKey(name: 'parent_message_id')
  final String parentMessageId;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'reply_count')
  final int replyCount;
  @JsonKey(name: 'participant_count')
  final int participantCount;
  @JsonKey(name: 'last_reply_at')
  final DateTime? lastReplyAt;
  @JsonKey(name: 'is_following')
  final bool isFollowing;
  @JsonKey(name: 'is_resolved')
  final bool isResolved;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ThreadDto({
    required this.id, required this.channelId, required this.parentMessageId,
    required this.createdBy, this.replyCount = 0, this.participantCount = 0,
    this.lastReplyAt, this.isFollowing = false, this.isResolved = false,
    this.createdAt, this.updatedAt,
  });

  factory ThreadDto.fromJson(Map<String, dynamic> json) => _$ThreadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadDtoToJson(this);
}

@JsonSerializable()
class ThreadReplyDto {
  final String id;
  @JsonKey(name: 'thread_id')
  final String threadId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String content;
  @JsonKey(name: 'display_name')
  final String? displayName;
  final String? avatar;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ThreadReplyDto({
    required this.id, required this.threadId, required this.userId,
    required this.content, this.displayName, this.avatar,
    this.createdAt, this.updatedAt,
  });

  factory ThreadReplyDto.fromJson(Map<String, dynamic> json) => _$ThreadReplyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadReplyDtoToJson(this);
}

@JsonSerializable()
class CreateThreadDto {
  @JsonKey(name: 'channel_id')
  final String channelId;
  @JsonKey(name: 'parent_message_id')
  final String parentMessageId;
  final String content;

  const CreateThreadDto({
    required this.channelId, required this.parentMessageId, required this.content,
  });

  factory CreateThreadDto.fromJson(Map<String, dynamic> json) => _$CreateThreadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateThreadDtoToJson(this);
}

@JsonSerializable()
class CreateThreadReplyDto {
  final String content;

  const CreateThreadReplyDto({required this.content});

  factory CreateThreadReplyDto.fromJson(Map<String, dynamic> json) => _$CreateThreadReplyDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateThreadReplyDtoToJson(this);
}

/// Paginated thread list response
class ThreadListDto {
  final List<ThreadDto> threads;
  final int total;
  final int page;
  final int perPage;

  const ThreadListDto({
    required this.threads, required this.total, this.page = 1, this.perPage = 20,
  });

  factory ThreadListDto.fromJson(Map<String, dynamic> json) {
    final items = json['threads'] ?? json['data'] ?? json['items'] ?? [];
    return ThreadListDto(
      threads: (items as List<dynamic>)
          .map((e) => ThreadDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
    );
  }
}
