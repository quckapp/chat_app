import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'audit_log.g.dart';

/// Represents an audit log entry
@HiveType(typeId: 40)
class AuditLogEntry extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String action;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String targetType;
  @HiveField(4)
  final String targetId;
  @HiveField(5)
  final String? details;
  @HiveField(6)
  final String? ipAddress;
  @HiveField(7)
  final String? userAgent;
  @HiveField(8)
  final DateTime createdAt;

  const AuditLogEntry({
    required this.id,
    required this.action,
    required this.userId,
    required this.targetType,
    required this.targetId,
    this.details,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
  });

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) {
    return AuditLogEntry(
      id: json['id'] as String? ?? '',
      action: json['action'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      targetType: json['target_type'] as String? ?? json['targetType'] as String? ?? '',
      targetId: json['target_id'] as String? ?? json['targetId'] as String? ?? '',
      details: json['details'] as String?,
      ipAddress: json['ip_address'] as String? ?? json['ipAddress'] as String?,
      userAgent: json['user_agent'] as String? ?? json['userAgent'] as String?,
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
      'action': action,
      'user_id': userId,
      'target_type': targetType,
      'target_id': targetId,
      'details': details,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AuditLogEntry copyWith({
    String? id,
    String? action,
    String? userId,
    String? targetType,
    String? targetId,
    String? details,
    String? ipAddress,
    String? userAgent,
    DateTime? createdAt,
  }) {
    return AuditLogEntry(
      id: id ?? this.id,
      action: action ?? this.action,
      userId: userId ?? this.userId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        action,
        userId,
        targetType,
        targetId,
        details,
        ipAddress,
        userAgent,
        createdAt,
      ];
}
