import 'package:json_annotation/json_annotation.dart';
import 'user_dto.dart';

part 'auth_dto.g.dart';

@JsonSerializable()
class LoginRequestDto {
  final String phoneNumber;
  final String? countryCode;

  const LoginRequestDto({
    required this.phoneNumber,
    this.countryCode,
  });

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}

@JsonSerializable()
class LoginResponseDto {
  final String requestId;
  final String message;
  final int? expiresIn;

  const LoginResponseDto({
    required this.requestId,
    required this.message,
    this.expiresIn,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}

@JsonSerializable()
class VerifyOtpRequestDto {
  final String requestId;
  final String otp;

  const VerifyOtpRequestDto({
    required this.requestId,
    required this.otp,
  });

  factory VerifyOtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VerifyOtpRequestDtoToJson(this);
}

@JsonSerializable()
class AuthResponseDto {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserDto user;

  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);
}

@JsonSerializable()
class RefreshTokenRequestDto {
  final String refreshToken;

  const RefreshTokenRequestDto({
    required this.refreshToken,
  });

  factory RefreshTokenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenRequestDtoToJson(this);
}

@JsonSerializable()
class RefreshTokenResponseDto {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const RefreshTokenResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory RefreshTokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenResponseDtoToJson(this);
}

@JsonSerializable()
class LogoutRequestDto {
  final String? refreshToken;
  final bool allDevices;

  const LogoutRequestDto({
    this.refreshToken,
    this.allDevices = false,
  });

  factory LogoutRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LogoutRequestDtoToJson(this);
}
