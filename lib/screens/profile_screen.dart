import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/rentals_service.dart';
import '../widgets/custom_button.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final rentalsService = RentalsService();
    final user = authService.currentUser;
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Пользователь не найден')),
      );
    }

    final userRentals = rentalsService.getUserRentals(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                'Рейтинг: ${user.rating.toStringAsFixed(1)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Статистика',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            userRentals.length.toString(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Аренд',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            user.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Рейтинг',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Настройки',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Имя'),
                    subtitle: Text(user.name),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Функция в разработке')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Функция в разработке')),
                      );
                    },
                  ),
                  if (user.phone != null) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Телефон'),
                      subtitle: Text(user.phone!),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Функция в разработке')),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Выйти',
              backgroundColor: Colors.red,
              onPressed: () {
                authService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

