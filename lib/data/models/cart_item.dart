import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
  double get totalDeposit => product.deposit;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<dynamic, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] as Map<dynamic, dynamic>),
      quantity: (map['quantity'] ?? 1).toInt(),
    );
  }
}

