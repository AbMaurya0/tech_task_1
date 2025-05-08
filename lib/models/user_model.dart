class UserResponse {
  final List<User> data;

  UserResponse({required this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      data: (json['data'] as List).map((e) => User.fromJson(e)).toList(),
    );
  }
}

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}
