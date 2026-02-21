import 'package:equatable/equatable.dart';
import '../../models/serializable/poll_dto.dart';
import '../../models/serializable/scheduled_message_dto.dart';
import '../../models/serializable/channel_extras_dto.dart';

/// Base class for all channel extras events
abstract class ChannelExtrasEvent extends Equatable {
  const ChannelExtrasEvent();

  @override
  List<Object?> get props => [];
}

// --- Poll Events ---

/// Load polls for a channel
class LoadPolls extends ChannelExtrasEvent {
  final String channelId;

  const LoadPolls({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Create a new poll
class CreatePoll extends ChannelExtrasEvent {
  final String channelId;
  final CreatePollDto data;

  const CreatePoll({required this.channelId, required this.data});

  @override
  List<Object?> get props => [channelId, data];
}

/// Vote on a poll
class VotePoll extends ChannelExtrasEvent {
  final String channelId;
  final String pollId;
  final VotePollDto data;

  const VotePoll({
    required this.channelId,
    required this.pollId,
    required this.data,
  });

  @override
  List<Object?> get props => [channelId, pollId, data];
}

/// Close a poll
class ClosePoll extends ChannelExtrasEvent {
  final String channelId;
  final String pollId;

  const ClosePoll({required this.channelId, required this.pollId});

  @override
  List<Object?> get props => [channelId, pollId];
}

// --- Scheduled Message Events ---

/// Load scheduled messages for a channel
class LoadScheduledMessages extends ChannelExtrasEvent {
  final String channelId;

  const LoadScheduledMessages({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Create a new scheduled message
class CreateScheduledMessage extends ChannelExtrasEvent {
  final String channelId;
  final CreateScheduledMessageDto data;

  const CreateScheduledMessage({required this.channelId, required this.data});

  @override
  List<Object?> get props => [channelId, data];
}

/// Cancel a scheduled message
class CancelScheduledMessage extends ChannelExtrasEvent {
  final String channelId;
  final String messageId;

  const CancelScheduledMessage({required this.channelId, required this.messageId});

  @override
  List<Object?> get props => [channelId, messageId];
}

// --- Link Events ---

/// Load links for a channel
class LoadLinks extends ChannelExtrasEvent {
  final String channelId;

  const LoadLinks({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Create a new link
class CreateLink extends ChannelExtrasEvent {
  final String channelId;
  final CreateChannelLinkDto data;

  const CreateLink({required this.channelId, required this.data});

  @override
  List<Object?> get props => [channelId, data];
}

/// Delete a link
class DeleteLink extends ChannelExtrasEvent {
  final String channelId;
  final String linkId;

  const DeleteLink({required this.channelId, required this.linkId});

  @override
  List<Object?> get props => [channelId, linkId];
}

// --- Tab Events ---

/// Load tabs for a channel
class LoadTabs extends ChannelExtrasEvent {
  final String channelId;

  const LoadTabs({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Create a new tab
class CreateTab extends ChannelExtrasEvent {
  final String channelId;
  final CreateChannelTabDto data;

  const CreateTab({required this.channelId, required this.data});

  @override
  List<Object?> get props => [channelId, data];
}

/// Delete a tab
class DeleteTab extends ChannelExtrasEvent {
  final String channelId;
  final String tabId;

  const DeleteTab({required this.channelId, required this.tabId});

  @override
  List<Object?> get props => [channelId, tabId];
}

// --- Template Events ---

/// Load templates for a channel
class LoadTemplates extends ChannelExtrasEvent {
  final String channelId;

  const LoadTemplates({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Create a new template
class CreateTemplate extends ChannelExtrasEvent {
  final String channelId;
  final CreateChannelTemplateDto data;

  const CreateTemplate({required this.channelId, required this.data});

  @override
  List<Object?> get props => [channelId, data];
}

/// Delete a template
class DeleteTemplate extends ChannelExtrasEvent {
  final String channelId;
  final String templateId;

  const DeleteTemplate({required this.channelId, required this.templateId});

  @override
  List<Object?> get props => [channelId, templateId];
}

/// Clear error state
class ClearChannelExtrasError extends ChannelExtrasEvent {
  const ClearChannelExtrasError();
}
