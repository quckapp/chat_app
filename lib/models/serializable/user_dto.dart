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

@JsonSerializable()
class UserSearchResultDto {
  final List<UserDto> users;
  final int total;
  final int page;
  final int pageSize;

  const UserSearchResultDto({
    required this.users,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory UserSearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$UserSearchResultDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserSearchResultDtoToJson(this);
}
