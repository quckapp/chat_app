import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_wait_helper.dart';

/// Helper to reduce the repetitive pump + pumpAndSettle + catch boilerplate.
///
/// Nearly every UI interaction in integration tests needs:
///   1. tester.pump(Duration)
///   2. tester.pumpAndSettle(...) wrapped in try/catch
/// This helper encapsulates those patterns.
class TestPumpHelper {
  /// Tap a finder and settle (with timeout catch for persistent animations).
  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.tap(finder);
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        timeout,
      );
    } catch (_) {
      // May not settle due to persistent animations (WebSocket spinner, etc.)
    }
  }

  /// Pump + try settle with customizable timeout.
  static Future<void> pumpAndTrySettle(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        timeout,
      );
    } catch (_) {
      // May not settle due to persistent animations
    }
  }

  /// Navigate back via arrow_back icon and wait for expected screen text.
  static Future<void> navigateBackAndWait(
    WidgetTester tester,
    String expectedText, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
    } catch (_) {}
    await TestWaitHelper.waitForWidget(
      tester,
      find.text(expectedText),
      timeout: timeout,
    );
  }
}
