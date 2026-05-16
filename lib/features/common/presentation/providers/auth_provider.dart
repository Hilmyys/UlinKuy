import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // Mock user database
  final List<User> _users = [
    User(
      id: '1',
      name: 'Hilmi',
      email: 'hilmi@ulinkuy.com',
      password: 'password123',
      avatarUrl: 'https://i.pravatar.cc/150?u=hilmi',
      role: UserRole.user,
    ),
    User(
      id: '2',
      name: 'Admin UlinKuy',
      email: 'admin@ulinkuy.com',
      password: 'admin123',
      avatarUrl: 'https://i.pravatar.cc/150?u=admin',
      role: UserRole.admin,
    ),
  ];

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_users.any((u) => u.email == email)) {
      return false;
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      avatarUrl: 'https://i.pravatar.cc/150?u=$name',
    );

    _users.add(newUser);
    _currentUser = newUser;
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
