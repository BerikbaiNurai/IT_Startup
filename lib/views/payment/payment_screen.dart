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
  int? _selectedCardIndex = 0;
  late final List<_SavedCard> _savedCards;

  @override
  void initState() {
    super.initState();
    _savedCards = [
      const _SavedCard(
        holderName: 'TrustRent User',
        cardNumber: '4111111111111234',
        expiry: '12/28',
      ),
      const _SavedCard(
        holderName: 'TrustRent User',
        cardNumber: '5555555555559876',
        expiry: '09/27',
      ),
    ];
    _fillFormFromSelectedCard();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _fillFormFromSelectedCard() {
    if (_selectedCardIndex == null) return;
    final card = _savedCards[_selectedCardIndex!];
    _cardNumberController.text = card.cardNumber;
    _cardholderNameController.text = card.holderName;
    _expiryController.text = card.expiry;
    _cvvController.clear();
  }

  void _onCardFormChanged() {
    if (_selectedCardIndex != null) {
      setState(() => _selectedCardIndex = null);
    }
  }

  Future<void> _processPayment() async {
    final hasSelectedCard = _selectedCardIndex != null;
    final hasNewCardData = _cardNumberController.text.trim().isNotEmpty ||
        _cardholderNameController.text.trim().isNotEmpty ||
        _expiryController.text.trim().isNotEmpty ||
        _cvvController.text.trim().isNotEmpty;

    if (!hasSelectedCard && !hasNewCardData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите карту или введите новую')),
      );
      return;
    }
    if (!hasSelectedCard &&
        (_cardNumberController.text.trim().isEmpty ||
            _cardholderNameController.text.trim().isEmpty ||
            _expiryController.text.trim().isEmpty ||
            _cvvController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля новой карты')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    await Future.delayed(const Duration(seconds: 2));

    if (!hasSelectedCard) {
      _savedCards.insert(
        0,
        _SavedCard(
          holderName: _cardholderNameController.text.trim(),
          cardNumber: _cardNumberController.text.trim(),
          expiry: _expiryController.text.trim(),
        ),
      );
      _selectedCardIndex = null;
    }

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
                  Text(
                    'Выберите карту',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_savedCards.length, (index) {
                    final card = _savedCards[index];
                    return Card(
                      child: RadioListTile<int>(
                        value: index,
                        groupValue: _selectedCardIndex,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCardIndex = value;
                            _fillFormFromSelectedCard();
                          });
                        },
                        title: Text(card.masked),
                        subtitle: Text('${card.holderName}  •  ${card.expiry}'),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Card Form
                  Text(
                    'Добавить новую карту (опционально)',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _cardNumberController,
                    onChanged: (_) => _onCardFormChanged(),
                    decoration: const InputDecoration(
                      labelText: 'Номер карты',
                      hintText: '1234 5678 9012 3456',
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _cardholderNameController,
                    onChanged: (_) => _onCardFormChanged(),
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
                          onChanged: (_) => _onCardFormChanged(),
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
                          onChanged: (_) => _onCardFormChanged(),
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

class _SavedCard {
  final String holderName;
  final String cardNumber;
  final String expiry;

  const _SavedCard({
    required this.holderName,
    required this.cardNumber,
    required this.expiry,
  });

  String get masked {
    final value = cardNumber.replaceAll(' ', '');
    if (value.length < 4) return '****';
    return '**** **** **** ${value.substring(value.length - 4)}';
  }
}

