import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_pump_helper.dart';
import 'test_wait_helper.dart';

/// Helper for scrolling and tapping items, especially in the More menu.
///
/// The More screen is a ListView with 5 sections. Items near the bottom
/// (Administration) require scrolling. This helper encapsulates that pattern.
class TestScrollHelper {
  /// Scroll to make [text] visible, then tap it.
  ///
  /// [delta] controls scroll direction: positive = scroll down, negative = scroll up.
  static Future<void> scrollToAndTap(
    WidgetTester tester,
    String text, {
    double delta = 200,
  }) async {
    await tester.scrollUntilVisible(
      find.text(text),
      delta,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 300));
    await TestPumpHelper.tapAndSettle(tester, find.text(text));
  }

  /// Navigate from the More tab to a sub-screen by tapping a menu item.
  ///
  /// Scrolls to find [menuItem] in the More screen's ListView, taps it,
  /// and waits for [expectedTitle] to appear on the new screen.
  static Future<void> navigateFromMoreTo(
    WidgetTester tester,
    String menuItem,
    String expectedTitle, {
    Duration apiWait = const Duration(seconds: 3),
  }) async {
    // Scroll to the menu item (try down first, then up)
    try {
      await tester.scrollUntilVisible(
        find.text(menuItem),
        200,
        scrollable: find.byType(Scrollable).first,
      );
    } catch (_) {
      // If not found scrolling down, try scrolling up
      await tester.scrollUntilVisible(
        find.text(menuItem),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tester.pump(const Duration(milliseconds: 300));

    // For items near the very bottom (like Admin Settings), extra scroll
    // to move away from the edge
    if (menuItem == 'Admin Settings') {
      await tester.drag(
        find.byType(Scrollable).first,
        const Offset(0, -100),
      );
      await tester.pump(const Duration(milliseconds: 300));
    }

    // Tap the menu item
    await TestPumpHelper.tapAndSettle(tester, find.text(menuItem));

    // Wait for API data and screen to load
    await TestWaitHelper.pumpFor(tester, apiWait);

    // Verify we arrived at the expected screen
    final hasTitleText = find.text(expectedTitle).evaluate().isNotEmpty;
    expect(hasTitleText, isTrue,
        reason: '$expectedTitle screen should have title');
  }

  /// Navigate back from a sub-screen to the More menu.
  static Future<void> navigateBackToMore(WidgetTester tester) async {
    await TestPumpHelper.navigateBackAndWait(tester, 'More');
  }
}
