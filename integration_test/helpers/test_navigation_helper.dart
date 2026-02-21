import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_scroll_helper.dart';

/// Helper for navigating between bottom tabs and sub-screens.
class TestNavigationHelper {
  /// Tap a bottom navigation tab by its label text.
  static Future<void> tapTab(WidgetTester tester, String label) async {
    final tab = find.text(label);
    expect(tab, findsWidgets, reason: 'Tab "$label" should be visible');
    // Use .last to avoid hitting app bar title text with the same label
    await tester.tap(tab.last);
    await tester.pump(const Duration(milliseconds: 500));
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
    } catch (_) {
      // May not settle due to persistent animations
    }
  }

  // ── Bottom tab shortcuts ──────────────────────────────────────────────

  static Future<void> goToChats(WidgetTester tester) =>
      tapTab(tester, 'Chats');

  static Future<void> goToChannels(WidgetTester tester) =>
      tapTab(tester, 'Channels');

  static Future<void> goToSearch(WidgetTester tester) =>
      tapTab(tester, 'Search');

  static Future<void> goToNotifications(WidgetTester tester) =>
      tapTab(tester, 'Notifications');

  static Future<void> goToMore(WidgetTester tester) =>
      tapTab(tester, 'More');

  /// Verify the bottom navigation bar is visible.
  static void verifyBottomNavVisible(WidgetTester tester) {
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
  }

  // ── More menu sub-screen shortcuts ────────────────────────────────────
  // Each method: More tab → scroll to item → tap → wait for screen title

  static Future<void> goToWorkspaces(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Workspaces', 'Workspaces');
  }

  static Future<void> goToThreads(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Threads', 'Threads');
  }

  static Future<void> goToFiles(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Files', 'Files');
  }

  static Future<void> goToBookmarks(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Bookmarks', 'Bookmarks');
  }

  static Future<void> goToReminders(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Reminders', 'Reminders');
  }

  static Future<void> goToCallHistory(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Call History', 'Call History');
  }

  static Future<void> goToSettings(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Settings', 'Settings');
  }

  static Future<void> goToDevices(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Devices', 'Registered Devices');
  }

  static Future<void> goToTwoFactorAuth(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(
        tester, 'Two-Factor Auth', 'Two-Factor Authentication');
  }

  static Future<void> goToSessions(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Sessions', 'Active Sessions');
  }

  static Future<void> goToAdminDashboard(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(
        tester, 'Admin Dashboard', 'Admin Dashboard');
  }

  static Future<void> goToUserManagement(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(
        tester, 'User Management', 'User Management');
  }

  static Future<void> goToAuditLog(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(tester, 'Audit Log', 'Audit Logs');
  }

  static Future<void> goToAdminSettings(WidgetTester tester) async {
    await goToMore(tester);
    await TestScrollHelper.navigateFromMoreTo(
        tester, 'Admin Settings', 'Admin Settings');
  }
}
