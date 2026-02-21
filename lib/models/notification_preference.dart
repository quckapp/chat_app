import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'notification_preference.g.dart';

/// Represents notification preferences for a channel
@HiveType(typeId: 30)
class NotificationPreference extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String? channelId;
  @HiveField(3)
  final DateTime? muteUntil;
  @HiveField(4)
  final bool pushEnabled;
  @HiveField(5)
  final bool emailEnabled;
  @HiveField(6)
  final bool soundEnabled;

  const NotificationPreference({
    required this.id,
    required this.userId,
    this.channelId,
    this.muteUntil,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.soundEnabled = true,
  });

  bool get isMuted =>
      muteUntil != null && muteUntil!.isAfter(DateTime.now());

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String?,
      muteUntil: json['mute_until'] != null
          ? DateTime.parse(json['mute_until'] as String)
          : json['muteUntil'] != null
              ? DateTime.parse(json['muteUntil'] as String)
              : null,
      pushEnabled: json['push_enabled'] as bool? ?? json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['email_enabled'] as bool? ?? json['emailEnabled'] as bool? ?? true,
      soundEnabled: json['sound_enabled'] as bool? ?? json['soundEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'channel_id': channelId,
      'mute_until': muteUntil?.toIso8601String(),
      'push_enabled': pushEnabled,
      'email_enabled': emailEnabled,
      'sound_enabled': soundEnabled,
    };
  }

  NotificationPreference copyWith({
    String? id,
    String? userId,
    String? channelId,
    DateTime? muteUntil,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? soundEnabled,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      muteUntil: muteUntil ?? this.muteUntil,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, channelId, muteUntil, pushEnabled, emailEnabled, soundEnabled,
      ];
}
