import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'participant.g.dart';

/// Represents a participant in a conversation
@HiveType(typeId: 2)
class Participant extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? username;
  @HiveField(2)
  final String? displayName;
  @HiveField(3)
  final String? firstName;
  @HiveField(4)
  final String? lastName;
  @HiveField(5)
  final String? avatar;
  @HiveField(6)
  final ParticipantRole role;
  @HiveField(7)
  final DateTime joinedAt;
  @HiveField(8)
  final String? phoneNumber;

  const Participant({
    required this.id,
    this.username,
    this.displayName,
    this.firstName,
    this.lastName,
    this.avatar,
    this.role = ParticipantRole.member,
    required this.joinedAt,
    this.phoneNumber,
  });

  /// Get the actual name (without phone fallback)
  String? get actualName {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!;
    }
    if (lastName != null && lastName!.isNotEmpty) {
      return lastName!;
    }
    if (username != null && username!.isNotEmpty) {
      return username!;
    }
    return null;
  }

  /// Check if participant has a real name set
  bool get hasName => actualName != null;

  /// Get the country flag for phone number
  String get countryFlag {
    if (phoneNumber == null || phoneNumber!.isEmpty) return '';
    return _getCountryFlagFromPhone(phoneNumber!);
  }

  String get name {
    final realName = actualName;
    if (realName != null) {
      return realName;
    }
    // Fallback to phone number with country flag
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      return formattedPhoneWithFlag;
    }
    return 'Unknown';
  }

  /// Display name with flag for chat list and chat screen
  /// - If name exists: "John Doe 🇮🇳"
  /// - If only phone: "🇮🇳 +91-9876543219"
  String get displayNameWithFlag {
    final realName = actualName;
    final flag = countryFlag;

    if (realName != null && realName.isNotEmpty) {
      // Has name - show "Name 🇮🇳"
      if (flag.isNotEmpty) {
        return '$realName $flag';
      }
      return realName;
    }

    // No name - show "🇮🇳 +phone"
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      if (flag.isNotEmpty) {
        return '$flag $phoneNumber';
      }
      return phoneNumber!;
    }

    return 'Unknown';
  }

  /// Get phone number formatted with country flag emoji
  String get formattedPhoneWithFlag {
    if (phoneNumber == null || phoneNumber!.isEmpty) return '';

    final flag = _getCountryFlagFromPhone(phoneNumber!);
    return '$flag $phoneNumber';
  }

  /// Extract country flag emoji from phone number
  static String _getCountryFlagFromPhone(String phone) {
    // Remove any spaces, dashes, or parentheses
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Country code to flag emoji mapping (common codes)
    const countryFlags = {
      '+1': '🇺🇸',     // USA/Canada
      '+7': '🇷🇺',     // Russia
      '+20': '🇪🇬',    // Egypt
      '+27': '🇿🇦',    // South Africa
      '+30': '🇬🇷',    // Greece
      '+31': '🇳🇱',    // Netherlands
      '+32': '🇧🇪',    // Belgium
      '+33': '🇫🇷',    // France
      '+34': '🇪🇸',    // Spain
      '+36': '🇭🇺',    // Hungary
      '+39': '🇮🇹',    // Italy
      '+40': '🇷🇴',    // Romania
      '+41': '🇨🇭',    // Switzerland
      '+43': '🇦🇹',    // Austria
      '+44': '🇬🇧',    // UK
      '+45': '🇩🇰',    // Denmark
      '+46': '🇸🇪',    // Sweden
      '+47': '🇳🇴',    // Norway
      '+48': '🇵🇱',    // Poland
      '+49': '🇩🇪',    // Germany
      '+51': '🇵🇪',    // Peru
      '+52': '🇲🇽',    // Mexico
      '+53': '🇨🇺',    // Cuba
      '+54': '🇦🇷',    // Argentina
      '+55': '🇧🇷',    // Brazil
      '+56': '🇨🇱',    // Chile
      '+57': '🇨🇴',    // Colombia
      '+58': '🇻🇪',    // Venezuela
      '+60': '🇲🇾',    // Malaysia
      '+61': '🇦🇺',    // Australia
      '+62': '🇮🇩',    // Indonesia
      '+63': '🇵🇭',    // Philippines
      '+64': '🇳🇿',    // New Zealand
      '+65': '🇸🇬',    // Singapore
      '+66': '🇹🇭',    // Thailand
      '+81': '🇯🇵',    // Japan
      '+82': '🇰🇷',    // South Korea
      '+84': '🇻🇳',    // Vietnam
      '+86': '🇨🇳',    // China
      '+90': '🇹🇷',    // Turkey
      '+91': '🇮🇳',    // India
      '+92': '🇵🇰',    // Pakistan
      '+93': '🇦🇫',    // Afghanistan
      '+94': '🇱🇰',    // Sri Lanka
      '+95': '🇲🇲',    // Myanmar
      '+98': '🇮🇷',    // Iran
      '+211': '🇸🇸',   // South Sudan
      '+212': '🇲🇦',   // Morocco
      '+213': '🇩🇿',   // Algeria
      '+216': '🇹🇳',   // Tunisia
      '+218': '🇱🇾',   // Libya
      '+220': '🇬🇲',   // Gambia
      '+221': '🇸🇳',   // Senegal
      '+223': '🇲🇱',   // Mali
      '+224': '🇬🇳',   // Guinea
      '+225': '🇨🇮',   // Ivory Coast
      '+226': '🇧🇫',   // Burkina Faso
      '+227': '🇳🇪',   // Niger
      '+228': '🇹🇬',   // Togo
      '+229': '🇧🇯',   // Benin
      '+230': '🇲🇺',   // Mauritius
      '+231': '🇱🇷',   // Liberia
      '+232': '🇸🇱',   // Sierra Leone
      '+233': '🇬🇭',   // Ghana
      '+234': '🇳🇬',   // Nigeria
      '+235': '🇹🇩',   // Chad
      '+236': '🇨🇫',   // Central African Republic
      '+237': '🇨🇲',   // Cameroon
      '+238': '🇨🇻',   // Cape Verde
      '+239': '🇸🇹',   // São Tomé and Príncipe
      '+240': '🇬🇶',   // Equatorial Guinea
      '+241': '🇬🇦',   // Gabon
      '+242': '🇨🇬',   // Republic of the Congo
      '+243': '🇨🇩',   // DR Congo
      '+244': '🇦🇴',   // Angola
      '+245': '🇬🇼',   // Guinea-Bissau
      '+248': '🇸🇨',   // Seychelles
      '+249': '🇸🇩',   // Sudan
      '+250': '🇷🇼',   // Rwanda
      '+251': '🇪🇹',   // Ethiopia
      '+252': '🇸🇴',   // Somalia
      '+253': '🇩🇯',   // Djibouti
      '+254': '🇰🇪',   // Kenya
      '+255': '🇹🇿',   // Tanzania
      '+256': '🇺🇬',   // Uganda
      '+257': '🇧🇮',   // Burundi
      '+258': '🇲🇿',   // Mozambique
      '+260': '🇿🇲',   // Zambia
      '+261': '🇲🇬',   // Madagascar
      '+262': '🇷🇪',   // Réunion
      '+263': '🇿🇼',   // Zimbabwe
      '+264': '🇳🇦',   // Namibia
      '+265': '🇲🇼',   // Malawi
      '+266': '🇱🇸',   // Lesotho
      '+267': '🇧🇼',   // Botswana
      '+268': '🇸🇿',   // Eswatini
      '+269': '🇰🇲',   // Comoros
      '+290': '🇸🇭',   // Saint Helena
      '+291': '🇪🇷',   // Eritrea
      '+297': '🇦🇼',   // Aruba
      '+298': '🇫🇴',   // Faroe Islands
      '+299': '🇬🇱',   // Greenland
      '+350': '🇬🇮',   // Gibraltar
      '+351': '🇵🇹',   // Portugal
      '+352': '🇱🇺',   // Luxembourg
      '+353': '🇮🇪',   // Ireland
      '+354': '🇮🇸',   // Iceland
      '+355': '🇦🇱',   // Albania
      '+356': '🇲🇹',   // Malta
      '+357': '🇨🇾',   // Cyprus
      '+358': '🇫🇮',   // Finland
      '+359': '🇧🇬',   // Bulgaria
      '+370': '🇱🇹',   // Lithuania
      '+371': '🇱🇻',   // Latvia
      '+372': '🇪🇪',   // Estonia
      '+373': '🇲🇩',   // Moldova
      '+374': '🇦🇲',   // Armenia
      '+375': '🇧🇾',   // Belarus
      '+376': '🇦🇩',   // Andorra
      '+377': '🇲🇨',   // Monaco
      '+378': '🇸🇲',   // San Marino
      '+380': '🇺🇦',   // Ukraine
      '+381': '🇷🇸',   // Serbia
      '+382': '🇲🇪',   // Montenegro
      '+383': '🇽🇰',   // Kosovo
      '+385': '🇭🇷',   // Croatia
      '+386': '🇸🇮',   // Slovenia
      '+387': '🇧🇦',   // Bosnia and Herzegovina
      '+389': '🇲🇰',   // North Macedonia
      '+420': '🇨🇿',   // Czech Republic
      '+421': '🇸🇰',   // Slovakia
      '+423': '🇱🇮',   // Liechtenstein
      '+500': '🇫🇰',   // Falkland Islands
      '+501': '🇧🇿',   // Belize
      '+502': '🇬🇹',   // Guatemala
      '+503': '🇸🇻',   // El Salvador
      '+504': '🇭🇳',   // Honduras
      '+505': '🇳🇮',   // Nicaragua
      '+506': '🇨🇷',   // Costa Rica
      '+507': '🇵🇦',   // Panama
      '+509': '🇭🇹',   // Haiti
      '+590': '🇬🇵',   // Guadeloupe
      '+591': '🇧🇴',   // Bolivia
      '+592': '🇬🇾',   // Guyana
      '+593': '🇪🇨',   // Ecuador
      '+594': '🇬🇫',   // French Guiana
      '+595': '🇵🇾',   // Paraguay
      '+596': '🇲🇶',   // Martinique
      '+597': '🇸🇷',   // Suriname
      '+598': '🇺🇾',   // Uruguay
      '+599': '🇨🇼',   // Curaçao
      '+670': '🇹🇱',   // Timor-Leste
      '+672': '🇳🇫',   // Norfolk Island
      '+673': '🇧🇳',   // Brunei
      '+674': '🇳🇷',   // Nauru
      '+675': '🇵🇬',   // Papua New Guinea
      '+676': '🇹🇴',   // Tonga
      '+677': '🇸🇧',   // Solomon Islands
      '+678': '🇻🇺',   // Vanuatu
      '+679': '🇫🇯',   // Fiji
      '+680': '🇵🇼',   // Palau
      '+681': '🇼🇫',   // Wallis and Futuna
      '+682': '🇨🇰',   // Cook Islands
      '+683': '🇳🇺',   // Niue
      '+685': '🇼🇸',   // Samoa
      '+686': '🇰🇮',   // Kiribati
      '+687': '🇳🇨',   // New Caledonia
      '+688': '🇹🇻',   // Tuvalu
      '+689': '🇵🇫',   // French Polynesia
      '+690': '🇹🇰',   // Tokelau
      '+691': '🇫🇲',   // Micronesia
      '+692': '🇲🇭',   // Marshall Islands
      '+850': '🇰🇵',   // North Korea
      '+852': '🇭🇰',   // Hong Kong
      '+853': '🇲🇴',   // Macau
      '+855': '🇰🇭',   // Cambodia
      '+856': '🇱🇦',   // Laos
      '+880': '🇧🇩',   // Bangladesh
      '+886': '🇹🇼',   // Taiwan
      '+960': '🇲🇻',   // Maldives
      '+961': '🇱🇧',   // Lebanon
      '+962': '🇯🇴',   // Jordan
      '+963': '🇸🇾',   // Syria
      '+964': '🇮🇶',   // Iraq
      '+965': '🇰🇼',   // Kuwait
      '+966': '🇸🇦',   // Saudi Arabia
      '+967': '🇾🇪',   // Yemen
      '+968': '🇴🇲',   // Oman
      '+970': '🇵🇸',   // Palestine
      '+971': '🇦🇪',   // UAE
      '+972': '🇮🇱',   // Israel
      '+973': '🇧🇭',   // Bahrain
      '+974': '🇶🇦',   // Qatar
      '+975': '🇧🇹',   // Bhutan
      '+976': '🇲🇳',   // Mongolia
      '+977': '🇳🇵',   // Nepal
      '+992': '🇹🇯',   // Tajikistan
      '+993': '🇹🇲',   // Turkmenistan
      '+994': '🇦🇿',   // Azerbaijan
      '+995': '🇬🇪',   // Georgia
      '+996': '🇰🇬',   // Kyrgyzstan
      '+998': '🇺🇿',   // Uzbekistan
    };

    // Try to match country code (longest match first)
    for (var i = 4; i >= 1; i--) {
      if (cleaned.length >= i) {
        final prefix = cleaned.substring(0, i + 1); // +1 for '+'
        if (countryFlags.containsKey(prefix)) {
          return countryFlags[prefix]!;
        }
      }
    }

    // Default phone icon if no match
    return '📱';
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null) {
      return firstName![0].toUpperCase();
    }
    if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '?';
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as String? ?? json['userId'] as String? ?? '',
      username: json['username'] as String?,
      displayName: json['displayName'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      avatar: json['avatar'] as String?,
      role: ParticipantRole.fromString(json['role'] as String?),
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : DateTime.now(),
      phoneNumber: json['phoneNumber'] as String? ?? json['phone_number'] as String? ?? json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'role': role.name,
      'joinedAt': joinedAt.toIso8601String(),
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [id, username, displayName, firstName, lastName, avatar, role, joinedAt, phoneNumber];
}

@HiveType(typeId: 6)
enum ParticipantRole {
  @HiveField(0)
  owner,
  @HiveField(1)
  admin,
  @HiveField(2)
  member;

  static ParticipantRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'owner':
        return ParticipantRole.owner;
      case 'admin':
        return ParticipantRole.admin;
      default:
        return ParticipantRole.member;
    }
  }
}
