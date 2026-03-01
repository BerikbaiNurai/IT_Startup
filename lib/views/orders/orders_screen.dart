import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/order_provider.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Заказы'),
      ),
      body: orderProvider.orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет заказов',
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
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                final dateFormat = DateFormat('dd.MM.yyyy');

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getStatusIcon(order.status),
                        color: _getStatusColor(order.status),
                      ),
                    ),
                    title: Text(
                      'Заказ #${order.id.substring(0, 8)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${dateFormat.format(order.createdAt)} • ${order.statusText}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Text(
                      FormatUtils.formatPrice(order.grandTotal),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...order.items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: item.productImage.isNotEmpty
                                          ? Image.network(
                                              item.productImage,
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                          Text(
                                            'Количество: ${item.quantity}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      FormatUtils.formatPrice(item.total),
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Итого',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  FormatUtils.formatPrice(order.grandTotal),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Colors.green;
      case OrderStatus.inProgress:
        return Colors.blue;
      case OrderStatus.completed:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.inProgress:
        return Icons.access_time;
      case OrderStatus.completed:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.pending:
        return Icons.pending;
    }
  }
}

