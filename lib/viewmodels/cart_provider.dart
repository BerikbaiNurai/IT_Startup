import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/cart_item.dart';
import '../data/models/product.dart';
import '../core/services/local_database_service.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  CartProvider() {
    _loadCart();
  }

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalDeposit => _items.fold(0.0, (sum, item) => sum + item.totalDeposit);

  double get grandTotal => totalPrice + totalDeposit;

  bool get isEmpty => _items.isEmpty;

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    unawaited(_saveCart());
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    unawaited(_saveCart());
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      unawaited(_saveCart());
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    unawaited(_saveCart());
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void _loadCart() {
    final box = LocalDatabaseService.getBox(LocalDatabaseService.cartBox);
    final stored = box.get('items');
    if (stored is List) {
      _items
        ..clear()
        ..addAll(
          stored.map((e) => CartItem.fromMap(Map<dynamic, dynamic>.from(e))),
        );
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    final box = LocalDatabaseService.getBox(LocalDatabaseService.cartBox);
    await box.put('items', _items.map((e) => e.toMap()).toList());
    await box.flush();
  }
}

