import 'package:equatable/equatable.dart';

/// Base class for all huddle events
abstract class HuddleEvent extends Equatable {
  const HuddleEvent();

  @override
  List<Object?> get props => [];
}

/// Load active huddles
class HuddleLoad extends HuddleEvent {
  final String? channelId;

  const HuddleLoad({this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Create a new huddle
class HuddleCreate extends HuddleEvent {
  final String channelId;

  const HuddleCreate({required this.channelId});

  @override
  List<Object?> get props => [channelId];
}

/// Join an existing huddle
class HuddleJoin extends HuddleEvent {
  final String huddleId;

  const HuddleJoin({required this.huddleId});

  @override
  List<Object?> get props => [huddleId];
}

/// Leave the current huddle
class HuddleLeave extends HuddleEvent {
  final String huddleId;

  const HuddleLeave({required this.huddleId});

  @override
  List<Object?> get props => [huddleId];
}

/// Clear error state
class HuddleClearError extends HuddleEvent {
  const HuddleClearError();
}
