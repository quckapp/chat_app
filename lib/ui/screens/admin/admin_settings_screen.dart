import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/admin/admin_bloc.dart';
import '../../../bloc/admin/admin_event.dart';
import '../../../bloc/admin/admin_state.dart';
import '../../../core/theme/theme.dart';
import '../../../models/serializable/admin_dto.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminLoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.settings.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.settings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, size: 64, color: AppColors.grey400),
                  const SizedBox(height: AppSpacing.md),
                  Text('No settings', style: AppTypography.headlineSmall),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AdminBloc>().add(const AdminLoadSettings());
            },
            child: ListView.separated(
              itemCount: state.settings.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final setting = state.settings[index];
                return _buildSettingTile(setting);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingTile(AdminSettingsDto setting) {
    return ListTile(
      title: Text(setting.key, style: AppTypography.bodyLarge),
      subtitle: Text(
        setting.value,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: AppColors.grey400, size: 20),
        onPressed: () => _showEditSettingDialog(setting),
      ),
    );
  }

  void _showEditSettingDialog(AdminSettingsDto setting) {
    final valueController = TextEditingController(text: setting.value);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${setting.key}'),
        content: TextField(
          controller: valueController,
          decoration: const InputDecoration(labelText: 'Value'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = valueController.text.trim();
              if (value.isNotEmpty) {
                Navigator.pop(ctx);
                context.read<AdminBloc>().add(
                      AdminUpdateSetting(key: setting.key, value: value),
                    );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
