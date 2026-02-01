import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  ApiConstants._();

  // Your computer's local network IP (for physical devices)
  // Find it with: ipconfig (Windows) or ifconfig (Mac/Linux)
  // Use 192.168.29.198 if phone is on same Wi-Fi network
  // Use 192.168.32.1 if phone is connected via mobile hotspot
  static const String localNetworkIp = '192.168.29.198';

  // Set to true if running on physical device
  static const bool usePhysicalDevice = true;

  // Get the appropriate host based on platform
  static String get host {
    if (kIsWeb) {
      return 'localhost';
    }

    try {
      if (Platform.isAndroid) {
        // Android emulator uses 10.0.2.2 to reach host machine
        return usePhysicalDevice ? localNetworkIp : '10.0.2.2';
      } else if (Platform.isIOS) {
        // iOS simulator can use localhost
        return usePhysicalDevice ? localNetworkIp : 'localhost';
      }
    } catch (_) {
      // Platform not available (web fallback)
    }

    return 'localhost';
  }

  // Base URLs (dynamic based on platform)
  static String get authServiceBaseUrl => 'http://$host:8081/api/auth';
  // Physical devices use proxy port (18082) since Spring runs on localhost
  static String get userServiceBaseUrl => 'http://$host:${usePhysicalDevice ? 18082 : 8082}';
  static String get permissionServiceBaseUrl => 'http://$host:8083';
  static String get gatewayBaseUrl => 'http://$host:3003/api/v1';

  // Elixir Services
  // Physical devices use proxy ports (14003) since Docker WSL2 ports aren't directly accessible
  static String get realtimeServiceWsUrl => 'ws://$host:${usePhysicalDevice ? 14003 : 4003}/socket/websocket';
  static String get messageServiceBaseUrl => 'http://$host:4006';

  // Auth endpoints - Phone OTP
  static const String login = '/v1/auth/phone/request-otp';
  static const String requestOtp = '/v1/auth/phone/request-otp';
  static const String verifyOtp = '/v1/auth/phone/login';
  static const String loginWithOtp = '/v1/auth/phone/login';
  static const String resendOtp = '/v1/auth/phone/resend-otp';

  // Auth endpoints - Email OTP (for email verification)
  static const String requestEmailOtp = '/v1/auth/email/request-otp';
  static const String verifyEmailOtp = '/v1/auth/email/verify-otp';
  static const String requestEmailOtpAuthenticated = '/v1/auth/email/request-otp/authenticated';
  static const String verifyEmailOtpAuthenticated = '/v1/auth/email/verify-otp/authenticated';

  // Auth endpoints - General
  static const String logout = '/v1/logout';
  static const String refreshToken = '/v1/token/refresh';
  static const String sessions = '/v1/sessions';
  static const String me = '/v1/users/me';

  // User endpoints
  static const String users = '/api/users/v1';
  static const String userProfile = '/api/users/v1/profile';
  static const String searchUsers = '/api/users/v1/search';

  // Permission endpoints
  static const String permissions = '/api/permissions/v1';
  static const String roles = '/api/permissions/v1/roles';
  static const String userPermissions = '/api/permissions/v1/users';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
