import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart';
import '../../data/models/notification_model.dart';
import '../../viewmodels/rental_provider.dart';
import '../../viewmodels/notification_provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../core/utils/format_utils.dart';
import '../../widgets/custom_button.dart';

class RentalConfirmationPage extends StatefulWidget {
  final Product product;

  const RentalConfirmationPage({super.key, required this.product});

  @override
  State<RentalConfirmationPage> createState() => _RentalConfirmationPageState();
}

class _RentalConfirmationPageState extends State<RentalConfirmationPage> {
  int _days = 1;
  bool _isLoading = false;

  double get _totalRent => widget.product.rentPricePerDay * _days;
  double get _grandTotal => _totalRent + widget.product.deposit;

  Future<void> _confirmRental() async {
    setState(() => _isLoading = true);

    final rentalProvider = Provider.of<RentalProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // final user = authProvider.currentUser;

    await Future.delayed(const Duration(seconds: 1));

    rentalProvider.addUserRental(widget.product);

    notificationProvider.addNotification(
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Аренда подтверждена',
        message: 'Вы арендовали "${widget.product.name}" на $_days ${_days == 1 ? 'день' : 'дней'}',
        date: DateTime.now(),
        type: 'rental',
      ),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Аренда успешно подтверждена!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context); // Go back to product detail
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подтверждение аренды'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: widget.product.images.isNotEmpty
                                ? Image.network(
                                    widget.product.images.first,
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  FormatUtils.formatPricePerDay(widget.product.rentPricePerDay),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Количество дней',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (_days > 1) {
                            setState(() => _days--);
                          }
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_days ${_days == 1 ? 'день' : 'дней'}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => _days++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Аренда ($_days ${_days == 1 ? 'день' : 'дней'})',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                FormatUtils.formatPrice(_totalRent),
                                style: Theme.of(context).textTheme.bodyLarge,
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
                                FormatUtils.formatPrice(widget.product.deposit),
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
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                FormatUtils.formatPrice(_grandTotal),
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
                text: 'Подтвердить аренду',
                onPressed: _isLoading ? null : _confirmRental,
                isLoading: _isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

