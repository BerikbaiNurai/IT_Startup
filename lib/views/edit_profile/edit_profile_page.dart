import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _avatarUrlController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _avatarUrlController = TextEditingController(text: user?.avatarUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty 
          ? null 
          : _phoneController.text.trim(),
      bio: _bioController.text.trim().isEmpty 
          ? null 
          : _bioController.text.trim(),
      avatarUrl: _avatarUrlController.text.trim().isEmpty 
          ? null 
          : _avatarUrlController.text.trim(),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Профиль успешно обновлен!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Preview
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: _avatarUrlController.text.isNotEmpty
                          ? NetworkImage(_avatarUrlController.text)
                          : null,
                      child: _avatarUrlController.text.isEmpty
                          ? Text(
                              (_nameController.text.isNotEmpty
                                      ? _nameController.text[0]
                                      : 'U')
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'URL аватара',
                hint: 'https://images.unsplash.com/...',
                controller: _avatarUrlController,
                keyboardType: TextInputType.url,
                prefixIcon: const Icon(Icons.image),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Имя',
                hint: 'Введите имя',
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
              CustomTextField(
                label: 'Телефон',
                hint: '+7 777 123 4567',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'О себе',
                hint: 'Расскажите о себе',
                controller: _bioController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Сохранить',
                onPressed: _isLoading ? null : _saveProfile,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

