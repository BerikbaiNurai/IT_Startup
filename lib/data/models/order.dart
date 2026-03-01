import 'package:intl/intl.dart';

enum OrderStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalPrice;
  final double totalDeposit;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.totalDeposit,
    required this.status,
    required this.createdAt,
    this.startDate,
    this.endDate,
  });

  double get grandTotal => totalPrice + totalDeposit;

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Ожидание';
      case OrderStatus.confirmed:
        return 'Подтверждено';
      case OrderStatus.inProgress:
        return 'В аренде';
      case OrderStatus.completed:
        return 'Завершено';
      case OrderStatus.cancelled:
        return 'Отменено';
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}

