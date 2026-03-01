import 'package:flutter/foundation.dart';
import '../data/models/user.dart';
import '../data/mock_data.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Auto login for demo
    _currentUser = MockData.currentUser;
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = MockData.currentUser;
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
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        rating: 0.0,
        totalOrders: 0,
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
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
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
      notifyListeners();
    }
  }
}

