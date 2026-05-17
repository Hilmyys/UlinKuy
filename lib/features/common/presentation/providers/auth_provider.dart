import 'package:flutter/foundation.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/datasources/local/database_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // Fallback users for Web
  final List<User> _webUsers = [
    User(
      id: '1',
      name: 'Hilmi',
      email: 'hilmi@ulinkuy.com',
      password: 'password123',
      avatarUrl: 'https://i.pravatar.cc/150?u=hilmi',
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
    if (kIsWeb) {
      // Logic for Web (In-memory)
      try {
        final user = _webUsers.firstWhere(
          (u) => u.email == email && u.password == password,
        );
        _currentUser = user;
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } catch (e) {
        return false;
      }
    } else {
      // Logic for Mobile (SQLite)
      final userMap = await DatabaseHelper.instance.getUser(email, password);
      
      if (userMap != null) {
        _currentUser = User(
          id: userMap['id'],
          name: userMap['name'],
          email: userMap['email'],
          password: userMap['password'],
          avatarUrl: userMap['avatarUrl'],
          role: userMap['role'] == 'admin' ? UserRole.admin : UserRole.user,
        );
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> checkEmailExists(String email) async {
    if (kIsWeb) {
      return _webUsers.any((u) => u.email == email);
    } else {
      return await DatabaseHelper.instance.checkEmailExists(email);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    if (kIsWeb) {
      // Logic for Web
      if (_webUsers.any((u) => u.email == email)) return false;
      
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
        avatarUrl: 'https://i.pravatar.cc/150?u=$name',
      );
      _webUsers.add(newUser);
      return await login(email, password);
    } else {
      // Logic for Mobile
      final newUser = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'password': password,
        'avatarUrl': 'https://i.pravatar.cc/150?u=$name',
        'role': 'user',
      };

      try {
        await DatabaseHelper.instance.insertUser(newUser);
        return await login(email, password);
      } catch (e) {
        return false;
      }
    }
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String email, String? avatarUrl) async {
    if (_currentUser == null) return;

    final updatedUser = User(
      id: _currentUser!.id,
      name: name,
      email: email,
      password: _currentUser!.password,
      avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
      role: _currentUser!.role,
    );

    if (kIsWeb) {
      final index = _webUsers.indexWhere((u) => u.id == _currentUser!.id);
      if (index != -1) {
        _webUsers[index] = updatedUser;
      }
    } else {
      await DatabaseHelper.instance.insertUser({
        'id': updatedUser.id,
        'name': updatedUser.name,
        'email': updatedUser.email,
        'password': updatedUser.password,
        'avatarUrl': updatedUser.avatarUrl,
        'role': updatedUser.role == UserRole.admin ? 'admin' : 'user',
      });
    }

    _currentUser = updatedUser;
    notifyListeners();
  }
}
