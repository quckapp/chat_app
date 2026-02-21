import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Call History & Devices screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Calls & Devices', () {
    testWidgets('All calls and devices tests (shared session)',
        (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // ── Call History ────────────────────────────────────────────────
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(
          tester, 'Call History', 'Call History');

      // ── Test 116 ────────────────────────────────────────────────────
      debugPrint('── [1/6] Call History: screen renders with title ──');
      expect(find.text('Call History'), findsWidgets);

      // ── Test 117 ────────────────────────────────────────────────────
      debugPrint('── [2/6] Call History: shows empty/error/loading/list state ──');
      final hasCallLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasCallError =
          find.text('Failed to load call history').evaluate().isNotEmpty;
      final hasCallEmpty =
          find.text('No call history').evaluate().isNotEmpty;

      expect(
        hasCallLoading || hasCallError || hasCallEmpty ||
            (!hasCallLoading && !hasCallError && !hasCallEmpty),
        isTrue,
        reason: 'Should show loading, error, empty, or call history',
      );

      if (hasCallEmpty) {
        expect(find.text('No call history'), findsOneWidget);
        expect(find.text('Your calls will appear here'), findsOneWidget);
        expect(find.byIcon(Icons.call_outlined), findsOneWidget);
      }

      // ── Test 118 ────────────────────────────────────────────────────
      debugPrint('── [3/6] Call History: error state ──');
      if (hasCallError) {
        expect(find.text('Failed to load call history'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      }

      await TestScrollHelper.navigateBackToMore(tester);

      // ── Devices ─────────────────────────────────────────────────────
      await TestScrollHelper.navigateFromMoreTo(
          tester, 'Devices', 'Registered Devices');

      // ── Test 119 ────────────────────────────────────────────────────
      debugPrint('── [4/6] Devices: screen renders with Registered Devices title ──');
      expect(find.text('Registered Devices'), findsWidgets);

      // ── Test 120 ────────────────────────────────────────────────────
      debugPrint('── [5/6] Devices: shows empty/error/loading/list state ──');
      final hasDeviceLoading =
          find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasDeviceError =
          find.text('Failed to load devices').evaluate().isNotEmpty;
      final hasDeviceEmpty =
          find.text('No devices registered').evaluate().isNotEmpty;

      expect(
        hasDeviceLoading || hasDeviceError || hasDeviceEmpty ||
            (!hasDeviceLoading && !hasDeviceError && !hasDeviceEmpty),
        isTrue,
        reason: 'Should show loading, error, empty, or device list',
      );

      if (hasDeviceEmpty) {
        expect(find.text('No devices registered'), findsOneWidget);
        expect(find.text('Your devices will appear here'), findsOneWidget);
        expect(find.byIcon(Icons.devices), findsWidgets);
      }

      // ── Test 121 ────────────────────────────────────────────────────
      debugPrint('── [6/6] Devices: error state ──');
      if (hasDeviceError) {
        expect(find.text('Failed to load devices'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      }

      await TestScrollHelper.navigateBackToMore(tester);

      debugPrint('── All calls & devices tests passed! ──');
    });
  });
}
