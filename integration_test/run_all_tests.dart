/// Full E2E test suite orchestrator — imports all 19 test files.
///
/// IMPORTANT: Flutter integration tests cannot run multiple test files in a
/// single `flutter test` invocation the same way unit tests can. Each file
/// needs its own `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`
/// call and runs in its own isolate.
///
/// To run the full suite, use a shell script or run files individually:
///
/// **Quick smoke test** (3 OTPs, ~5 min):
///   flutter test integration_test/app_test.dart -d <device-id>
///
/// **Full suite** (18 OTPs, ~45 min, run sequentially):
///   for %%f in (integration_test\tests\*.dart) do flutter test %%f -d <device-id>
///
/// Or on bash/WSL:
///   for f in integration_test/tests/*.dart; do flutter test "$f" -d <device-id>; done
///
/// **Individual file** (1 OTP per file, ~2-5 min each):
///   flutter test integration_test/tests/01_auth_tests.dart -d <device-id>
///
/// ═══════════════════════════════════════════════════════════════════════════
/// Test File Inventory (19 files, ~123 logical test sections)
/// ═══════════════════════════════════════════════════════════════════════════
///
/// File                          OTPs  Tests  Description
/// ────────────────────────────  ────  ─────  ─────────────────────────────
/// 01_auth_tests.dart              0     12   Login screen, validation
/// 02_otp_tests.dart               2      5   OTP flow, back button, login
/// 03_navigation_tests.dart        1      8   Bottom nav, tab switching
/// 04_conversations_tests.dart     1      8   Chats screen, FAB, states
/// 05_new_chat_tests.dart          1      5   New Chat search, empty state
/// 06_channels_tests.dart          1      8   Channels, Create Channel form
/// 07_search_tests.dart            1      7   Search tabs, initial state
/// 08_notifications_tests.dart     1      6   Notifications, empty state
/// 09_more_menu_tests.dart         1      6   More menu sections
/// 10_workspaces_tests.dart        1      7   Workspaces, Join/Create
/// 11_bookmarks_tests.dart         1      6   Bookmarks, New Folder dialog
/// 12_reminders_tests.dart         1      5   Reminders, empty state
/// 13_threads_tests.dart           1      4   Threads, empty state
/// 14_files_tests.dart             1      4   Files, empty state
/// 15_settings_tests.dart          1      9   Settings sections and tiles
/// 16_security_tests.dart          1      6   2FA, Sessions
/// 17_admin_tests.dart             1      9   Admin Dashboard/Users/Audit
/// 18_calls_devices_tests.dart     1      6   Call History, Devices
/// 19_logout_tests.dart            1      2   Logout confirmation flow
/// ────────────────────────────  ────  ─────
/// TOTAL                          18    123
///
/// ═══════════════════════════════════════════════════════════════════════════
/// Helpers (10 files in integration_test/helpers/)
/// ═══════════════════════════════════════════════════════════════════════════
///
/// test_app_bootstrap.dart    — startApp() clears storage, calls main()
/// test_auth_helper.dart      — fullLogin(), loginWithPhone(), etc.
/// test_config.dart           — phone numbers, timeouts, generateUniquePhone()
/// test_dialog_helper.dart    — dialog open/close/assert utilities
/// test_keys.dart             — ValueKey constants for interactive elements
/// test_navigation_helper.dart — tab navigation + More menu shortcuts
/// test_otp_helper.dart       — getTestOtpFromBloc() reads test OTP
/// test_pump_helper.dart      — tapAndSettle(), pumpAndTrySettle()
/// test_scroll_helper.dart    — scrollToAndTap(), navigateFromMoreTo()
/// test_wait_helper.dart      — waitForWidget(), pumpFor(), etc.
library;
