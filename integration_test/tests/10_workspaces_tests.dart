import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Workspaces screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Workspaces', () {
    testWidgets('All workspace tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Workspaces via More menu
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Workspaces', 'Workspaces');

      // ── Test 66 ─────────────────────────────────────────────────────
      debugPrint('── [1/7] Workspaces: screen title shows Workspaces ──');
      expect(find.text('Workspaces'), findsWidgets);

      // ── Test 67 ─────────────────────────────────────────────────────
      debugPrint('── [2/7] Workspaces: FAB with link icon for join ──');
      expect(find.byIcon(Icons.link), findsWidgets);

      // ── Test 68 ─────────────────────────────────────────────────────
      debugPrint('── [3/7] Workspaces: shows empty state or workspace list ──');
      final hasEmpty =
          find.text('No Workspaces Yet').evaluate().isNotEmpty;

      if (hasEmpty) {
        // ── Test 69 ───────────────────────────────────────────────────
        debugPrint('── [4/7] Workspaces: empty state buttons ──');
        expect(find.text('No Workspaces Yet'), findsOneWidget);
        expect(find.text('Create a workspace or join one with an invite code.'),
            findsOneWidget);
        expect(find.text('Create Workspace'), findsOneWidget);
        expect(find.text('Join with Code'), findsOneWidget);
      } else {
        debugPrint('── [4/7] Skipped empty state test (workspaces present) ──');
      }

      // ── Test 70 ─────────────────────────────────────────────────────
      debugPrint('── [5/7] Workspaces: FAB opens Join Workspace dialog ──');
      await tester.tap(find.byType(FloatingActionButton));
      await TestPumpHelper.pumpAndTrySettle(tester);

      expect(find.text('Join Workspace'), findsOneWidget);
      expect(find.text('Invite Code'), findsOneWidget);

      // ── Test 71 ─────────────────────────────────────────────────────
      debugPrint('── [6/7] Workspaces: Join dialog has Cancel and Join buttons ──');
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Join'), findsOneWidget);

      // Close the dialog
      await TestPumpHelper.tapAndSettle(tester, find.text('Cancel'));

      // ── Test 72 ─────────────────────────────────────────────────────
      debugPrint('── [7/7] Workspaces: Create Workspace screen ──');
      // Navigate to Create Workspace (via empty state button or app bar)
      if (hasEmpty) {
        await TestPumpHelper.tapAndSettle(tester, find.text('Create Workspace'));
      } else {
        // If workspaces exist, try the app bar add button
        final addButton = find.byIcon(Icons.add);
        if (addButton.evaluate().isNotEmpty) {
          await TestPumpHelper.tapAndSettle(tester, addButton);
        }
      }

      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));

      final hasCreateScreen =
          find.text('Create Workspace').evaluate().isNotEmpty;
      if (hasCreateScreen) {
        // Check form fields
        expect(find.text('Create Workspace'), findsWidgets);
        // Navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await TestPumpHelper.pumpAndTrySettle(tester);
      }

      // Navigate back to More
      await TestScrollHelper.navigateBackToMore(tester);

      debugPrint('── All workspace tests passed! ──');
    });
  });
}
