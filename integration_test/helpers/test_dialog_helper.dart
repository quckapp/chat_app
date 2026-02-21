import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_pump_helper.dart';
import 'test_wait_helper.dart';

/// Helper for testing dialogs, bottom sheets, and popup menus.
class TestDialogHelper {
  /// Wait for a dialog containing [title] text to appear.
  static Future<void> waitForDialog(
    WidgetTester tester,
    String title, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await TestWaitHelper.waitForWidget(
      tester,
      find.text(title),
      timeout: timeout,
    );
    expect(find.text(title), findsOneWidget,
        reason: 'Dialog with title "$title" should be visible');
  }

  /// Close a dialog by tapping a button with the given text.
  ///
  /// Handles both uppercase (e.g., "CLOSE") and normal case (e.g., "Close")
  /// by trying the exact text first, then the uppercase version.
  static Future<void> closeDialogByText(
    WidgetTester tester,
    String buttonText,
  ) async {
    final button = find.text(buttonText);
    if (button.evaluate().isNotEmpty) {
      await TestPumpHelper.tapAndSettle(tester, button);
      return;
    }

    // Try uppercase version (Flutter's material buttons may use uppercase)
    final upperButton = find.text(buttonText.toUpperCase());
    if (upperButton.evaluate().isNotEmpty) {
      await TestPumpHelper.tapAndSettle(tester, upperButton);
      return;
    }

    // Fall back to tapping outside the dialog
    await closeDialogByTapOutside(tester);
  }

  /// Close a dialog by tapping outside it (at a corner of the screen).
  static Future<void> closeDialogByTapOutside(WidgetTester tester) async {
    await tester.tapAt(const Offset(10, 10));
    await TestPumpHelper.pumpAndTrySettle(tester);
  }

  /// Assert that a dialog has specific buttons (by text).
  static void expectDialogButtons(
    WidgetTester tester,
    List<String> buttonTexts,
  ) {
    for (final text in buttonTexts) {
      expect(find.text(text), findsOneWidget,
          reason: 'Dialog should have "$text" button');
    }
  }
}
