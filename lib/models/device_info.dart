import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'device_info.g.dart';

/// Represents a registered device for push notifications
@HiveType(typeId: 31)
class DeviceInfo extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String deviceToken;
  @HiveField(3)
  final String platform;
  @HiveField(4)
  final String? deviceName;
  @HiveField(5)
  final DateTime? lastActiveAt;
  @HiveField(6)
  final DateTime createdAt;

  const DeviceInfo({
    required this.id,
    required this.userId,
    required this.deviceToken,
    required this.platform,
    this.deviceName,
    this.lastActiveAt,
    required this.createdAt,
  });

  bool get isAndroid => platform.toLowerCase() == 'android';
  bool get isIos => platform.toLowerCase() == 'ios';
  bool get isWeb => platform.toLowerCase() == 'web';

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      deviceToken: json['device_token'] as String? ?? json['deviceToken'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      deviceName: json['device_name'] as String? ?? json['deviceName'] as String?,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : json['lastActiveAt'] != null
              ? DateTime.parse(json['lastActiveAt'] as String)
              : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'device_token': deviceToken,
      'platform': platform,
      'device_name': deviceName,
      'last_active_at': lastActiveAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  DeviceInfo copyWith({
    String? id,
    String? userId,
    String? deviceToken,
    String? platform,
    String? deviceName,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      deviceToken: deviceToken ?? this.deviceToken,
      platform: platform ?? this.platform,
      deviceName: deviceName ?? this.deviceName,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id, userId, deviceToken, platform, deviceName, lastActiveAt, createdAt,
      ];
}
