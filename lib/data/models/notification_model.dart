class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;
  final String? type; // rental, order, message

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
    this.type,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? date,
    bool? isRead,
    String? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

