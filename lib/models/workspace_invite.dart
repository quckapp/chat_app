import 'package:equatable/equatable.dart';

/// Represents an invite to a workspace (transient, no Hive caching)
class WorkspaceInvite extends Equatable {
  final String id;
  final String workspaceId;
  final String? email;
  final String role;
  final String? token;
  final String? code;
  final String invitedBy;
  final DateTime? expiresAt;
  final DateTime? acceptedAt;
  final int maxUses;
  final int useCount;
  final bool isActive;
  final DateTime createdAt;

  const WorkspaceInvite({
    required this.id,
    required this.workspaceId,
    this.email,
    this.role = 'member',
    this.token,
    this.code,
    required this.invitedBy,
    this.expiresAt,
    this.acceptedAt,
    this.maxUses = 0,
    this.useCount = 0,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isExpired =>
      expiresAt != null && expiresAt!.isBefore(DateTime.now());
  bool get isAccepted => acceptedAt != null;
  bool get isInviteCode => code != null;

  factory WorkspaceInvite.fromJson(Map<String, dynamic> json) {
    return WorkspaceInvite(
      id: json['id'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? json['workspaceId'] as String? ?? '',
      email: json['email'] as String?,
      role: json['role'] as String? ?? 'member',
      token: json['token'] as String?,
      code: json['code'] as String?,
      invitedBy: json['invited_by'] as String? ??
          json['invitedBy'] as String? ??
          json['created_by'] as String? ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : json['expiresAt'] != null
              ? DateTime.parse(json['expiresAt'] as String)
              : null,
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'] as String)
          : null,
      maxUses: (json['max_uses'] as num?)?.toInt() ??
          (json['maxUses'] as num?)?.toInt() ?? 0,
      useCount: (json['use_count'] as num?)?.toInt() ??
          (json['useCount'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
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
      'workspace_id': workspaceId,
      'email': email,
      'role': role,
      'token': token,
      'code': code,
      'invited_by': invitedBy,
      'expires_at': expiresAt?.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'max_uses': maxUses,
      'use_count': useCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id, workspaceId, email, role, token, code,
        invitedBy, expiresAt, acceptedAt, maxUses,
        useCount, isActive, createdAt,
      ];
}
