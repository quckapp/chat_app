import 'package:json_annotation/json_annotation.dart';
import 'message_dto.dart';

part 'conversation_dto.g.dart';

// Helper to read id from either '_id' or 'id' field
Object? _readId(Map<dynamic, dynamic> json, String key) {
  return json['_id'] ?? json['id'];
}

@JsonSerializable()
class ConversationDto {
  @JsonKey(name: '_id', readValue: _readId)
  final String id;
  final String type;
  final String? name;
  final String? description;
  @JsonKey(name: 'avatarUrl')
  final String? avatar;
  final List<ParticipantDto>? participants;
  final MessageDto? lastMessage;
  @JsonKey(defaultValue: 0)
  final int unreadCount;
  @JsonKey(defaultValue: false)
  final bool isMuted;
  @JsonKey(defaultValue: false)
  final bool isPinned;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ConversationDto({
    required this.id,
    this.type = 'direct',
    this.name,
    this.description,
    this.avatar,
    this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationDtoToJson(this);
}

@JsonSerializable()
class ParticipantDto {
  final String? userId;
  @JsonKey(name: 'displayName')
  final String? name;
  @JsonKey(name: 'avatarUrl')
  final String? avatar;
  @JsonKey(defaultValue: 'member')
  final String role;
  final DateTime? joinedAt;
  @JsonKey(defaultValue: 0)
  final int unreadCount;
  @JsonKey(defaultValue: false)
  final bool isMuted;
  @JsonKey(defaultValue: false)
  final bool isPinned;

  const ParticipantDto({
    this.userId,
    this.name,
    this.avatar,
    this.role = 'member',
    this.joinedAt,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
  });

  // Getter for backward compatibility
  String get id => userId ?? '';

  factory ParticipantDto.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ParticipantDtoToJson(this);
}

@JsonSerializable()
class CreateConversationDto {
  final String type;
  final String? name;
  final String? description;
  final List<String> participantIds;

  const CreateConversationDto({
    this.type = 'direct',
    this.name,
    this.description,
    required this.participantIds,
  });

  factory CreateConversationDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateConversationDtoToJson(this);
}

/// Backend returns ServiceResponseDto<PaginatedResponseDto<ConversationDto>>
/// This class handles unwrapping the response
class ConversationListDto {
  final List<ConversationDto> conversations;
  final int total;
  final String? nextCursor;
  final bool hasMore;

  const ConversationListDto({
    required this.conversations,
    required this.total,
    this.nextCursor,
    this.hasMore = false,
  });

  factory ConversationListDto.fromJson(Map<String, dynamic> json) {
    // Handle wrapped ServiceResponseDto format
    final data = json['data'] ?? json;

    // Handle PaginatedResponseDto format (uses 'items')
    final items = data['items'] ?? data['conversations'] ?? [];

    return ConversationListDto(
      conversations: (items as List<dynamic>)
          .map((e) => ConversationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (data['total'] as num?)?.toInt() ?? 0,
      nextCursor: data['nextCursor'] as String?,
      hasMore: data['hasMore'] as bool? ?? data['hasNext'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'conversations': conversations.map((c) => c.toJson()).toList(),
    'total': total,
    'nextCursor': nextCursor,
    'hasMore': hasMore,
  };
}

@JsonSerializable()
class UpdateConversationDto {
  final String? name;
  final String? description;
  final String? avatar;
  final bool? isMuted;
  final bool? isPinned;

  const UpdateConversationDto({
    this.name,
    this.description,
    this.avatar,
    this.isMuted,
    this.isPinned,
  });

  factory UpdateConversationDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateConversationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateConversationDtoToJson(this);
}
