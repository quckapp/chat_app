import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_wait_helper.dart';

/// More menu structure tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('More Menu', () {
    testWidgets('All more menu tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      await TestNavigationHelper.goToMore(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));

      // ── Test 60 ─────────────────────────────────────────────────────
      debugPrint('── [1/6] More: screen title shows More ──');
      expect(find.text('More'), findsWidgets);

      // ── Test 61 ─────────────────────────────────────────────────────
      debugPrint('── [2/6] More: Workspace section has Workspaces and Threads ──');
      expect(find.text('Workspace'), findsOneWidget);
      expect(find.text('Workspaces'), findsOneWidget);
      expect(find.text('Threads'), findsOneWidget);

      // ── Test 62 ─────────────────────────────────────────────────────
      debugPrint('── [3/6] More: Content section has Files, Bookmarks, Reminders ──');
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Files'), findsOneWidget);
      expect(find.text('Bookmarks'), findsOneWidget);
      expect(find.text('Reminders'), findsOneWidget);

      // ── Test 63 ─────────────────────────────────────────────────────
      debugPrint('── [4/6] More: Communication section has Call History ──');
      expect(find.text('Communication'), findsOneWidget);
      expect(find.text('Call History'), findsOneWidget);

      // ── Test 64 ─────────────────────────────────────────────────────
      debugPrint('── [5/6] More: Account section ──');
      // Scroll down to Account section
      await tester.scrollUntilVisible(
        find.text('Account'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Devices'), findsOneWidget);
      expect(find.text('Two-Factor Auth'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);

      // ── Test 65 ─────────────────────────────────────────────────────
      debugPrint('── [6/6] More: Administration section ──');
      await tester.scrollUntilVisible(
        find.text('Administration'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Administration'), findsOneWidget);
      expect(find.text('Admin Dashboard'), findsOneWidget);
      expect(find.text('User Management'), findsOneWidget);
      expect(find.text('Audit Log'), findsOneWidget);
      expect(find.text('Admin Settings'), findsOneWidget);

      debugPrint('── All more menu tests passed! ──');
    });
  });
}
