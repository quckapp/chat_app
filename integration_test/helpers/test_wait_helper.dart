import 'package:flutter_test/flutter_test.dart';

import 'test_config.dart';

/// Helper for waiting on widgets/API responses in integration tests.
///
/// Uses pump loops instead of pumpAndSettle to avoid infinite waits
/// when persistent animations (e.g. realtime connection spinner) are active.
class TestWaitHelper {
  /// Pumps until [finder] matches at least one widget, or times out.
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (finder.evaluate().isNotEmpty) {
        // Found it — do one more settle for animations
        try {
          await tester.pumpAndSettle(
            const Duration(milliseconds: 100),
            EnginePhase.sendSemanticsUpdate,
            const Duration(seconds: 3),
          );
        } catch (_) {
          // pumpAndSettle may time out if persistent animations exist — that's OK
        }
        return;
      }
    }
    // Final assertion for clear error message
    expect(finder, findsAtLeast(1),
        reason: 'Timed out waiting for widget after ${timeout.inSeconds}s');
  }

  /// Waits until ANY of the given finders matches. Returns the matching finder.
  static Future<Finder> waitForAny(
    WidgetTester tester,
    List<Finder> finders, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 200));
      for (final finder in finders) {
        if (finder.evaluate().isNotEmpty) {
          try {
            await tester.pumpAndSettle(
              const Duration(milliseconds: 100),
              EnginePhase.sendSemanticsUpdate,
              const Duration(seconds: 3),
            );
          } catch (_) {}
          return finder;
        }
      }
    }
    throw Exception(
      'Timed out after ${timeout.inSeconds}s waiting for any of ${finders.length} finders',
    );
  }

  /// Pump and settle with generous timeout for API calls.
  static Future<void> pumpAndSettleForApi(WidgetTester tester) async {
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        TestConfig.apiTimeout,
      );
    } catch (_) {
      // May time out due to persistent animations — that's OK
    }
  }

  /// Simple pump loop for a fixed duration (useful for debounce waits).
  static Future<void> pumpFor(
    WidgetTester tester,
    Duration duration,
  ) async {
    final end = DateTime.now().add(duration);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }
}
