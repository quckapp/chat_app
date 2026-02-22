import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/participant.dart';
import 'package:chat_app/models/attachment.dart';
import 'package:chat_app/models/reaction.dart';
import 'package:chat_app/models/call_record.dart';
import 'package:chat_app/models/auth_response.dart';
import 'package:chat_app/models/presence.dart';
import 'package:chat_app/models/permission.dart';

// ==================== Factory Functions ====================

final _now = DateTime(2025, 1, 15, 10, 30, 0);

User makeUser({
  String id = 'user-1',
  String phoneNumber = '+919876543210',
  String? email,
  String? username,
  String? firstName = 'John',
  String? lastName = 'Doe',
  String? displayName,
  String? avatar,
  bool phoneVerified = true,
  bool isNewUser = false,
  DateTime? createdAt,
  UserStatus status = UserStatus.online,
}) {
  return User(
    id: id,
    phoneNumber: phoneNumber,
    email: email,
    username: username,
    firstName: firstName,
    lastName: lastName,
    displayName: displayName,
    avatar: avatar,
    phoneVerified: phoneVerified,
    isNewUser: isNewUser,
    createdAt: createdAt ?? _now,
    status: status,
  );
}

Participant makeParticipant({
  String id = 'participant-1',
  String? username,
  String? displayName,
  String? firstName,
  String? lastName,
  String? avatar,
  ParticipantRole role = ParticipantRole.member,
  DateTime? joinedAt,
  String? phoneNumber,
}) {
  return Participant(
    id: id,
    username: username,
    displayName: displayName,
    firstName: firstName,
    lastName: lastName,
    avatar: avatar,
    role: role,
    joinedAt: joinedAt ?? _now,
    phoneNumber: phoneNumber,
  );
}

Attachment makeAttachment({
  String id = 'attachment-1',
  String type = 'image',
  String url = 'https://example.com/image.png',
  String? name = 'image.png',
  int? size = 1024,
  String? mimeType = 'image/png',
  String? thumbnailUrl,
  int? width,
  int? height,
  int? duration,
}) {
  return Attachment(
    id: id,
    type: type,
    url: url,
    name: name,
    size: size,
    mimeType: mimeType,
    thumbnailUrl: thumbnailUrl,
    width: width,
    height: height,
    duration: duration,
  );
}

Reaction makeReaction({
  String emoji = '👍',
  List<String> userIds = const ['user-1', 'user-2'],
  int? count,
}) {
  return Reaction(emoji: emoji, userIds: userIds, count: count);
}

Message makeMessage({
  String id = 'msg-1',
  String conversationId = 'conv-1',
  String senderId = 'user-1',
  String type = 'text',
  String content = 'Hello, world!',
  List<Attachment> attachments = const [],
  String? replyTo,
  bool isEdited = false,
  bool isDeleted = false,
  List<Reaction> reactions = const [],
  List<String> readBy = const [],
  DateTime? createdAt,
  DateTime? updatedAt,
  bool isPending = false,
  bool hasFailed = false,
  String? clientId,
}) {
  return Message(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    type: type,
    content: content,
    attachments: attachments,
    replyTo: replyTo,
    isEdited: isEdited,
    isDeleted: isDeleted,
    reactions: reactions,
    readBy: readBy,
    createdAt: createdAt ?? _now,
    updatedAt: updatedAt,
    isPending: isPending,
    hasFailed: hasFailed,
    clientId: clientId,
  );
}

Conversation makeConversation({
  String id = 'conv-1',
  String type = 'direct',
  String? name,
  String? description,
  String? avatar,
  List<Participant>? participants,
  Message? lastMessage,
  int unreadCount = 0,
  bool isMuted = false,
  bool isPinned = false,
  int disappearingMessagesTimer = 0,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return Conversation(
    id: id,
    type: type,
    name: name,
    description: description,
    avatar: avatar,
    participants: participants ?? [],
    lastMessage: lastMessage,
    unreadCount: unreadCount,
    isMuted: isMuted,
    isPinned: isPinned,
    disappearingMessagesTimer: disappearingMessagesTimer,
    createdAt: createdAt ?? _now,
    updatedAt: updatedAt,
  );
}

CallRecord makeCallRecord({
  String id = 'call-1',
  String recipientId = 'user-2',
  String recipientName = 'Jane Doe',
  String? recipientAvatar,
  CallType type = CallType.voice,
  CallStatus status = CallStatus.completed,
  DateTime? timestamp,
  int? durationSeconds = 120,
  bool isOutgoing = true,
}) {
  return CallRecord(
    id: id,
    recipientId: recipientId,
    recipientName: recipientName,
    recipientAvatar: recipientAvatar,
    type: type,
    status: status,
    timestamp: timestamp ?? _now,
    durationSeconds: durationSeconds,
    isOutgoing: isOutgoing,
  );
}

AuthResponse makeAuthResponse({
  String accessToken = 'access-token-123',
  String refreshToken = 'refresh-token-456',
  User? user,
}) {
  return AuthResponse(
    accessToken: accessToken,
    refreshToken: refreshToken,
    user: user ?? makeUser(),
  );
}

UserPresence makeUserPresence({
  String userId = 'user-1',
  PresenceStatus status = PresenceStatus.online,
  DateTime? lastSeen,
  String? statusMessage,
  Map<String, dynamic>? meta,
}) {
  return UserPresence(
    userId: userId,
    status: status,
    lastSeen: lastSeen,
    statusMessage: statusMessage,
    meta: meta,
  );
}

Permission makePermission({
  String id = 'perm-1',
  String name = 'read:messages',
  String? description,
  String? resource,
  String? action,
  DateTime? createdAt,
}) {
  return Permission(
    id: id,
    name: name,
    description: description,
    resource: resource,
    action: action,
    createdAt: createdAt,
  );
}

Role makeRole({
  String id = 'role-1',
  String name = 'admin',
  String? description,
  List<Permission>? permissions,
  DateTime? createdAt,
}) {
  return Role(
    id: id,
    name: name,
    description: description,
    permissions: permissions ?? [],
    createdAt: createdAt,
  );
}

UserPermissions makeUserPermissions({
  String userId = 'user-1',
  List<Role>? roles,
  List<Permission>? directPermissions,
}) {
  return UserPermissions(
    userId: userId,
    roles: roles ?? [],
    directPermissions: directPermissions ?? [],
  );
}
