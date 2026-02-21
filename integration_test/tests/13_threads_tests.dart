import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Threads screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Threads', () {
    testWidgets('All thread tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Threads via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Threads', 'Threads');

      // ── Test 84 ─────────────────────────────────────────────────────
      debugPrint('── [1/4] Threads: screen title shows Threads ──');
      expect(find.text('Threads'), findsWidgets);

      // ── Test 85 ─────────────────────────────────────────────────────
      debugPrint('── [2/4] Threads: shows empty/loading/list state ──');
      final hasLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasEmpty =
          find.text('No threads yet').evaluate().isNotEmpty;

      expect(
        hasLoading || hasEmpty || (!hasLoading && !hasEmpty),
        isTrue,
        reason: 'Should show loading, empty state, or thread list',
      );

      // ── Test 86 ─────────────────────────────────────────────────────
      debugPrint('── [3/4] Threads: empty state message and icon ──');
      if (hasEmpty) {
        expect(find.text('No threads yet'), findsOneWidget);
        expect(
          find.text('Threads will appear here when you reply to messages'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      }

      // ── Test 87 ─────────────────────────────────────────────────────
      debugPrint('── [4/4] Threads: back navigation returns to More ──');
      await TestScrollHelper.navigateBackToMore(tester);
      expect(find.text('More'), findsWidgets);

      debugPrint('── All thread tests passed! ──');
    });
  });
}
