import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 5)
class User extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String phoneNumber;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? username;
  @HiveField(4)
  final String? firstName;
  @HiveField(5)
  final String? lastName;
  @HiveField(6)
  final String? displayName;
  @HiveField(7)
  final String? avatar;
  @HiveField(8)
  final bool phoneVerified;
  @HiveField(9)
  final bool isNewUser;
  @HiveField(10)
  final DateTime? createdAt;
  @HiveField(11)
  final UserStatus status;

  const User({
    required this.id,
    required this.phoneNumber,
    this.email,
    this.username,
    this.firstName,
    this.lastName,
    this.displayName,
    this.avatar,
    this.phoneVerified = false,
    this.isNewUser = false,
    this.createdAt,
    this.status = UserStatus.offline,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? displayName ?? phoneNumber;
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName![0].toUpperCase();
    }
    // Try displayName
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.trim().split(' ');
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    // Try username
    if (username != null && username!.isNotEmpty) {
      return username![0].toUpperCase();
    }
    // Use last 2 digits of phone number if available
    if (phoneNumber.length >= 2) {
      return phoneNumber.substring(phoneNumber.length - 2);
    }
    // Fallback
    return '??';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle both UUID (from backend UserProfileDto) and String ID
    final rawId = json['id'];
    final String id = rawId is String ? rawId : rawId.toString();

    // Extract displayName - try to split into firstName/lastName if not provided
    final displayName = json['displayName'] as String?;
    String? firstName = json['firstName'] as String?;
    String? lastName = json['lastName'] as String?;

    // If no firstName/lastName but we have displayName, try to split it
    if (firstName == null && lastName == null && displayName != null) {
      final parts = displayName.trim().split(' ');
      if (parts.length >= 2) {
        firstName = parts.first;
        lastName = parts.sublist(1).join(' ');
      } else if (parts.isNotEmpty) {
        firstName = parts.first;
      }
    }

    return User(
      id: id,
      phoneNumber: json['phoneNumber'] as String? ?? json['phone'] as String? ?? '',
      email: json['email'] as String?,
      username: json['username'] as String?,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      avatar: json['avatar'] as String?,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      isNewUser: json['newUser'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      status: UserStatus.fromString(json['status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'avatar': avatar,
      'phoneVerified': phoneVerified,
      'newUser': isNewUser,
      'createdAt': createdAt?.toIso8601String(),
      'status': status.name,
    };
  }

  User copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? displayName,
    String? avatar,
    bool? phoneVerified,
    bool? isNewUser,
    DateTime? createdAt,
    UserStatus? status,
  }) {
    return User(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isNewUser: isNewUser ?? this.isNewUser,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        email,
        username,
        firstName,
        lastName,
        displayName,
        avatar,
        phoneVerified,
        isNewUser,
        createdAt,
        status,
      ];
}

@HiveType(typeId: 7)
enum UserStatus {
  @HiveField(0)
  online,
  @HiveField(1)
  offline,
  @HiveField(2)
  away;

  static UserStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'online':
        return UserStatus.online;
      case 'away':
        return UserStatus.away;
      default:
        return UserStatus.offline;
    }
  }
}
