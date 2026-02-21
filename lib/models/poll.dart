import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'poll.g.dart';

/// Represents a poll option with vote tracking
@HiveType(typeId: 35)
class PollOption extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final int voteCount;
  @HiveField(3)
  final List<String> voterIds;

  const PollOption({
    required this.id,
    required this.text,
    this.voteCount = 0,
    this.voterIds = const [],
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      voteCount: (json['vote_count'] as num?)?.toInt() ??
          (json['voteCount'] as num?)?.toInt() ??
          0,
      voterIds: (json['voter_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['voterIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'vote_count': voteCount,
      'voter_ids': voterIds,
    };
  }

  PollOption copyWith({
    String? id,
    String? text,
    int? voteCount,
    List<String>? voterIds,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      voteCount: voteCount ?? this.voteCount,
      voterIds: voterIds ?? this.voterIds,
    );
  }

  @override
  List<Object?> get props => [id, text, voteCount, voterIds];
}

/// Represents a poll in a channel
@HiveType(typeId: 34)
class Poll extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String channelId;
  @HiveField(2)
  final String createdBy;
  @HiveField(3)
  final String question;
  @HiveField(4)
  final List<PollOption> options;
  @HiveField(5)
  final bool isAnonymous;
  @HiveField(6)
  final bool allowMultiple;
  @HiveField(7)
  final DateTime? expiresAt;
  @HiveField(8)
  final int totalVotes;
  @HiveField(9)
  final DateTime createdAt;
  @HiveField(10)
  final bool isClosed;

  const Poll({
    required this.id,
    required this.channelId,
    required this.createdBy,
    required this.question,
    this.options = const [],
    this.isAnonymous = false,
    this.allowMultiple = false,
    this.expiresAt,
    this.totalVotes = 0,
    required this.createdAt,
    this.isClosed = false,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'] as String? ?? '',
      channelId: json['channel_id'] as String? ?? json['channelId'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => PollOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isAnonymous: json['is_anonymous'] as bool? ?? json['isAnonymous'] as bool? ?? false,
      allowMultiple: json['allow_multiple'] as bool? ?? json['allowMultiple'] as bool? ?? false,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : json['expiresAt'] != null
              ? DateTime.parse(json['expiresAt'] as String)
              : null,
      totalVotes: (json['total_votes'] as num?)?.toInt() ??
          (json['totalVotes'] as num?)?.toInt() ??
          0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      isClosed: json['is_closed'] as bool? ?? json['isClosed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'created_by': createdBy,
      'question': question,
      'options': options.map((o) => o.toJson()).toList(),
      'is_anonymous': isAnonymous,
      'allow_multiple': allowMultiple,
      'expires_at': expiresAt?.toIso8601String(),
      'total_votes': totalVotes,
      'created_at': createdAt.toIso8601String(),
      'is_closed': isClosed,
    };
  }

  Poll copyWith({
    String? id,
    String? channelId,
    String? createdBy,
    String? question,
    List<PollOption>? options,
    bool? isAnonymous,
    bool? allowMultiple,
    DateTime? expiresAt,
    int? totalVotes,
    DateTime? createdAt,
    bool? isClosed,
  }) {
    return Poll(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      createdBy: createdBy ?? this.createdBy,
      question: question ?? this.question,
      options: options ?? this.options,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowMultiple: allowMultiple ?? this.allowMultiple,
      expiresAt: expiresAt ?? this.expiresAt,
      totalVotes: totalVotes ?? this.totalVotes,
      createdAt: createdAt ?? this.createdAt,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  List<Object?> get props => [
        id,
        channelId,
        createdBy,
        question,
        options,
        isAnonymous,
        allowMultiple,
        expiresAt,
        totalVotes,
        createdAt,
        isClosed,
      ];
}
