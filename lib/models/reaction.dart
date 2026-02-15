import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'reaction.g.dart';

/// Represents a reaction to a message
@HiveType(typeId: 4)
class Reaction extends Equatable {
  @HiveField(0)
  final String emoji;
  @HiveField(1)
  final List<String> userIds;
  @HiveField(2)
  final int count;

  const Reaction({
    required this.emoji,
    required this.userIds,
    int? count,
  }) : count = count ?? userIds.length;

  bool hasReacted(String userId) => userIds.contains(userId);

  factory Reaction.fromJson(Map<String, dynamic> json) {
    final userIds = (json['userIds'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];
    return Reaction(
      emoji: json['emoji'] as String? ?? '',
      userIds: userIds,
      count: json['count'] as int? ?? userIds.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'userIds': userIds,
      'count': count,
    };
  }

  Reaction copyWith({
    String? emoji,
    List<String>? userIds,
    int? count,
  }) {
    return Reaction(
      emoji: emoji ?? this.emoji,
      userIds: userIds ?? this.userIds,
      count: count,
    );
  }

  @override
  List<Object?> get props => [emoji, userIds, count];
}
