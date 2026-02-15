import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final String id;
  final String phoneNumber;
  final String? email;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? avatar;
  final bool phoneVerified;
  @JsonKey(name: 'newUser')
  final bool isNewUser;
  final DateTime? createdAt;
  final String? status;

  const UserDto({
    required this.id,
    required this.phoneNumber,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatar,
    this.phoneVerified = false,
    this.isNewUser = false,
    this.createdAt,
    this.status,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

@JsonSerializable()
class UserProfileUpdateDto {
  final String? firstName;
  final String? lastName;
  final String? displayName;
  final String? avatar;
  final String? email;

  const UserProfileUpdateDto({
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatar,
    this.email,
  });

  factory UserProfileUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileUpdateDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileUpdateDtoToJson(this);
}

/// User summary from search results
@JsonSerializable()
class UserSummaryDto {
  final String id;
  final String? username;
  final String? displayName;
  @JsonKey(name: 'avatarUrl')
  final String? avatar;
  final String? status;

  const UserSummaryDto({
    required this.id,
    this.username,
    this.displayName,
    this.avatar,
    this.status,
  });

  factory UserSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$UserSummaryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserSummaryDtoToJson(this);
}

/// Search result with pagination - wraps API response
class UserSearchResultDto {
  final List<UserSummaryDto> users;
  final int total;
  final int page;
  final int pageSize;

  const UserSearchResultDto({
    required this.users,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  /// Parse from API response: { success, message, data: { content, page, size, totalElements, ... } }
  factory UserSearchResultDto.fromJson(Map<String, dynamic> json) {
    // Handle wrapped ApiResponse format
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final content = data['content'] as List<dynamic>? ?? [];

    return UserSearchResultDto(
      users: content
          .map((e) => UserSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (data['totalElements'] as int?) ?? content.length,
      page: (data['page'] as int?) ?? 0,
      pageSize: (data['size'] as int?) ?? 20,
    );
  }
}
