import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_wait_helper.dart';

/// New Chat screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('New Chat', () {
    testWidgets('All new chat tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Chats then open New Chat via FAB
      await TestNavigationHelper.goToChats(tester);
      await tester.tap(find.byType(FloatingActionButton));
      await TestPumpHelper.pumpAndTrySettle(tester);
      await TestWaitHelper.waitForWidget(
        tester,
        find.text('New Chat'),
        timeout: const Duration(seconds: 10),
      );

      // ── Test 34 ─────────────────────────────────────────────────────
      debugPrint('── [1/5] NewChat: screen renders with New Chat title ──');
      expect(find.text('New Chat'), findsOneWidget);

      // ── Test 35 ─────────────────────────────────────────────────────
      debugPrint('── [2/5] NewChat: search field with hint text ──');
      expect(find.byType(TextField), findsWidgets);

      // ── Test 36 ─────────────────────────────────────────────────────
      debugPrint('── [3/5] NewChat: initial empty state with Search for users message ──');
      expect(find.text('Search for users'), findsOneWidget);
      expect(find.text('Find people by name or username'), findsOneWidget);

      // ── Test 37 ─────────────────────────────────────────────────────
      debugPrint('── [4/5] NewChat: person_search icon in empty state ──');
      expect(find.byIcon(Icons.person_search), findsOneWidget);

      // ── Test 38 ─────────────────────────────────────────────────────
      debugPrint('── [5/5] NewChat: close icon returns to conversations ──');
      await tester.tap(find.byIcon(Icons.close));
      await TestPumpHelper.pumpAndTrySettle(tester);
      await TestWaitHelper.waitForWidget(tester, find.text('Chats'));
      expect(find.text('Chats'), findsWidgets);

      debugPrint('── All new chat tests passed! ──');
    });
  });
}
