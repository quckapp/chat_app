import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Bottom navigation tests — 1 OTP, single testWidgets with shared session.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation', () {
    testWidgets('All navigation tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // ── Test 18 ─────────────────────────────────────────────────────
      debugPrint('── [1/8] Nav: bottom nav bar has 5 NavigationDestination widgets ──');
      TestNavigationHelper.verifyBottomNavVisible(tester);

      // ── Test 19 ─────────────────────────────────────────────────────
      debugPrint('── [2/8] Nav: Chats tab is active by default after login ──');
      expect(find.text('Chats'), findsWidgets);

      // ── Test 20 ─────────────────────────────────────────────────────
      debugPrint('── [3/8] Nav: tapping Channels tab shows Channels title ──');
      await TestNavigationHelper.goToChannels(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));
      expect(find.text('Channels'), findsWidgets);

      // ── Test 21 ─────────────────────────────────────────────────────
      debugPrint('── [4/8] Nav: tapping Search tab shows search screen with TextField ──');
      await TestNavigationHelper.goToSearch(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));
      expect(find.byType(TextField), findsWidgets);
      expect(find.textContaining('Search'), findsWidgets);

      // ── Test 22 ─────────────────────────────────────────────────────
      debugPrint('── [5/8] Nav: tapping Notifications tab shows Notifications title ──');
      await TestNavigationHelper.goToNotifications(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));
      expect(find.text('Notifications'), findsWidgets);

      // ── Test 23 ─────────────────────────────────────────────────────
      debugPrint('── [6/8] Nav: tapping More tab shows More title and menu sections ──');
      await TestNavigationHelper.goToMore(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));
      expect(find.text('More'), findsWidgets);
      expect(find.text('Workspace'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);

      // ── Test 24 ─────────────────────────────────────────────────────
      debugPrint('── [7/8] Nav: round-trip all tabs and return to Chats ──');
      await TestNavigationHelper.goToChats(tester);
      await TestNavigationHelper.goToChannels(tester);
      await TestNavigationHelper.goToSearch(tester);
      await TestNavigationHelper.goToNotifications(tester);
      await TestNavigationHelper.goToMore(tester);
      await TestNavigationHelper.goToChats(tester);
      expect(find.text('Chats'), findsWidgets);

      // ── Test 25 ─────────────────────────────────────────────────────
      debugPrint('── [8/8] Nav: rapid tab switching does not crash ──');
      for (int i = 0; i < 3; i++) {
        await TestNavigationHelper.goToChannels(tester);
        await TestNavigationHelper.goToSearch(tester);
        await TestNavigationHelper.goToChats(tester);
      }
      // If we got here without crash, the test passes
      expect(find.text('Chats'), findsWidgets);

      debugPrint('── All navigation tests passed! ──');
    });
  });
}
