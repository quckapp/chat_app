import 'package:flutter/foundation.dart';
import '../core/constants/api_constants.dart';
import '../core/network/rest_client.dart';
import '../models/device_info.dart';
import '../models/notification_preference.dart';
import '../models/serializable/device_dto.dart';

/// Repository for device and notification preference operations
class DeviceRepository {
  final RestClient _client;

  DeviceRepository({RestClient? client})
      : _client = client ?? RestClient(baseUrl: ApiConstants.kongBaseUrl);

  /// List registered devices
  Future<List<DeviceInfo>> getDevices() async {
    debugPrint('DeviceRepository: Fetching devices');
    return _client.getList(
      '/api/devices',
      fromJson: (json) => DeviceInfo.fromJson(json),
    );
  }

  /// Register a new device
  Future<DeviceInfo> registerDevice(RegisterDeviceDto data) async {
    return _client.post(
      '/api/devices',
      data: data.toJson(),
      fromJson: (json) => DeviceInfo.fromJson(json),
    );
  }

  /// Remove a device
  Future<void> removeDevice(String deviceId) async {
    await _client.delete('/api/devices/$deviceId');
  }

  /// Get notification preferences
  Future<List<NotificationPreference>> getPreferences() async {
    debugPrint('DeviceRepository: Fetching notification preferences');
    return _client.getList(
      '/api/preferences',
      fromJson: (json) => NotificationPreference.fromJson(json),
    );
  }

  /// Update notification preferences
  Future<NotificationPreference> updatePreferences(String id, UpdatePreferenceDto data) async {
    return _client.put(
      '/api/preferences/$id',
      data: data.toJson(),
      fromJson: (json) => NotificationPreference.fromJson(json),
    );
  }
}
