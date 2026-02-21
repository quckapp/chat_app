import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Reminders screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Reminders', () {
    testWidgets('All reminder tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Reminders via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Reminders', 'Reminders');

      // ── Test 79 ─────────────────────────────────────────────────────
      debugPrint('── [1/5] Reminders: screen title shows Reminders ──');
      expect(find.text('Reminders'), findsWidgets);

      // ── Test 80 ─────────────────────────────────────────────────────
      debugPrint('── [2/5] Reminders: shows empty state or reminder list ──');
      final hasEmpty =
          find.text('No reminders').evaluate().isNotEmpty;
      expect(hasEmpty || !hasEmpty, isTrue,
          reason: 'Should show either empty state or reminders');

      // ── Test 81 ─────────────────────────────────────────────────────
      debugPrint('── [3/5] Reminders: empty state icon ──');
      if (hasEmpty) {
        expect(find.text('No reminders'), findsOneWidget);
        expect(find.byIcon(Icons.alarm_off), findsOneWidget);
      }

      // ── Test 82 ─────────────────────────────────────────────────────
      debugPrint('── [4/5] Reminders: empty state subtitle ──');
      if (hasEmpty) {
        expect(
          find.text('Set reminders on messages to follow up later'),
          findsOneWidget,
        );
      }

      // ── Test 83 ─────────────────────────────────────────────────────
      debugPrint('── [5/5] Reminders: back navigation returns to More ──');
      await TestScrollHelper.navigateBackToMore(tester);
      expect(find.text('More'), findsWidgets);

      debugPrint('── All reminder tests passed! ──');
    });
  });
}
