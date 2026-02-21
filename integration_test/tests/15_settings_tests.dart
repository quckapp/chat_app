import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Settings screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings', () {
    testWidgets('All settings tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Settings via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Settings', 'Settings');

      // ── Test 92 ─────────────────────────────────────────────────────
      debugPrint('── [1/9] Settings: screen renders with Account and Preferences ──');
      expect(find.text('Account'), findsWidgets);
      expect(find.text('Preferences'), findsOneWidget);

      // ── Test 93 ─────────────────────────────────────────────────────
      debugPrint('── [2/9] Settings: Account tiles ──');
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Two-Factor Authentication'), findsOneWidget);
      expect(find.text('Active Sessions'), findsOneWidget);

      // ── Test 94 ─────────────────────────────────────────────────────
      debugPrint('── [3/9] Settings: Preferences tiles ──');
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Off'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);

      // ── Test 95 ─────────────────────────────────────────────────────
      debugPrint('── [4/9] Settings: Privacy tiles ──');
      // Scroll down to see Privacy section
      await tester.scrollUntilVisible(
        find.text('Privacy'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Online Status'), findsOneWidget);
      expect(find.text('Visible to everyone'), findsOneWidget);
      expect(find.text('Blocked Users'), findsOneWidget);

      // ── Test 96 ─────────────────────────────────────────────────────
      debugPrint('── [5/9] Settings: Support tiles ──');
      await tester.scrollUntilVisible(
        find.text('Support'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Support'), findsOneWidget);
      expect(find.text('Help Center'), findsOneWidget);
      expect(find.text('Send Feedback'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);

      // ── Test 97 ─────────────────────────────────────────────────────
      debugPrint('── [6/9] Settings: Sign Out button visible ──');
      await tester.scrollUntilVisible(
        find.text('Sign Out'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Sign Out'), findsOneWidget);

      // ── Test 98 ─────────────────────────────────────────────────────
      debugPrint('── [7/9] Settings: About dialog content ──');
      await TestPumpHelper.tapAndSettle(tester, find.text('About'));

      expect(find.text('QuickApp Chat'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(
        find.text('A modern chat application built with Flutter and BLoC.'),
        findsOneWidget,
      );

      // ── Test 99 ─────────────────────────────────────────────────────
      debugPrint('── [8/9] Settings: About dialog icon ──');
      expect(find.byIcon(Icons.chat_bubble_rounded), findsOneWidget);

      // ── Test 100 ────────────────────────────────────────────────────
      debugPrint('── [9/9] Settings: About dialog CLOSE button ──');
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

      debugPrint('── All settings tests passed! ──');
    });
  });
}
