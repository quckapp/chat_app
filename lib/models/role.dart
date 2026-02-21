import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'role.g.dart';

/// Represents a user role with permissions
@HiveType(typeId: 41)
class AppRole extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final List<String> permissions;
  @HiveField(4)
  final bool isDefault;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime? updatedAt;

  const AppRole({
    required this.id,
    required this.name,
    this.description,
    this.permissions = const [],
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory AppRole.fromJson(Map<String, dynamic> json) {
    return AppRole(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isDefault: json['is_default'] as bool? ?? json['isDefault'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AppRole copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? permissions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, permissions, isDefault, createdAt, updatedAt];
}

/// Represents a security policy
@HiveType(typeId: 42)
class SecurityPolicy extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String? rules;
  @HiveField(4)
  final bool isActive;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime? updatedAt;

  const SecurityPolicy({
    required this.id,
    required this.name,
    required this.type,
    this.rules,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory SecurityPolicy.fromJson(Map<String, dynamic> json) {
    return SecurityPolicy(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      rules: json['rules'] as String?,
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'rules': rules,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SecurityPolicy copyWith({
    String? id,
    String? name,
    String? type,
    String? rules,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SecurityPolicy(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rules: rules ?? this.rules,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, type, rules, isActive, createdAt, updatedAt];
}
