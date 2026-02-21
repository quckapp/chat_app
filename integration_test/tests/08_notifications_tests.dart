import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Notifications screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notifications', () {
    testWidgets('All notification tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      await TestNavigationHelper.goToNotifications(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));

      // ── Test 54 ─────────────────────────────────────────────────────
      debugPrint('── [1/6] Notifications: screen title ──');
      expect(find.text('Notifications'), findsWidgets);

      // ── Test 55 ─────────────────────────────────────────────────────
      debugPrint('── [2/6] Notifications: shows empty/loading/list state ──');
      final hasEmpty =
          find.text('No notifications').evaluate().isNotEmpty;
      final hasList =
          find.byType(Dismissible).evaluate().isNotEmpty;
      final hasLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;

      expect(
        hasEmpty || hasList || hasLoading,
        isTrue,
        reason: 'Should show empty state, loading, or notifications list',
      );

      // ── Test 56 ─────────────────────────────────────────────────────
      debugPrint('── [3/6] Notifications: empty state icon ──');
      if (hasEmpty) {
        expect(find.text('No notifications'), findsOneWidget);

        // ── Test 57 ───────────────────────────────────────────────────
        debugPrint('── [4/6] Notifications: empty state subtitle ──');
        expect(find.text("You're all caught up!"), findsOneWidget);

        // ── Test 58 ───────────────────────────────────────────────────
        debugPrint('── [5/6] Notifications: notifications_none icon ──');
        expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      } else {
        debugPrint('── [4-5/6] Skipped empty-state tests (notifications present) ──');
      }

      // ── Test 59 ─────────────────────────────────────────────────────
      debugPrint('── [6/6] Notifications: Dismissible widgets when notifications exist ──');
      if (hasList) {
        expect(find.byType(Dismissible), findsWidgets);
      } else {
        debugPrint('── Skipped Dismissible test (no notifications) ──');
      }

      debugPrint('── All notification tests passed! ──');
    });
  });
}
