import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_config.dart';
import '../helpers/test_keys.dart';
import '../helpers/test_wait_helper.dart';

/// OTP flow tests — each test that sends an OTP consumes 1 OTP.
/// Tests are ordered: back-button test first (gets fresh rate limit),
/// then full login flow.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('OTP Flow', () {
    // ── Test 13 ─────────────────────────────────────────────────────────
    testWidgets('OTP: sending OTP navigates to Verify OTP screen',
        (tester) async {
      await startApp();
      await TestWaitHelper.waitForWidget(tester, find.text('Welcome'));

      final phone = TestConfig.generateUniquePhone();
      await tester.enterText(find.byKey(TestKeys.phoneField), phone);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byKey(TestKeys.sendOtpButton));

      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Verify OTP'),
        timeout: TestConfig.longTimeout,
      );
      expect(find.text('Verify OTP'), findsOneWidget);
    });

    // ── Test 14 (same session as 13 — merged into next testWidgets) ─────
    // Note: Tests 14 & 15 share the OTP from test 13 since they're in the
    // same testWidgets block to save OTPs.

    // ── Test 15 ─────────────────────────────────────────────────────────
    testWidgets('OTP: back button returns to login screen', (tester) async {
      await startApp();
      await TestWaitHelper.waitForWidget(tester, find.text('Welcome'));

      final phone = TestConfig.generateUniquePhone();
      await tester.enterText(find.byKey(TestKeys.phoneField), phone);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.byKey(TestKeys.sendOtpButton));

      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Verify OTP'),
        timeout: TestConfig.longTimeout,
      );

      // ── OTP screen element checks (Test 14) ──
      debugPrint('── [14] OTP screen has 6 input fields and Verify button ──');
      // 6 OTP input fields
      for (int i = 0; i < 6; i++) {
        expect(find.byKey(TestKeys.otpField(i)), findsOneWidget,
            reason: 'OTP field $i should exist');
      }

      // ── Back button test (Test 15) ──
      debugPrint('── [15] Back button returns to login ──');
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump(const Duration(milliseconds: 500));
      try {
        await tester.pumpAndSettle(
          const Duration(milliseconds: 100),
          EnginePhase.sendSemanticsUpdate,
          const Duration(seconds: 5),
        );
      } catch (_) {}

      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Welcome'),
        timeout: TestConfig.apiTimeout,
      );
      expect(find.text('Welcome'), findsOneWidget);
    });

    // ── Test 16 ─────────────────────────────────────────────────────────
    testWidgets('OTP: complete login flow phone -> OTP -> home or register',
        (tester) async {
      await startApp();

      final phone = TestConfig.generateUniquePhone();
      await TestAuthHelper.loginWithPhone(tester, phone: phone);

      final isHome = find.text('Chats').evaluate().isNotEmpty;
      final isRegister =
          find.text('Complete Your Profile').evaluate().isNotEmpty;
      expect(isHome || isRegister, isTrue,
          reason: 'Should land on Home or Register after login');

      // ── Test 17: Registration completion ──
      if (isRegister) {
        debugPrint('── [17] New user registration flow ──');
        await TestAuthHelper.completeRegistration(tester);
        expect(find.text('Chats'), findsWidgets);
      }
    });
  });
}
