import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_app_bootstrap.dart';
import 'helpers/test_auth_helper.dart';
import 'helpers/test_config.dart';
import 'helpers/test_keys.dart';
import 'helpers/test_navigation_helper.dart';
import 'helpers/test_pump_helper.dart';
import 'helpers/test_scroll_helper.dart';
import 'helpers/test_wait_helper.dart';

/// Smoke test — quick sanity check covering login → tabs → settings → logout.
///
/// Run with:
///   flutter test integration_test/app_test.dart -d [device-id]
///
/// For the full 123-test suite, run individual files:
///   flutter test integration_test/tests/01_auth_tests.dart -d [device-id]
///   flutter test integration_test/tests/02_otp_tests.dart -d [device-id]
///   ... etc through 19_logout_tests.dart
///
/// OTP budget: ~3 OTPs (1 for OTP flow test, 1 for complete login, 1 for post-login)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ── Quick Auth Check (0 OTP) ──────────────────────────────────────────────
  group('Smoke: Auth', () {
    testWidgets('Login screen renders correctly', (tester) async {
      await startApp();
      await TestWaitHelper.waitForWidget(tester, find.text('Welcome'));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Enter your phone number to continue'), findsOneWidget);
      expect(find.byKey(TestKeys.phoneField), findsOneWidget);
      expect(find.text('+91'), findsOneWidget);
      expect(find.byKey(TestKeys.sendOtpButton), findsOneWidget);
      expect(find.text('Send OTP'), findsOneWidget);
    });

    testWidgets('Phone validation rejects empty input', (tester) async {
      await startApp();
      await TestWaitHelper.waitForWidget(tester, find.text('Welcome'));

      await tester.tap(find.byKey(TestKeys.sendOtpButton));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Please enter your phone number'), findsOneWidget);
    });
  });

  // ── OTP Flow (2 OTPs) ────────────────────────────────────────────────────
  group('Smoke: OTP', () {
    testWidgets('OTP screen back button returns to login', (tester) async {
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

      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestPumpHelper.pumpAndTrySettle(tester);

      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Welcome'),
        timeout: TestConfig.apiTimeout,
      );
      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('Complete login flow: phone -> OTP -> home or register',
        (tester) async {
      await startApp();

      final phone = TestConfig.generateUniquePhone();
      await TestAuthHelper.loginWithPhone(tester, phone: phone);

      final isHome = find.text('Chats').evaluate().isNotEmpty;
      final isRegister =
          find.text('Complete Your Profile').evaluate().isNotEmpty;
      expect(isHome || isRegister, isTrue,
          reason: 'Should land on Home or Register after login');

      if (isRegister) {
        await TestAuthHelper.completeRegistration(tester);
        expect(find.text('Chats'), findsWidgets);
      }
    });
  });

  // ── Post-Login Smoke (1 OTP) ─────────────────────────────────────────────
  // Core path: login → navigate all 5 tabs → Settings → About → logout
  group('Smoke: Post-Login', () {
    testWidgets('Tabs, settings, about, and logout', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // ── 1. Verify Chats tab (default) ──
      debugPrint('── Smoke [1/7] Chats tab ──');
      expect(find.text('Chats'), findsWidgets);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // ── 2. Navigate all 5 tabs ──
      debugPrint('── Smoke [2/7] Tab navigation round-trip ──');
      await TestNavigationHelper.goToChannels(tester);
      expect(find.text('Channels'), findsWidgets);

      await TestNavigationHelper.goToSearch(tester);
      expect(find.byType(TextField), findsWidgets);

      await TestNavigationHelper.goToNotifications(tester);
      expect(find.text('Notifications'), findsWidgets);

      await TestNavigationHelper.goToMore(tester);
      expect(find.text('More'), findsWidgets);

      await TestNavigationHelper.goToChats(tester);
      expect(find.text('Chats'), findsWidgets);

      // ── 3. More menu sections ──
      debugPrint('── Smoke [3/7] More menu sections ──');
      await TestNavigationHelper.goToMore(tester);
      expect(find.text('Workspace'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Communication'), findsOneWidget);

      // ── 4. Settings screen ──
      debugPrint('── Smoke [4/7] Settings screen ──');
      await TestScrollHelper.navigateFromMoreTo(tester, 'Settings', 'Settings');
      expect(find.text('Account'), findsWidgets);
      expect(find.text('Preferences'), findsOneWidget);

      // ── 5. About dialog ──
      debugPrint('── Smoke [5/7] About dialog ──');
      await tester.scrollUntilVisible(
        find.text('About'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await TestPumpHelper.tapAndSettle(tester, find.text('About'));

      expect(find.text('QuickApp Chat'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);

      // Close About dialog
      final closeButton = find.text('CLOSE');
      if (closeButton.evaluate().isNotEmpty) {
        await TestPumpHelper.tapAndSettle(tester, closeButton);
      } else {
        final closeAlt = find.text('Close');
        if (closeAlt.evaluate().isNotEmpty) {
          await TestPumpHelper.tapAndSettle(tester, closeAlt);
        } else {
          await tester.tapAt(const Offset(10, 10));
          await TestPumpHelper.pumpAndTrySettle(tester);
        }
      }
      expect(find.text('Settings'), findsWidgets);

      // ── 6. Logout confirmation dialog ──
      debugPrint('── Smoke [6/7] Logout dialog ──');
      final logoutButton = find.byKey(TestKeys.logoutButton);
      await tester.scrollUntilVisible(logoutButton, 200);
      await TestPumpHelper.tapAndSettle(tester, logoutButton);

      final confirmButton = find.text('Sign Out').last;
      expect(confirmButton.evaluate().isNotEmpty, isTrue,
          reason: 'Sign Out confirmation dialog should appear');

      // ── 7. Confirm logout → Welcome ──
      debugPrint('── Smoke [7/7] Confirm logout ──');
      await tester.tap(confirmButton);

      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Welcome'),
        timeout: TestConfig.apiTimeout,
      );
      expect(find.text('Welcome'), findsOneWidget);

      debugPrint('── All smoke tests passed! ──');
    });
  });
}
