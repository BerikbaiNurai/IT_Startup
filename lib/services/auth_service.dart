import '../models/user.dart';

class AuthService {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String email, String password) async {
    // Симуляция входа
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(
        id: '1',
        email: email,
        name: email.split('@')[0],
        rating: 4.5,
        totalRentals: 5,
      );
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    // Симуляция регистрации
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        rating: 0.0,
        totalRentals: 0,
      );
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
  }
}

