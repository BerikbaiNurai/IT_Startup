import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import 'catalog_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success;
    if (_isLogin) {
      success = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      success = await _authService.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CatalogScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin 
            ? 'Ошибка входа. Проверьте данные.'
            : 'Ошибка регистрации. Попробуйте снова.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Icon(
                  Icons.handshake,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  _isLogin ? 'Вход' : 'Регистрация',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  label: 'Email',
                  hint: 'Введите email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (!_isLogin) ...[
                  CustomTextField(
                    label: 'Имя',
                    hint: 'Введите ваше имя',
                    controller: _nameController,
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите имя';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                CustomTextField(
                  label: 'Пароль',
                  hint: 'Введите пароль',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: _isLogin ? 'Войти' : 'Зарегистрироваться',
                  onPressed: _isLoading ? null : _handleAuth,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _formKey.currentState?.reset();
                    });
                  },
                  child: Text(
                    _isLogin 
                      ? 'Нет аккаунта? Зарегистрироваться'
                      : 'Уже есть аккаунт? Войти',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

