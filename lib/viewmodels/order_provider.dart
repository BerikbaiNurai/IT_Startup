import 'package:flutter/foundation.dart';
import '../data/models/order.dart';
import '../data/models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<Order> createOrder({
    required List<CartItem> items,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final orderItems = items.map((cartItem) {
      return OrderItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        productImage: cartItem.product.images.isNotEmpty 
            ? cartItem.product.images.first 
            : '',
        price: cartItem.product.price,
        quantity: cartItem.quantity,
      );
    }).toList();

    final totalPrice = items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
    final totalDeposit = items.fold<double>(0.0, (sum, item) => sum + item.totalDeposit);

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: orderItems,
      totalPrice: totalPrice,
      totalDeposit: totalDeposit,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      startDate: startDate,
      endDate: endDate,
    );

    _orders.insert(0, order);
    notifyListeners();

    return order;
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}

