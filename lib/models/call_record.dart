import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'call_record.g.dart';

@HiveType(typeId: 8)
enum CallType {
  @HiveField(0)
  voice,
  @HiveField(1)
  video,
}

@HiveType(typeId: 9)
enum CallStatus {
  @HiveField(0)
  completed,
  @HiveField(1)
  missed,
  @HiveField(2)
  declined,
  @HiveField(3)
  ongoing,
}

/// Represents a call record for call history
@HiveType(typeId: 10)
class CallRecord extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String recipientId;
  @HiveField(2)
  final String recipientName;
  @HiveField(3)
  final String? recipientAvatar;
  @HiveField(4)
  final CallType type;
  @HiveField(5)
  final CallStatus status;
  @HiveField(6)
  final DateTime timestamp;
  @HiveField(7)
  final int? durationSeconds;
  @HiveField(8)
  final bool isOutgoing;

  const CallRecord({
    required this.id,
    required this.recipientId,
    required this.recipientName,
    this.recipientAvatar,
    required this.type,
    required this.status,
    required this.timestamp,
    this.durationSeconds,
    this.isOutgoing = true,
  });

  bool get isVoice => type == CallType.voice;
  bool get isVideo => type == CallType.video;
  bool get isMissed => status == CallStatus.missed;
  bool get isDeclined => status == CallStatus.declined;
  bool get isCompleted => status == CallStatus.completed;

  Duration? get duration =>
      durationSeconds != null ? Duration(seconds: durationSeconds!) : null;

  factory CallRecord.fromJson(Map<String, dynamic> json) {
    return CallRecord(
      id: json['id'] as String? ?? '',
      recipientId: json['recipientId'] as String? ?? '',
      recipientName: json['recipientName'] as String? ?? 'Unknown',
      recipientAvatar: json['recipientAvatar'] as String?,
      type: CallType.values.firstWhere(
        (t) => t.name == (json['type'] as String? ?? 'voice'),
        orElse: () => CallType.voice,
      ),
      status: CallStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'completed'),
        orElse: () => CallStatus.completed,
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      durationSeconds: json['durationSeconds'] as int?,
      isOutgoing: json['isOutgoing'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'recipientAvatar': recipientAvatar,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
      'isOutgoing': isOutgoing,
    };
  }

  CallRecord copyWith({
    String? id,
    String? recipientId,
    String? recipientName,
    String? recipientAvatar,
    CallType? type,
    CallStatus? status,
    DateTime? timestamp,
    int? durationSeconds,
    bool? isOutgoing,
  }) {
    return CallRecord(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientAvatar: recipientAvatar ?? this.recipientAvatar,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isOutgoing: isOutgoing ?? this.isOutgoing,
    );
  }

  @override
  List<Object?> get props => [
        id,
        recipientId,
        recipientName,
        recipientAvatar,
        type,
        status,
        timestamp,
        durationSeconds,
        isOutgoing,
      ];
}
