import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_app_bootstrap.dart';
import '../helpers/test_auth_helper.dart';
import '../helpers/test_config.dart';
import '../helpers/test_keys.dart';
import '../helpers/test_navigation_helper.dart';
import '../helpers/test_pump_helper.dart';
import '../helpers/test_scroll_helper.dart';
import '../helpers/test_wait_helper.dart';

/// Logout flow tests — 1 OTP, single testWidgets.
/// Logout MUST be the last test since it terminates the session.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Logout', () {
    testWidgets('All logout tests (shared session)', (tester) async {
      await startApp();
      await TestAuthHelper.fullLogin(tester);

      // Navigate to Settings (More → Settings)
      await TestNavigationHelper.goToMore(tester);
      await TestScrollHelper.navigateFromMoreTo(tester, 'Settings', 'Settings');

      // Scroll to Sign Out button
      final logoutButton = find.byKey(TestKeys.logoutButton);
      await tester.scrollUntilVisible(logoutButton, 200);

      // ── Test 122 ────────────────────────────────────────────────────
      debugPrint('── [1/2] Logout: Sign Out button shows confirmation dialog ──');
      await TestPumpHelper.tapAndSettle(tester, logoutButton);

      // The dialog should have "Sign Out" as the confirm action
      final confirmButton = find.text('Sign Out').last;
      expect(confirmButton.evaluate().isNotEmpty, isTrue,
          reason: 'Sign Out confirmation dialog should appear');

      // ── Test 123 ────────────────────────────────────────────────────
      debugPrint('── [2/2] Logout: confirming Sign Out returns to Welcome ──');
      await tester.tap(confirmButton);

      // Wait for login screen
      await TestWaitHelper.waitForWidget(
        tester,
        find.text('Welcome'),
        timeout: TestConfig.apiTimeout,
      );
      expect(find.text('Welcome'), findsOneWidget);

      debugPrint('── All logout tests passed! ──');
    });
  });
}
