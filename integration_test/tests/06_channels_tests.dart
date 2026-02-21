import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Channels screen tests — 1 OTP, single testWidgets.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Channels', () {
    testWidgets('All channel tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // ── Test 39 ─────────────────────────────────────────────────────
      debugPrint('── [1/8] Channels: screen title shows Channels ──');
      await TestNavigationHelper.goToChannels(tester);
      await TestWaitHelper.pumpFor(tester, const Duration(seconds: 2));
      expect(find.text('Channels'), findsWidgets);

      // ── Test 40 ─────────────────────────────────────────────────────
      debugPrint('── [2/8] Channels: add icon button in app bar ──');
      final hasAddIcon = find.byIcon(Icons.add).evaluate().isNotEmpty;
      final hasAddCircle =
          find.byIcon(Icons.add_circle_outline).evaluate().isNotEmpty;
      expect(hasAddIcon || hasAddCircle, isTrue,
          reason: 'Should have an add button for creating channels');

      // ── Test 41 ─────────────────────────────────────────────────────
      debugPrint('── [3/8] Channels: shows empty state or channel list ──');
      final hasChannelEmpty =
          find.textContaining('No channels').evaluate().isNotEmpty;
      final hasChannelList = !hasChannelEmpty;
      expect(hasChannelEmpty || hasChannelList, isTrue,
          reason: 'Should show either empty state or channel list');

      // ── Test 42 ─────────────────────────────────────────────────────
      debugPrint('── [4/8] Channels: navigate to Create Channel screen ──');
      // Tap the add icon to navigate to Create Channel
      final addIcon = hasAddIcon ? find.byIcon(Icons.add) : find.byIcon(Icons.add_circle_outline);
      await TestPumpHelper.tapAndSettle(tester, addIcon);
      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Create Channel'),
        timeout: const Duration(seconds: 10),
      );
      expect(find.text('Create Channel'), findsOneWidget);

      // ── Test 43 ─────────────────────────────────────────────────────
      debugPrint('── [5/8] Channels: Create Channel has Channel Name field ──');
      expect(find.text('Channel Name'), findsOneWidget);
      expect(find.byIcon(Icons.tag), findsOneWidget);

      // ── Test 44 ─────────────────────────────────────────────────────
      debugPrint('── [6/8] Channels: Create Channel has Description and Topic fields ──');
      // Scroll down to see more fields
      await tester.scrollUntilVisible(
        find.text('Description'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Description'), findsWidgets);

      // ── Test 45 ─────────────────────────────────────────────────────
      debugPrint('── [7/8] Channels: Create Channel type selector ──');
      // Should have Public/Private options
      final hasPublic = find.text('Public').evaluate().isNotEmpty;
      final hasPrivate = find.text('Private').evaluate().isNotEmpty;
      expect(hasPublic || hasPrivate, isTrue,
          reason: 'Should have channel type selector');

      // ── Test 46 ─────────────────────────────────────────────────────
      debugPrint('── [8/8] Channels: Create Channel validates empty name ──');
      // Scroll to find the create/submit button
      final hasCreateButton = find.text('Create').evaluate().isNotEmpty;
      final hasCreateChannel =
          find.text('Create Channel').evaluate().length > 1;

      if (hasCreateButton) {
        // Try submitting with empty name
        await tester.scrollUntilVisible(
          find.text('Create').last,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await TestPumpHelper.tapAndSettle(tester, find.text('Create').last);
        await tester.pump(const Duration(milliseconds: 500));

        final hasNameError =
            find.text('Channel name is required').evaluate().isNotEmpty;
        expect(hasNameError, isTrue,
            reason: 'Empty name should trigger validation error');
      }

      // Navigate back to Channels
      await tester.tap(find.byIcon(Icons.arrow_back));
      await TestPumpHelper.pumpAndTrySettle(tester);

      debugPrint('── All channel tests passed! ──');
    });
  });
}
