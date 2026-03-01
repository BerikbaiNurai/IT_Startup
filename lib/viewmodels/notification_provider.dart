import 'package:flutter/foundation.dart';
import '../data/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Ваша аренда одобрена',
      message: 'Ваш товар "Камера Sony A6400" был одобрен для аренды',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'rental',
    ),
    NotificationModel(
      id: '2',
      title: 'Новое сообщение',
      message: 'У вас есть новое сообщение от арендатора',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: 'message',
    ),
    NotificationModel(
      id: '3',
      title: 'Ваш товар арендован',
      message: 'Ваш товар "Наушники Sony" был арендован',
      date: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: 'rental',
    ),
  ];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}

