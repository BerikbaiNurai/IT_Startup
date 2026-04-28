import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/user.dart';
import '../core/services/local_database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUser();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final box = LocalDatabaseService.getBox(LocalDatabaseService.userBox);
    final users = _readUsers(box);
    final passwords = _readPasswords(box);
    final index = users.indexWhere((user) => user.email.toLowerCase() == email.toLowerCase());

    if (index >= 0 && passwords[users[index].id] == password) {
      _currentUser = users[index];
      unawaited(_saveUser());
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      final box = LocalDatabaseService.getBox(LocalDatabaseService.userBox);
      final users = _readUsers(box);
      final passwords = _readPasswords(box);
      final emailExists = users.any((user) => user.email.toLowerCase() == email.toLowerCase());
      if (emailExists) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        rating: 0.0,
        totalOrders: 0,
      );
      users.add(_currentUser!);
      passwords[_currentUser!.id] = password;
      unawaited(
        Future.wait([
          box.put('users', users.map((user) => user.toMap()).toList()),
          box.put('passwords', passwords),
          _saveUser(),
          box.flush(),
        ]),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser = null;
    final box = LocalDatabaseService.getBox(LocalDatabaseService.userBox);
    box.delete('current_user');
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    unawaited(_saveUser());
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? bio,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        avatarUrl: avatarUrl,
        bio: bio,
      );
      unawaited(_saveUser());
      notifyListeners();
    }
  }

  void _loadUser() {
    final box = LocalDatabaseService.getBox(LocalDatabaseService.userBox);
    final stored = box.get('current_user');
    if (stored is Map) {
      _currentUser = User.fromMap(Map<dynamic, dynamic>.from(stored));
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  List<User> _readUsers(dynamic box) {
    final usersRaw = box.get('users');
    if (usersRaw is! List) return [];
    return usersRaw
        .map((entry) => User.fromMap(Map<dynamic, dynamic>.from(entry)))
        .toList();
  }

  Map<String, String> _readPasswords(dynamic box) {
    final raw = box.get('passwords');
    if (raw is! Map) return <String, String>{};
    return raw.map((key, value) => MapEntry(key.toString(), value.toString()));
  }

  Future<void> _saveUser() async {
    if (_currentUser == null) return;
    final box = LocalDatabaseService.getBox(LocalDatabaseService.userBox);
    await box.put('current_user', _currentUser!.toMap());
    await box.flush();
  }
}

