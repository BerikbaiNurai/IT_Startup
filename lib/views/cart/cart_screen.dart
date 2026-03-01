import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_provider.dart';
import '../../core/utils/format_utils.dart';
import '../../core/constants/app_constants.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Очистить корзину?'),
                    content: const Text('Вы уверены, что хотите удалить все товары?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartProvider.clearCart();
                          Navigator.pop(context);
                        },
                        child: const Text('Очистить'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Корзина пуста',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: item.product.images.isNotEmpty
                                    ? Image.network(
                                        item.product.images.first,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.image_outlined,
                                          color: Colors.grey.shade400,
                                        ),
                                      )
                                    : Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey.shade400,
                                      ),
                              ),
                              const SizedBox(width: 12),

                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      FormatUtils.formatPricePerDay(item.product.price),
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Controls
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        item.product.id,
                                        item.quantity - 1,
                                      );
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      cartProvider.updateQuantity(
                                        item.product.id,
                                        item.quantity + 1,
                                      );
                                    },
                                  ),
                                ],
                              ),

                              // Remove Button
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                                onPressed: () {
                                  cartProvider.removeFromCart(item.product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total and Checkout
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Стоимость аренды',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              FormatUtils.formatPrice(cartProvider.totalPrice),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Депозит',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              FormatUtils.formatPrice(cartProvider.totalDeposit),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Итого',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              FormatUtils.formatPrice(cartProvider.grandTotal),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            },
                            child: const Text('Продолжить'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

