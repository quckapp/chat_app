// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      username: json['username'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      displayName: json['displayName'] as String?,
      avatar: json['avatar'] as String?,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      isNewUser: json['newUser'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
      'phoneVerified': instance.phoneVerified,
      'newUser': instance.isNewUser,
      'createdAt': instance.createdAt?.toIso8601String(),
      'status': instance.status,
    };

UserProfileUpdateDto _$UserProfileUpdateDtoFromJson(
        Map<String, dynamic> json) =>
    UserProfileUpdateDto(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      displayName: json['displayName'] as String?,
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$UserProfileUpdateDtoToJson(
        UserProfileUpdateDto instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
      'email': instance.email,
    };

UserSearchResultDto _$UserSearchResultDtoFromJson(Map<String, dynamic> json) =>
    UserSearchResultDto(
      users: (json['users'] as List<dynamic>)
          .map((e) => UserDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$UserSearchResultDtoToJson(
        UserSearchResultDto instance) =>
    <String, dynamic>{
      'users': instance.users,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
