import 'package:equatable/equatable.dart';
import '../../models/serializable/channel_dto.dart';

/// Base class for all channel events
abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object?> get props => [];
}

/// Load channels for a workspace
class ChannelLoad extends ChannelEvent {
  final String workspaceId;
  final int page;
  final int perPage;

  const ChannelLoad({required this.workspaceId, this.page = 1, this.perPage = 20});

  @override
  List<Object?> get props => [workspaceId, page, perPage];
}

/// Create a new channel
class ChannelCreate extends ChannelEvent {
  final CreateChannelDto data;

  const ChannelCreate({required this.data});

  @override
  List<Object?> get props => [data];
}

/// Update a channel
class ChannelUpdate extends ChannelEvent {
  final String channelId;
  final UpdateChannelDto data;

  const ChannelUpdate({required this.channelId, required this.data});

  @override
  List<Object?> get props => [channelId, data];
}

/// Delete a channel
class ChannelDelete extends ChannelEvent {
  final String channelId;

  const ChannelDelete({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Select active channel
class ChannelSelectActive extends ChannelEvent {
  final String channelId;

  const ChannelSelectActive({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Join a channel
class ChannelJoin extends ChannelEvent {
  final String channelId;

  const ChannelJoin({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Leave a channel
class ChannelLeave extends ChannelEvent {
  final String channelId;

  const ChannelLeave({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Load members for a channel
class ChannelLoadMembers extends ChannelEvent {
  final String channelId;

  const ChannelLoadMembers({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Add member to a channel
class ChannelAddMember extends ChannelEvent {
  final String channelId;
  final String userId;

  const ChannelAddMember({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

/// Remove member from a channel
class ChannelRemoveMember extends ChannelEvent {
  final String channelId;
  final String userId;

  const ChannelRemoveMember({required this.channelId, required this.userId});

  @override
  List<Object?> get props => [channelId, userId];
}

/// Load pinned messages
class ChannelLoadPins extends ChannelEvent {
  final String channelId;

  const ChannelLoadPins({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Pin a message
class ChannelPinMessage extends ChannelEvent {
  final String channelId;
  final String messageId;

  const ChannelPinMessage({required this.channelId, required this.messageId});

  @override
  List<Object?> get props => [channelId, messageId];
}

/// Unpin a message
class ChannelUnpinMessage extends ChannelEvent {
  final String channelId;
  final String pinId;

  const ChannelUnpinMessage({required this.channelId, required this.pinId});

  @override
  List<Object?> get props => [channelId, pinId];
}

/// Clear error state
class ChannelClearError extends ChannelEvent {
  const ChannelClearError();
}
