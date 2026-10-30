class Profile {
  final int pk;
  final User user;
  final String name;
  final dynamic activity; // Type is unknown/nullable in JSON
  final dynamic place;    // Type is unknown/nullable in JSON
  final String? picture;
  final String? phoneNumber;
  final String? email;
  final String? bio;
  final String? birthday;
      final String tier;              // "free" | "vip" | "vvp"
  final String tierLabel;
  final DateTime? tierExpiresAt;
  final bool tierAutoRenew;
  final bool isTierActive;

  final bool adsActive;
  final String adsStatus;         // "inactive" | "active"
  final bool adsIsActive;
  final DateTime? adsExpiresAt;
  final bool adsAutoRenew;

  Profile({
    required this.pk,
    required this.user,
    required this.name,
    this.activity,
    this.place,
    this.picture,
    this.phoneNumber,
    this.email,
    this.bio,
    this.birthday,
    required this.tier,
    required this.tierLabel,
    this.tierExpiresAt,
    required this.tierAutoRenew,
    required this.isTierActive,
    required this.adsActive,
    required this.adsStatus,
    required this.adsIsActive,
    this.adsExpiresAt,
    required this.adsAutoRenew,
  });

  // factory Profile.fromJson(Map<String, dynamic> json) {
  //   return Profile(
  //     pk: json['pk'] as int,
  //     user: User.fromJson(json['user'] as Map<String, dynamic>),
  //     name: json['name'] as String? ?? '', 
  //     activity: json['activity'],
  //     place: json['place'],
  //     picture: json['picture'] as String?,
  //     phoneNumber: json['phone_number'] as String?,
  //     email: json['email'] as String?,
  //     bio: json['bio'] as String?,
  //     birthday: json['birthday'] as String?,
  //   );
  // }
  factory Profile.fromJson(Map<String, dynamic> json) {
  final userJson = json['user'];
  return Profile(
    pk: json['pk'] as int? ?? 0,
    user: userJson is Map<String, dynamic>
        ? User.fromJson(userJson)
        : User(username: '', email: ''),
    name: json['name'] as String? ?? '',
    activity: json['activity'],
    place: json['place'],
    picture: json['picture'] as String?,
    phoneNumber: json['phone_number'] as String?,
    email: json['email'] as String?,
    bio: json['bio'] as String?,
    birthday: json['birthday'] as String?,
     tier: json['tier'] ?? 'free',
      tierLabel: json['tier_label'] ?? 'free',
      tierExpiresAt: json['tier_expires_at'] != null
          ? DateTime.tryParse(json['tier_expires_at'])
          : null,
      tierAutoRenew: json['tier_auto_renew'] ?? false,
      isTierActive: json['is_tier_active'] ?? false,
      adsActive: json['ads_active'] ?? false,
      adsStatus: json['ads_status'] ?? 'inactive',
      adsIsActive: json['ads_is_active'] ?? false,
      adsExpiresAt: json['ads_expires_at'] != null
          ? DateTime.tryParse(json['ads_expires_at'])
          : null,
      adsAutoRenew: json['ads_auto_renew'] ?? false,
  );
}



  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'user': user.toJson(),
      'name': name,
      'activity': activity,
      'place': place,
      'picture': picture,
      'phone_number': phoneNumber,
      'email': email,
      'bio': bio,
      'birthday': birthday,
        "tier": tier,
        "tier_label": tierLabel,
        "tier_expires_at": tierExpiresAt?.toIso8601String(),
        "tier_auto_renew": tierAutoRenew,
        "is_tier_active": isTierActive,
        "ads_active": adsActive,
        "ads_status": adsStatus,
        "ads_is_active": adsIsActive,
        "ads_expires_at": adsExpiresAt?.toIso8601String(),
        "ads_auto_renew": adsAutoRenew,
    };
  }

  // Profile copyWith({
  //   int? pk,
  //   User? user,
  //   String? name,
  //   dynamic activity,
  //   dynamic place,
  //   String? picture,
  //   String? phoneNumber,
  //   String? email,
  //   String? bio,
  //   String? birthday,
  //   String? tier,              // "free" | "vip" | "vvp"
  // String tierLabel,
  //  DateTime? tierExpiresAt,
  //  bool tierAutoRenew,
  //  bool isTierActive,

  //  bool adsActive,
  // final String adsStatus;         // "inactive" | "active"
  // final bool adsIsActive;
  // final DateTime? adsExpiresAt;
  // final bool adsAutoRenew;

  // }) {
  //   return Profile(
  //     pk: pk ?? this.pk,
  //     user: user ?? this.user,
  //     name: name ?? this.name,
  //     activity: activity ?? this.activity,
  //     place: place ?? this.place,
  //     picture: picture ?? this.picture,
  //     phoneNumber: phoneNumber ?? this.phoneNumber,
  //     email: email ?? this.email,
  //     bio: bio ?? this.bio,
  //     birthday: birthday ?? this.birthday,

  //   );
  // }
  Profile copyWith({
  int? pk,
  User? user,
  String? name,
  dynamic activity,
  dynamic place,
  String? picture,
  String? phoneNumber,
  String? email,
  String? bio,
  dynamic birthday,          // keep same type as the field
  String? tier,              // "free" | "vip" | "vvp"
  String? tierLabel,
  DateTime? tierExpiresAt,
  bool? tierAutoRenew,
  bool? isTierActive,
  bool? adsActive,
  String? adsStatus,         // "inactive" | "active"
  bool? adsIsActive,
  DateTime? adsExpiresAt,
  bool? adsAutoRenew,
}) {
  return Profile(
    pk: pk ?? this.pk,
    user: user ?? this.user,
    name: name ?? this.name,
    activity: activity ?? this.activity,
    place: place ?? this.place,
    picture: picture ?? this.picture,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
    bio: bio ?? this.bio,
    birthday: birthday ?? this.birthday,
    // ✅ New fields — previously missing
    tier: tier ?? this.tier,
    tierLabel: tierLabel ?? this.tierLabel,
    tierExpiresAt: tierExpiresAt ?? this.tierExpiresAt,
    tierAutoRenew: tierAutoRenew ?? this.tierAutoRenew,
    isTierActive: isTierActive ?? this.isTierActive,
    adsActive: adsActive ?? this.adsActive,
    adsStatus: adsStatus ?? this.adsStatus,
    adsIsActive: adsIsActive ?? this.adsIsActive,
    adsExpiresAt: adsExpiresAt ?? this.adsExpiresAt,
    adsAutoRenew: adsAutoRenew ?? this.adsAutoRenew,
  );
}
}

class User {
  final String username;
  final String email;

  User({
    required this.username,
    required this.email,
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     username: json['username'] as String,
  //     email: json['email'] as String? ?? '',
  //   );
  // }
  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    username: json['username'] as String? ?? '',
    email: json['email'] as String? ?? '',
  );
}

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }

  User copyWith({
    String? username,
    String? email,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }
}