import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'search_result.g.dart';

/// Type of search result
@HiveType(typeId: 27)
enum SearchResultType {
  @HiveField(0)
  message,
  @HiveField(1)
  user,
  @HiveField(2)
  channel,
  @HiveField(3)
  file;

  static SearchResultType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'user':
        return SearchResultType.user;
      case 'channel':
        return SearchResultType.channel;
      case 'file':
        return SearchResultType.file;
      default:
        return SearchResultType.message;
    }
  }
}

/// Represents a search result item
@HiveType(typeId: 26)
class SearchResult extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final SearchResultType type;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? snippet;
  @HiveField(4)
  final String? channelId;
  @HiveField(5)
  final String? channelName;
  @HiveField(6)
  final String? userId;
  @HiveField(7)
  final String? userName;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
  final double score;

  const SearchResult({
    required this.id,
    required this.type,
    required this.title,
    this.snippet,
    this.channelId,
    this.channelName,
    this.userId,
    this.userName,
    this.createdAt,
    this.score = 0.0,
  });

  bool get isMessage => type == SearchResultType.message;
  bool get isUser => type == SearchResultType.user;
  bool get isChannel => type == SearchResultType.channel;
  bool get isFile => type == SearchResultType.file;

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] as String? ?? '',
      type: SearchResultType.fromString(json['type'] as String?),
      title: json['title'] as String? ?? '',
      snippet: json['snippet'] as String?,
      channelId: json['channel_id'] as String? ?? json['channelId'] as String?,
      channelName: json['channel_name'] as String? ?? json['channelName'] as String?,
      userId: json['user_id'] as String? ?? json['userId'] as String?,
      userName: json['user_name'] as String? ?? json['userName'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : null,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'snippet': snippet,
      'channel_id': channelId,
      'channel_name': channelName,
      'user_id': userId,
      'user_name': userName,
      'created_at': createdAt?.toIso8601String(),
      'score': score,
    };
  }

  SearchResult copyWith({
    String? id,
    SearchResultType? type,
    String? title,
    String? snippet,
    String? channelId,
    String? channelName,
    String? userId,
    String? userName,
    DateTime? createdAt,
    double? score,
  }) {
    return SearchResult(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      channelId: channelId ?? this.channelId,
      channelName: channelName ?? this.channelName,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [
        id, type, title, snippet, channelId, channelName,
        userId, userName, createdAt, score,
      ];
}
