import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/item.dart';
import '../models/rental.dart';
import '../services/auth_service.dart';
import '../services/rentals_service.dart';
import '../widgets/custom_button.dart';
import 'rental_status_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _authService = AuthService();
  final _rentalsService = RentalsService();
  DateTime? _startDate;
  DateTime? _endDate;
  int _days = 0;
  double _totalPrice = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().add(const Duration(days: 1));
    _endDate = DateTime.now().add(const Duration(days: 2));
    _calculatePrice();
  }

  void _calculatePrice() {
    if (_startDate != null && _endDate != null) {
      _days = _endDate!.difference(_startDate!).inDays + 1;
      _totalPrice = widget.item.pricePerDay * _days;
      setState(() {});
    }
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate!.add(const Duration(days: 1));
        }
        _calculatePrice();
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
        _calculatePrice();
      });
    }
  }

  Future<void> _bookItem() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите даты аренды')),
      );
      return;
    }

    final user = _authService.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final rental = await _rentalsService.createRental(
        itemId: widget.item.id,
        itemTitle: widget.item.title,
        renterId: user.id,
        ownerId: widget.item.ownerId,
        startDate: _startDate!,
        endDate: _endDate!,
        totalPrice: _totalPrice,
        deposit: widget.item.deposit,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentalStatusScreen(rental: rental),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали вещи'),
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
                    widget.item.title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.category,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Описание',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.location,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.ownerName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        widget.item.ownerRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Выберите даты аренды',
                    style: Theme.of(context).textTheme.titleLarge,
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
                              border: Border.all(color: Colors.grey),
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
                              border: Border.all(color: Colors.grey),
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
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                              '${_totalPrice.toInt()}₽',
                              style: Theme.of(context).textTheme.titleLarge,
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
                              '${widget.item.deposit.toInt()}₽',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Итого к оплате',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '${(_totalPrice + widget.item.deposit).toInt()}₽',
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
                ],
              ),
            ),
          ),
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
              child: CustomButton(
                text: 'Забронировать',
                onPressed: _isLoading ? null : _bookItem,
                isLoading: _isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

