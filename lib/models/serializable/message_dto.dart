import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDto {
  final String id;
  final String conversationId;
  final String senderId;
  final String type;
  final String content;
  final List<AttachmentDto>? attachments;
  final String? replyTo;
  final bool isEdited;
  final bool isDeleted;
  final List<ReactionDto>? reactions;
  final List<String>? readBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? clientId;

  const MessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.type = 'text',
    required this.content,
    this.attachments,
    this.replyTo,
    this.isEdited = false,
    this.isDeleted = false,
    this.reactions,
    this.readBy,
    required this.createdAt,
    this.updatedAt,
    this.clientId,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}

@JsonSerializable()
class AttachmentDto {
  final String id;
  final String type;
  final String url;
  final String? name;
  final int? size;
  final String? mimeType;
  final int? width;
  final int? height;
  final String? thumbnailUrl;

  const AttachmentDto({
    required this.id,
    required this.type,
    required this.url,
    this.name,
    this.size,
    this.mimeType,
    this.width,
    this.height,
    this.thumbnailUrl,
  });

  factory AttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentDtoToJson(this);
}

@JsonSerializable()
class ReactionDto {
  final String emoji;
  final List<String> userIds;
  final int count;

  const ReactionDto({
    required this.emoji,
    required this.userIds,
    required this.count,
  });

  factory ReactionDto.fromJson(Map<String, dynamic> json) =>
      _$ReactionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ReactionDtoToJson(this);
}

@JsonSerializable()
class SendMessageDto {
  final String conversationId;
  final String type;
  final String content;
  final List<AttachmentDto>? attachments;
  final String? replyTo;
  final String? clientId;

  const SendMessageDto({
    required this.conversationId,
    this.type = 'text',
    required this.content,
    this.attachments,
    this.replyTo,
    this.clientId,
  });

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageDtoToJson(this);
}

@JsonSerializable()
class MessageListDto {
  final List<MessageDto> messages;
  final int total;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMore;

  const MessageListDto({
    required this.messages,
    required this.total,
    this.nextCursor,
    this.prevCursor,
    this.hasMore = false,
  });

  factory MessageListDto.fromJson(Map<String, dynamic> json) =>
      _$MessageListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MessageListDtoToJson(this);
}
