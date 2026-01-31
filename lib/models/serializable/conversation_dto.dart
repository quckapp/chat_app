import 'package:json_annotation/json_annotation.dart';
import 'message_dto.dart';

part 'conversation_dto.g.dart';

@JsonSerializable()
class ConversationDto {
  final String id;
  final String type;
  final String? name;
  final String? description;
  final String? avatar;
  final List<ParticipantDto>? participants;
  final MessageDto? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final DateTime createdAt;
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
    required this.createdAt,
    this.updatedAt,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationDtoToJson(this);
}

@JsonSerializable()
class ParticipantDto {
  final String id;
  final String name;
  final String? avatar;
  final String role;
  final DateTime? joinedAt;

  const ParticipantDto({
    required this.id,
    required this.name,
    this.avatar,
    this.role = 'member',
    this.joinedAt,
  });

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

@JsonSerializable()
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

  factory ConversationListDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationListDtoToJson(this);
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
