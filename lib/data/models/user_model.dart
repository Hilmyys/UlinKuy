enum UserRole { admin, user }

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;
  final UserRole role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.role = UserRole.user,
  });
}
