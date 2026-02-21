import 'package:chat_app/core/storage/secure_storage.dart';
import 'package:chat_app/main.dart' as app;

/// Launch the full app for integration testing.
///
/// Clears secure storage first so each test starts on the login screen
/// (no persisted auth tokens from previous tests).
///
/// Safe to call multiple times — Flutter handles duplicate binding init,
/// and Hive adapter registration checks `isAdapterRegistered`.
Future<void> startApp() async {
  // Clear any persisted tokens so the app starts on the login screen
  try {
    await SecureStorage.instance.clearAll();
  } catch (_) {
    // SecureStorage may fail before full init — that's fine
  }
  app.main();
}
