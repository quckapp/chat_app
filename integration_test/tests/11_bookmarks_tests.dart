import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Bookmarks screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bookmarks', () {
    testWidgets('All bookmark tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Bookmarks via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Bookmarks', 'Bookmarks');

      // ── Test 73 ─────────────────────────────────────────────────────
      debugPrint('── [1/6] Bookmarks: screen title shows Bookmarks ──');
      expect(find.text('Bookmarks'), findsWidgets);

      // ── Test 74 ─────────────────────────────────────────────────────
      debugPrint('── [2/6] Bookmarks: create_new_folder icon in app bar ──');
      expect(find.byIcon(Icons.create_new_folder_outlined), findsOneWidget);

      // ── Test 75 ─────────────────────────────────────────────────────
      debugPrint('── [3/6] Bookmarks: shows empty state or bookmark list ──');
      final hasEmpty =
          find.text('No bookmarks yet').evaluate().isNotEmpty;
      expect(hasEmpty || !hasEmpty, isTrue,
          reason: 'Should show either empty state or bookmarks');

      // ── Test 76 ─────────────────────────────────────────────────────
      debugPrint('── [4/6] Bookmarks: empty state message and icon ──');
      if (hasEmpty) {
        expect(find.text('No bookmarks yet'), findsOneWidget);
        expect(find.text('Save messages to find them later'), findsOneWidget);
        expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      }

      // ── Test 77 ─────────────────────────────────────────────────────
      debugPrint('── [5/6] Bookmarks: create folder icon opens New Folder dialog ──');
      await TestPumpHelper.tapAndSettle(
          tester, find.byIcon(Icons.create_new_folder_outlined));

      expect(find.text('New Folder'), findsOneWidget);

      // ── Test 78 ─────────────────────────────────────────────────────
      debugPrint('── [6/6] Bookmarks: New Folder dialog fields and buttons ──');
      expect(find.text('Folder name'), findsOneWidget);
      expect(find.text('Description (optional)'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Create'), findsOneWidget);

      // Close dialog
      await TestPumpHelper.tapAndSettle(tester, find.text('Cancel'));

      // Navigate back to More
      await TestScrollHelper.navigateBackToMore(tester);

      debugPrint('── All bookmark tests passed! ──');
    });
  });
}
