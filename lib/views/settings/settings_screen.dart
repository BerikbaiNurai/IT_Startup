import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Личная информация'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Personal information
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Уведомление'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Notifications settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Языки'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Language selection
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Помощь'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Help
            },
          ),
        ],
      ),
    );
  }
}

