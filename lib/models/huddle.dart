import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'huddle.g.dart';

/// Status of a huddle
@HiveType(typeId: 33)
enum HuddleStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  ended;

  static HuddleStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'ended':
        return HuddleStatus.ended;
      default:
        return HuddleStatus.active;
    }
  }
}

/// Represents a huddle (lightweight audio chat) in a channel
@HiveType(typeId: 32)
class Huddle extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String createdBy;
  @HiveField(3)
  final HuddleStatus status;
  @HiveField(4)
  final List<String> participantIds;
  @HiveField(5)
  final int maxParticipants;
  @HiveField(6)
  final DateTime createdAt;

  const Huddle({
    required this.id,
    required this.channelId,
    required this.createdBy,
    this.status = HuddleStatus.active,
    this.participantIds = const [],
    this.maxParticipants = 50,
    required this.createdAt,
  });

  bool get isActive => status == HuddleStatus.active;
  bool get isEnded => status == HuddleStatus.ended;
  bool get isFull => participantIds.length >= maxParticipants;
  int get participantCount => participantIds.length;

  factory Huddle.fromJson(Map<String, dynamic> json) {
    return Huddle(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      status: HuddleStatus.fromString(json['status'] as String?),
      participantIds: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      maxParticipants: (json['max_participants'] as num?)?.toInt() ??
          (json['maxParticipants'] as num?)?.toInt() ?? 50,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'created_by': createdBy,
      'status': status.name,
      'participant_ids': participantIds,
      'max_participants': maxParticipants,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Huddle copyWith({
    String? id,
    String? channelId,
    String? createdBy,
    HuddleStatus? status,
    List<String>? participantIds,
    int? maxParticipants,
    DateTime? createdAt,
  }) {
    return Huddle(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      createdBy: createdBy ?? this.createdBy,
      status: status ?? this.status,
      participantIds: participantIds ?? this.participantIds,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, channelId, createdBy, status, participantIds, maxParticipants, createdAt,
      ];
}
