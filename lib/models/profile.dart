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
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      pk: json['pk'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      name: json['name'] as String? ?? '', 
      activity: json['activity'],
      place: json['place'],
      picture: json['picture'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      bio: json['bio'] as String?,
      birthday: json['birthday'] as String?,
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
    };
  }

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
    String? birthday,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
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