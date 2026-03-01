import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/cart_provider.dart';
import '../../viewmodels/order_provider.dart';
import '../../core/utils/format_utils.dart';
import '../order_success/order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const PaymentScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _cardholderNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_cardNumberController.text.isEmpty ||
        _cardholderNameController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await Future.delayed(const Duration(seconds: 2));

    final order = await orderProvider.createOrder(
      items: cartProvider.items,
      startDate: widget.startDate,
      endDate: widget.endDate,
    );

    cartProvider.clearCart();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(orderId: order.id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Способы оплаты'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Cards Preview
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '**** **** **** 1234',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Берикбай Нурай',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    '09/25',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.add, size: 32),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Card Form
                  Text(
                    'Добавить карточку',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Номер карты',
                      hintText: '1234 5678 9012 3456',
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _cardholderNameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя пользователя',
                      hintText: 'Берикбай Нурай',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryController,
                          decoration: const InputDecoration(
                            labelText: 'Дата срока',
                            hintText: 'MM/YY',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            hintText: '123',
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Scan card functionality
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Сканировать карту'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Итого к оплате',
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

          // Confirm Payment Button
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
                  onPressed: _isLoading ? null : _processPayment,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Подтвердить оплату'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

