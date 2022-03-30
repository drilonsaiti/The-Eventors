final String tableUser = 'user';

class UserFields {
  static final List<String> values = [id, username, email, password, images];

  static final String id = "_id";
  static final String username = "username";
  static final String email = "email";
  static final String password = "password";
  static final String images = "images";
}

class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String? images;
  const User(
      {this.id,
      required this.username,
      required this.email,
      required this.password,
      this.images});

  User copy({
    int? id,
    String? username,
    String? email,
    String? password,
    String? images,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        images: images ?? this.images,
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.email: email,
        UserFields.password: password,
        UserFields.images: images
      };

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int?,
        username: json[UserFields.username] as String,
        email: json[UserFields.email] as String,
        password: json[UserFields.password] as String,
        images: json[UserFields.images] as String,
      );
}
