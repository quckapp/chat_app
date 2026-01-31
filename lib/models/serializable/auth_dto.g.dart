// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestDto _$LoginRequestDtoFromJson(Map<String, dynamic> json) =>
    LoginRequestDto(
      phoneNumber: json['phoneNumber'] as String,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$LoginRequestDtoToJson(LoginRequestDto instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'countryCode': instance.countryCode,
    };

LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) =>
    LoginResponseDto(
      requestId: json['requestId'] as String,
      message: json['message'] as String,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseDtoToJson(LoginResponseDto instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'message': instance.message,
      'expiresIn': instance.expiresIn,
    };

VerifyOtpRequestDto _$VerifyOtpRequestDtoFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequestDto(
      requestId: json['requestId'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyOtpRequestDtoToJson(
        VerifyOtpRequestDto instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'otp': instance.otp,
    };

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    AuthResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num).toInt(),
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseDtoToJson(AuthResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'user': instance.user,
    };

RefreshTokenRequestDto _$RefreshTokenRequestDtoFromJson(
        Map<String, dynamic> json) =>
    RefreshTokenRequestDto(
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RefreshTokenRequestDtoToJson(
        RefreshTokenRequestDto instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

RefreshTokenResponseDto _$RefreshTokenResponseDtoFromJson(
        Map<String, dynamic> json) =>
    RefreshTokenResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
    );

Map<String, dynamic> _$RefreshTokenResponseDtoToJson(
        RefreshTokenResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

LogoutRequestDto _$LogoutRequestDtoFromJson(Map<String, dynamic> json) =>
    LogoutRequestDto(
      refreshToken: json['refreshToken'] as String?,
      allDevices: json['allDevices'] as bool? ?? false,
    );

Map<String, dynamic> _$LogoutRequestDtoToJson(LogoutRequestDto instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'allDevices': instance.allDevices,
    };
