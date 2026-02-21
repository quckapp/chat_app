import 'package:flutter_test/flutter_test.dart';

import 'test_config.dart';
import 'test_keys.dart';
import 'test_otp_helper.dart';
import 'test_wait_helper.dart';

/// Helper for performing login/logout flows in integration tests.
class TestAuthHelper {
  /// Perform complete login: enter phone → send OTP → enter OTP → land on home or register.
  static Future<void> loginWithPhone(
    WidgetTester tester, {
    String phone = TestConfig.testPhoneNumber,
  }) async {
    // 1. Wait for login screen
    await TestWaitHelper.waitForWidget(tester, find.text('Welcome'));

    // 2. Enter phone number into the phone field
    final phoneField = find.byKey(TestKeys.phoneField);
    expect(phoneField, findsOneWidget, reason: 'Phone field should exist');
    await tester.enterText(phoneField, phone);
    await tester.pump(const Duration(milliseconds: 200));

    // 3. Tap "Send OTP"
    final sendOtpButton = find.byKey(TestKeys.sendOtpButton);
    expect(sendOtpButton, findsOneWidget, reason: 'Send OTP button should exist');
    await tester.tap(sendOtpButton);

    // 4. Wait for OTP screen
    await TestWaitHelper.waitForWidget(
      tester,
      find.text('Verify OTP'),
      timeout: TestConfig.apiTimeout,
    );

    // 5. Get the OTP from AuthBloc state
    final otp = TestOtpHelper.getTestOtpFromBloc(tester);

    // 6. Enter OTP digits one by one
    for (int i = 0; i < 6; i++) {
      final otpField = find.byKey(TestKeys.otpField(i));
      expect(otpField, findsOneWidget, reason: 'OTP field $i should exist');
      await tester.enterText(otpField, otp[i]);
      await tester.pump(const Duration(milliseconds: 100));
    }

    // 7. The OTP auto-submits on 6th digit. Wait for navigation.
    await TestWaitHelper.waitForAny(
      tester,
      [
        find.text('Complete Your Profile'), // Register screen (new user)
        find.text('Chats'), // Home screen (existing user)
      ],
      timeout: TestConfig.longTimeout,
    );
  }

  /// Complete profile registration for new users.
  static Future<void> completeRegistration(
    WidgetTester tester, {
    String firstName = TestConfig.testFirstName,
    String lastName = TestConfig.testLastName,
    String? username,
  }) async {
    await TestWaitHelper.waitForWidget(
      tester,
      find.text('Complete Your Profile'),
    );

    // Use unique username to avoid conflicts
    final uniqueUsername = username ??
        'e2e_${DateTime.now().millisecondsSinceEpoch % 100000}';

    // Fill in the 3 fields
    await tester.enterText(find.byKey(TestKeys.firstNameField), firstName);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byKey(TestKeys.lastNameField), lastName);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byKey(TestKeys.usernameField), uniqueUsername);
    await tester.pump(const Duration(milliseconds: 100));

    // Tap Continue
    await tester.tap(find.byKey(TestKeys.continueButton));

    // Wait for home screen
    await TestWaitHelper.waitForWidget(
      tester,
      find.text('Chats'),
      timeout: TestConfig.longTimeout,
    );
  }

  /// Full login + registration for new users.
  static Future<void> fullLogin(
    WidgetTester tester, {
    String? phone,
  }) async {
    final testPhone = phone ?? TestConfig.generateUniquePhone();
    await loginWithPhone(tester, phone: testPhone);

    // Check if we landed on registration or home
    if (find.text('Complete Your Profile').evaluate().isNotEmpty) {
      await completeRegistration(tester);
    }
  }

  /// Perform logout via More → Settings → Sign Out.
  static Future<void> logout(WidgetTester tester) async {
    // Navigate to More tab
    final moreTab = find.text('More');
    await tester.tap(moreTab.last);
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 3),
      );
    } catch (_) {}

    // Tap Settings
    await tester.tap(find.text('Settings'));
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 3),
      );
    } catch (_) {}

    // Scroll to and tap Sign Out button
    final logoutButton = find.byKey(TestKeys.logoutButton);
    await tester.scrollUntilVisible(logoutButton, 200);
    await tester.tap(logoutButton);
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 3),
      );
    } catch (_) {}

    // Confirm the Sign Out dialog
    final confirmButton = find.text('Sign Out').last;
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
    }

    // Wait for login screen
    await TestWaitHelper.waitForWidget(
      tester,
      find.text('Welcome'),
      timeout: TestConfig.apiTimeout,
    );
  }
}
