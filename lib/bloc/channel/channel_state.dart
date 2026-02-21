import 'package:equatable/equatable.dart';
import '../../models/channel.dart';
import '../../models/pin.dart';

/// Status of channel operations
enum ChannelStatus { initial, loading, loaded, error }

/// State for the channel BLoC
class ChannelState extends Equatable {
  final ChannelStatus status;
  final List<Channel> channels;
  final Channel? activeChannel;
  final Map<String, List<ChannelMember>> members;
  final Map<String, List<PinnedMessage>> pins;
  final String? error;

  const ChannelState({
    this.status = ChannelStatus.initial,
    this.channels = const [],
    this.activeChannel,
    this.members = const {},
    this.pins = const {},
    this.error,
  });

  /// Get members for a specific channel
  List<ChannelMember> membersFor(String channelId) => members[channelId] ?? [];

  /// Get pins for a specific channel
  List<PinnedMessage> pinsFor(String channelId) => pins[channelId] ?? [];

  /// Whether the state is in loading status
  bool get isLoading => status == ChannelStatus.loading;

  /// Whether there's an error
  bool get hasError => status == ChannelStatus.error && error != null;

  ChannelState copyWith({
    ChannelStatus? status,
    List<Channel>? channels,
    Channel? activeChannel,
    Map<String, List<ChannelMember>>? members,
    Map<String, List<PinnedMessage>>? pins,
    String? error,
  }) {
    return ChannelState(
      status: status ?? this.status,
      channels: channels ?? this.channels,
      activeChannel: activeChannel ?? this.activeChannel,
      members: members ?? this.members,
      pins: pins ?? this.pins,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, channels, activeChannel, members, pins, error];
}
