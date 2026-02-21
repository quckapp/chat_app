/// Test configuration constants for E2E integration tests.
class TestConfig {
  // Test phone numbers — use 99999xxxxx prefix to avoid conflicts with real users
  static const String testPhoneNumber = '9999900001';
  static const String testCountryCode = '+91';
  static const String testFullPhone = '+919999900001';

  // Profile fields for new user registration
  static const String testFirstName = 'E2E';
  static const String testLastName = 'Tester';
  static const String testUsername = 'e2e_tester_001';

  // Backend URLs
  static const String kongBaseUrl = 'http://127.0.0.1:8080';
  static const String authBaseUrl = 'http://127.0.0.1:8080/api/auth';

  // Timeouts
  static const Duration settleTimeout = Duration(seconds: 10);
  static const Duration apiTimeout = Duration(seconds: 15);
  static const Duration longTimeout = Duration(seconds: 30);

  /// Generate a unique phone number for new-user tests to avoid resend cooldowns
  static String generateUniquePhone() {
    final suffix = DateTime.now().millisecondsSinceEpoch % 100000;
    return '99999${suffix.toString().padLeft(5, '0')}';
  }
}
