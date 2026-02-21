import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/device_info.dart';
import '../../../repositories/device_repository.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final DeviceRepository _repository = DeviceRepository();
  List<DeviceInfo> _devices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final devices = await _repository.getDevices();
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registered Devices')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text('Failed to load devices', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(
              onPressed: _loadDevices,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices, size: 64, color: AppColors.grey400),
            const SizedBox(height: AppSpacing.md),
            Text('No devices registered', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Your devices will appear here',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDevices,
      child: ListView.separated(
        itemCount: _devices.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final device = _devices[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(_deviceIcon(device), color: AppColors.primary, size: 20),
            ),
            title: Text(
              device.deviceName ?? device.platform,
              style: AppTypography.bodyLarge,
            ),
            subtitle: Text(
              _formatLastActive(device.lastActiveAt),
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey500),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.grey400, size: 20),
              onPressed: () => _confirmRemoveDevice(device),
            ),
          );
        },
      ),
    );
  }

  IconData _deviceIcon(DeviceInfo device) {
    if (device.isAndroid) return Icons.phone_android;
    if (device.isIos) return Icons.phone_iphone;
    if (device.isWeb) return Icons.web;
    return Icons.devices;
  }

  String _formatLastActive(DateTime? date) {
    if (date == null) return 'Never active';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 5) return 'Active now';
    if (diff.inMinutes < 60) return 'Active ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Active ${diff.inHours}h ago';
    return 'Active ${diff.inDays}d ago';
  }

  void _confirmRemoveDevice(DeviceInfo device) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Device'),
        content: Text('Remove "${device.deviceName ?? device.platform}"? '
            'You will no longer receive push notifications on this device.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _repository.removeDevice(device.id);
                setState(() {
                  _devices = _devices.where((d) => d.id != device.id).toList();
                });
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove device: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
