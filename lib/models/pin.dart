import 'package:equatable/equatable.dart';

/// Represents a pinned message in a channel (no Hive caching)
class PinnedMessage extends Equatable {
  final String id;
  final String channelId;
  final String messageId;
  final String pinnedBy;
  final DateTime pinnedAt;

  const PinnedMessage({
    required this.id,
    required this.channelId,
    required this.messageId,
    required this.pinnedBy,
    required this.pinnedAt,
  });

  factory PinnedMessage.fromJson(Map<String, dynamic> json) {
    return PinnedMessage(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      messageId: json['message_id'] as String? ?? json['messageId'] as String? ?? '',
      pinnedBy: json['pinned_by'] as String? ?? json['pinnedBy'] as String? ?? '',
      pinnedAt: json['pinned_at'] != null
          ? DateTime.parse(json['pinned_at'] as String)
          : json['pinnedAt'] != null
              ? DateTime.parse(json['pinnedAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'channel_id': channelId, 'message_id': messageId,
    'pinned_by': pinnedBy, 'pinned_at': pinnedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, channelId, messageId, pinnedBy, pinnedAt];
}
