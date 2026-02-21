import 'package:equatable/equatable.dart';
import '../../models/huddle.dart';

/// Status of huddle operations
enum HuddleStatus { initial, loading, loaded, error }

/// State for the huddle BLoC
class HuddleState extends Equatable {
  final HuddleStatus status;
  final List<Huddle> huddles;
  final Huddle? activeHuddle;
  final String? error;

  const HuddleState({
    this.status = HuddleStatus.initial,
    this.huddles = const [],
    this.activeHuddle,
    this.error,
  });

  /// Whether the state is in loading status
  bool get isLoading => status == HuddleStatus.loading;

  /// Whether there's an error
  bool get hasError => status == HuddleStatus.error && error != null;

  /// Whether there's an active huddle
  bool get hasActiveHuddle => activeHuddle != null;

  HuddleState copyWith({
    HuddleStatus? status,
    List<Huddle>? huddles,
    Huddle? activeHuddle,
    String? error,
    bool clearActiveHuddle = false,
  }) {
    return HuddleState(
      status: status ?? this.status,
      huddles: huddles ?? this.huddles,
      activeHuddle: clearActiveHuddle ? null : (activeHuddle ?? this.activeHuddle),
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, huddles, activeHuddle, error];
}
