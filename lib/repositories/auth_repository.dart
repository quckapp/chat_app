import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../core/storage/secure_storage.dart';
import '../models/serializable/auth_dto.dart';
import '../models/serializable/user_dto.dart';

/// Repository for authentication operations
class AuthRepository {
  final RestClient _client;
  final SecureStorage _storage;

  AuthRepository({
    RestClient? client,
    SecureStorage? storage,
  })  : _client = client ?? RestClient(baseUrl: ApiConstants.authServiceBaseUrl),
        _storage = storage ?? SecureStorage.instance;

  /// Request OTP for phone number login
  Future<LoginResponseDto> requestOtp(String phoneNumber, {String? countryCode}) async {
    return _client.post(
      ApiConstants.login,
      data: LoginRequestDto(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      ).toJson(),
      fromJson: LoginResponseDto.fromJson,
    );
  }

  /// Verify OTP and get auth tokens
  Future<AuthResponseDto> verifyOtp(String requestId, String otp) async {
    final response = await _client.post(
      ApiConstants.verifyOtp,
      data: VerifyOtpRequestDto(
        requestId: requestId,
        otp: otp,
      ).toJson(),
      fromJson: AuthResponseDto.fromJson,
    );

    // Save tokens
    await _storage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    // Save user data
    await _storage.saveUserId(response.user.id);

    return response;
  }

  /// Resend OTP
  Future<LoginResponseDto> resendOtp(String requestId) async {
    return _client.post(
      ApiConstants.resendOtp,
      data: {'requestId': requestId},
      fromJson: LoginResponseDto.fromJson,
    );
  }

  /// Refresh access token
  Future<RefreshTokenResponseDto> refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _client.post(
      ApiConstants.refreshToken,
      data: RefreshTokenRequestDto(refreshToken: refreshToken).toJson(),
      fromJson: RefreshTokenResponseDto.fromJson,
    );

    await _storage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return response;
  }

  /// Logout user
  Future<void> logout({bool allDevices = false}) async {
    final refreshToken = await _storage.getRefreshToken();

    try {
      await _client.postVoid(
        ApiConstants.logout,
        data: LogoutRequestDto(
          refreshToken: refreshToken,
          allDevices: allDevices,
        ).toJson(),
      );
    } finally {
      await _storage.clearAll();
    }
  }

  /// Get current user profile
  Future<UserDto> getCurrentUser() async {
    return _client.get(
      ApiConstants.userProfile,
      fromJson: UserDto.fromJson,
    );
  }

  /// Update user profile
  Future<UserDto> updateProfile(UserProfileUpdateDto profile) async {
    return _client.put(
      ApiConstants.userProfile,
      data: profile.toJson(),
      fromJson: UserDto.fromJson,
    );
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.getAccessToken();
    return token != null;
  }

  /// Get stored access token
  Future<String?> getAccessToken() => _storage.getAccessToken();

  /// Get stored user ID
  Future<String?> getUserId() => _storage.getUserId();
}
