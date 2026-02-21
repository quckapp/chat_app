import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _soundEnabled = true;
  bool _mentionsOnly = false;
  bool _muteAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('Push Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: Text(
              'Receive push notifications on this device',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
            ),
            value: _pushEnabled,
            onChanged: (value) => setState(() => _pushEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: Text(
              'Play a sound for new notifications',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
            ),
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
          ),
          const Divider(),
          _buildSectionHeader('Email Notifications'),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: Text(
              'Receive email for missed notifications',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
            ),
            value: _emailEnabled,
            onChanged: (value) => setState(() => _emailEnabled = value),
          ),
          const Divider(),
          _buildSectionHeader('Notification Filters'),
          SwitchListTile(
            title: const Text('Mentions Only'),
            subtitle: Text(
              'Only notify for @mentions and direct messages',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
            ),
            value: _mentionsOnly,
            onChanged: (value) => setState(() => _mentionsOnly = value),
          ),
          SwitchListTile(
            title: const Text('Mute All'),
            subtitle: Text(
              'Temporarily mute all notifications',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
            ),
            value: _muteAll,
            onChanged: (value) => setState(() => _muteAll = value),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilledButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.grey500,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Save settings via repository
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }
}
