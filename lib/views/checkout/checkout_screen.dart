import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/cart_provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../core/utils/format_utils.dart';
import '../payment/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate!.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Проверка'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Пользователь',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user?.name ?? 'Не указано',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Payment Method Preview
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Способ оплаты',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.credit_card, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text(
                                'Master Card ending **',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Даты аренды',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: _selectStartDate,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Начало',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _startDate != null
                                              ? dateFormat.format(_startDate!)
                                              : 'Выберите дату',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: _selectEndDate,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Конец',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _endDate != null
                                              ? dateFormat.format(_endDate!)
                                              : 'Выберите дату',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Order Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Детали заказа',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ...cartProvider.items.map((item) {
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
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                        Text(
                                          'Количество: ${item.quantity}',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
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
                                style: Theme.of(context).textTheme.titleLarge,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Place Order Button
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startDate != null && _endDate != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                startDate: _startDate!,
                                endDate: _endDate!,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Place order'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

