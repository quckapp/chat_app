import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_config.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Security (2FA + Sessions) tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Security', () {
    testWidgets('All security tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // ── 2FA Tests ───────────────────────────────────────────────────
      // Navigate to 2FA via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(
          tester, 'Two-Factor Auth', 'Two-Factor Authentication');

      // ── Test 101 ────────────────────────────────────────────────────
      debugPrint('── [1/6] 2FA: screen title shows Two-Factor Authentication ──');
      expect(find.text('Two-Factor Authentication'), findsWidgets);

      // ── Test 102 ────────────────────────────────────────────────────
      debugPrint('── [2/6] 2FA: status shows Disabled with Switch widget ──');
      expect(find.text('Disabled'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);

      // ── Test 103 ────────────────────────────────────────────────────
      debugPrint('── [3/6] 2FA: three methods: Authenticator App, SMS, Email ──');
      expect(find.text('Method'), findsOneWidget);
      expect(find.byType(RadioListTile<String>), findsNWidgets(3));
      expect(find.text('Authenticator App'), findsOneWidget);
      expect(find.text('SMS'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);

      // ── Test 104 ────────────────────────────────────────────────────
      debugPrint('── [4/6] 2FA: toggling Switch shows Verify Setup form ──');
      await tester.tap(find.byType(Switch));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Verify Setup'), findsOneWidget);
      expect(
        find.text('Enter the verification code to enable 2FA'),
        findsOneWidget,
      );
      expect(find.text('Verify and Enable'), findsOneWidget);

      // Navigate back to More
      await TestScrollHelper.navigateBackToMore(tester);

      // ── Sessions Tests ──────────────────────────────────────────────
      await TestScrollHelper.navigateFromMoreTo(
          tester, 'Sessions', 'Active Sessions');

      // ── Test 105 ────────────────────────────────────────────────────
      debugPrint('── [5/6] Sessions: screen title shows Active Sessions ──');
      expect(find.text('Active Sessions'), findsOneWidget);

      // ── Test 106 ────────────────────────────────────────────────────
      debugPrint('── [6/6] Sessions: current device card ──');
      expect(find.text('Current Device'), findsOneWidget);
      expect(find.text('Current'), findsOneWidget);
      expect(find.text('IP: 127.0.0.1'), findsOneWidget);
      expect(find.textContaining('Last active:'), findsOneWidget);

      // No "Revoke All" button (only 1 session)
      expect(find.text('Revoke All'), findsNothing);

      // Navigate back to More
      await TestScrollHelper.navigateBackToMore(tester);

      debugPrint('── All security tests passed! ──');
    });
  });
}
