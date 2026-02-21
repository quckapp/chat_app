import 'package:equatable/equatable.dart';
import '../../models/poll.dart';
import '../../models/scheduled_message.dart';
import '../../models/channel_extras.dart';

/// Status of channel extras operations
enum ChannelExtrasStatus { initial, loading, loaded, error }

/// State for the channel extras BLoC
class ChannelExtrasState extends Equatable {
  final ChannelExtrasStatus status;
  final List<Poll> polls;
  final List<ScheduledMessage> scheduledMessages;
  final List<ChannelLink> links;
  final List<ChannelTab> tabs;
  final List<ChannelTemplate> templates;
  final String? error;

  const ChannelExtrasState({
    this.status = ChannelExtrasStatus.initial,
    this.polls = const [],
    this.scheduledMessages = const [],
    this.links = const [],
    this.tabs = const [],
    this.templates = const [],
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == ChannelExtrasStatus.loading;

  /// Whether there's an error
  bool get hasError => status == ChannelExtrasStatus.error && error != null;

  ChannelExtrasState copyWith({
    ChannelExtrasStatus? status,
    List<Poll>? polls,
    List<ScheduledMessage>? scheduledMessages,
    List<ChannelLink>? links,
    List<ChannelTab>? tabs,
    List<ChannelTemplate>? templates,
    String? error,
  }) {
    return ChannelExtrasState(
      status: status ?? this.status,
      polls: polls ?? this.polls,
      scheduledMessages: scheduledMessages ?? this.scheduledMessages,
      links: links ?? this.links,
      tabs: tabs ?? this.tabs,
      templates: templates ?? this.templates,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, polls, scheduledMessages, links, tabs, templates, error];
}
