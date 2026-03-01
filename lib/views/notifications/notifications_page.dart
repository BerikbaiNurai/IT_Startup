import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/notification_provider.dart';
import '../../data/models/notification_model.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        actions: [
          if (notificationProvider.unreadCount > 0)
            TextButton(
              onPressed: () {
                notificationProvider.markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Все уведомления прочитаны')),
                );
              },
              child: const Text('Прочитать все'),
            ),
        ],
      ),
      body: notificationProvider.notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет уведомлений',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: notification.isRead ? null : Colors.blue.shade50,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getTypeColor(notification.type),
                      child: Icon(
                        _getTypeIcon(notification.type),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead 
                            ? FontWeight.normal 
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(notification.message),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(notification.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: notification.isRead
                        ? null
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                    onTap: () {
                      if (!notification.isRead) {
                        notificationProvider.markAsRead(notification.id);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }

  Color _getTypeColor(String? type) {
    switch (type) {
      case 'rental':
        return Colors.green;
      case 'order':
        return Colors.blue;
      case 'message':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String? type) {
    switch (type) {
      case 'rental':
        return Icons.shopping_bag;
      case 'order':
        return Icons.receipt;
      case 'message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }
}

