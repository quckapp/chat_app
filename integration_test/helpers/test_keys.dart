import 'package:flutter/material.dart';

/// ValueKey constants matching keys added to production widgets.
///
/// These keys must match the Key(...) values set on widgets in the
/// production code (lib/ directory). If a key doesn't exist in production
/// code yet, tests should use text/icon finders instead.
class TestKeys {
  // Login Screen
  static const phoneField = Key('login_phone_field');
  static const sendOtpButton = Key('login_send_otp_button');

  // OTP Screen
  static Key otpField(int index) => Key('otp_field_$index');
  static const verifyButton = Key('otp_verify_button');

  // Register Name Screen
  static const firstNameField = Key('register_first_name');
  static const lastNameField = Key('register_last_name');
  static const usernameField = Key('register_username');
  static const continueButton = Key('register_continue_button');

  // App Shell
  static const bottomNav = Key('app_bottom_nav');

  // Settings
  static const logoutButton = Key('settings_logout_button');

  // Channel Creation (text-based finders used if keys not in production)
  static const channelNameField = Key('channel_name_field');
  static const channelDescriptionField = Key('channel_description_field');
  static const channelTopicField = Key('channel_topic_field');
  static const channelCreateButton = Key('channel_create_button');

  // Workspace Creation
  static const workspaceNameField = Key('workspace_name_field');
  static const workspaceSlugField = Key('workspace_slug_field');
  static const workspaceDescriptionField = Key('workspace_description_field');
  static const workspaceCreateButton = Key('workspace_create_button');

  // Search
  static const searchField = Key('search_field');
}
