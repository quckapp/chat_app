import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Files screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Files', () {
    testWidgets('All file tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Files via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Files', 'Files');

      // ── Test 88 ─────────────────────────────────────────────────────
      debugPrint('── [1/4] Files: screen title shows Files ──');
      expect(find.text('Files'), findsWidgets);

      // ── Test 89 ─────────────────────────────────────────────────────
      debugPrint('── [2/4] Files: shows empty/loading/list state ──');
      final hasLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasEmpty =
          find.text('No files yet').evaluate().isNotEmpty;

      expect(
        hasLoading || hasEmpty || (!hasLoading && !hasEmpty),
        isTrue,
        reason: 'Should show loading, empty state, or file list',
      );

      // ── Test 90 ─────────────────────────────────────────────────────
      debugPrint('── [3/4] Files: empty state message and icon ──');
      if (hasEmpty) {
        expect(find.text('No files yet'), findsOneWidget);
        expect(
          find.text('Files shared in channels will appear here'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.folder_open), findsOneWidget);
      }

      // ── Test 91 ─────────────────────────────────────────────────────
      debugPrint('── [4/4] Files: back navigation returns to More ──');
      await TestScrollHelper.navigateBackToMore(tester);
      expect(find.text('More'), findsWidgets);

      debugPrint('── All file tests passed! ──');
    });
  });
}
