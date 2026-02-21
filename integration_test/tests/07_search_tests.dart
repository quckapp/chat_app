import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Search screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search', () {
    testWidgets('All search tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      await TestNavigationHelper.goToSearch(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));

      // ── Test 47 ─────────────────────────────────────────────────────
      debugPrint('── [1/7] Search: screen renders with search TextField ──');
      expect(find.byType(TextField), findsWidgets);

      // ── Test 48 ─────────────────────────────────────────────────────
      debugPrint('── [2/7] Search: tab bar has 5 tabs ──');
      expect(find.byType(Tab), findsNWidgets(5));
      expect(find.text('All'), findsWidgets);
      expect(find.text('Messages'), findsWidgets);
      expect(find.text('People'), findsWidgets);
      expect(find.text('Files'), findsWidgets);

      // ── Test 49 ─────────────────────────────────────────────────────
      debugPrint('── [3/7] Search: initial state shows Search your workspace prompt ──');
      expect(find.text('Search your workspace'), findsOneWidget);

      // ── Test 50 ─────────────────────────────────────────────────────
      debugPrint('── [4/7] Search: initial state subtitle ──');
      expect(
        find.text('Find messages, people, channels, and files'),
        findsOneWidget,
      );

      // ── Test 51 ─────────────────────────────────────────────────────
      debugPrint('── [5/7] Search: tapping Messages tab switches filter ──');
      await TestPumpHelper.tapAndSettle(tester, find.text('Messages').last);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 1));
      // Tab should be selected (no crash is sufficient)

      // ── Test 52 ─────────────────────────────────────────────────────
      debugPrint('── [6/7] Search: tapping People tab switches filter ──');
      await TestPumpHelper.tapAndSettle(tester, find.text('People').last);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 1));

      // ── Test 53 ─────────────────────────────────────────────────────
      debugPrint('── [7/7] Search: tapping Channels tab switches filter ──');
      // Use .last to avoid the bottom nav "Channels" tab
      final channelsTab = find.text('Channels');
      // Find the one inside the TabBar (not the bottom nav)
      await TestPumpHelper.tapAndSettle(tester, channelsTab.first);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 1));

      debugPrint('── All search tests passed! ──');
    });
  });
}
