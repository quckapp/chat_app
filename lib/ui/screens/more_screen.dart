import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme.dart';

/// Screen showing navigation to all secondary features
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: [
          _buildSection(context, 'Workspace', [
            _MenuItem(Icons.workspaces, 'Workspaces', '/workspaces'),
            _MenuItem(Icons.forum, 'Threads', '/threads'),
          ]),
          _buildSection(context, 'Content', [
            _MenuItem(Icons.folder, 'Files', '/files'),
            _MenuItem(Icons.bookmark, 'Bookmarks', '/bookmarks'),
            _MenuItem(Icons.alarm, 'Reminders', '/reminders'),
          ]),
          _buildSection(context, 'Communication', [
            _MenuItem(Icons.call, 'Call History', '/call-history'),
          ]),
          _buildSection(context, 'Account', [
            _MenuItem(Icons.settings, 'Settings', '/settings'),
            _MenuItem(Icons.devices, 'Devices', '/devices'),
            _MenuItem(Icons.security, 'Two-Factor Auth', '/settings/2fa'),
            _MenuItem(Icons.phonelink, 'Sessions', '/settings/sessions'),
          ]),
          _buildSection(context, 'Administration', [
            _MenuItem(Icons.admin_panel_settings, 'Admin Dashboard', '/admin'),
            _MenuItem(Icons.people, 'User Management', '/admin/users'),
            _MenuItem(Icons.history, 'Audit Log', '/admin/audit'),
            _MenuItem(Icons.tune, 'Admin Settings', '/admin/settings'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xs,
          ),
          child: Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items.map((item) => ListTile(
              leading: Icon(item.icon, color: AppColors.grey500),
              title: Text(item.label, style: AppTypography.bodyLarge),
              trailing: Icon(Icons.chevron_right, color: AppColors.grey400),
              onTap: () => context.push(item.route),
            )),
        const Divider(height: 1),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;

  const _MenuItem(this.icon, this.label, this.route);
}
