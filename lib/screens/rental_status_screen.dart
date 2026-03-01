import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rental.dart';
import '../services/auth_service.dart';
import '../services/rentals_service.dart';
import '../widgets/custom_button.dart';
import 'rating_screen.dart';
import 'catalog_screen.dart';

class RentalStatusScreen extends StatefulWidget {
  final Rental rental;

  const RentalStatusScreen({super.key, required this.rental});

  @override
  State<RentalStatusScreen> createState() => _RentalStatusScreenState();
}

class _RentalStatusScreenState extends State<RentalStatusScreen> {
  final _rentalsService = RentalsService();
  final _authService = AuthService();
  Rental? _currentRental;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRental();
  }

  void _loadRental() {
    final rental = _rentalsService.getRentalById(widget.rental.id);
    setState(() {
      _currentRental = rental ?? widget.rental;
    });
  }

  Future<void> _completeRental() async {
    setState(() => _isLoading = true);
    
    await _rentalsService.completeRental(_currentRental!.id);
    
    if (mounted) {
      _loadRental();
      setState(() => _isLoading = false);
      
      // Показать экран рейтинга
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingScreen(rental: _currentRental!),
        ),
      );
    }
  }

  String _getStatusText(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return 'Ожидание подтверждения';
      case RentalStatus.active:
        return 'В аренде';
      case RentalStatus.completed:
        return 'Завершено';
      case RentalStatus.cancelled:
        return 'Отменено';
    }
  }

  Color _getStatusColor(RentalStatus status) {
    switch (status) {
      case RentalStatus.pending:
        return Colors.orange;
      case RentalStatus.active:
        return Colors.green;
      case RentalStatus.completed:
        return Colors.blue;
      case RentalStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rental = _currentRental ?? widget.rental;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final isCompleted = rental.status == RentalStatus.completed;
    final isActive = rental.status == RentalStatus.active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус аренды'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(rental.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(rental.status),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : isActive
                                  ? Icons.access_time
                                  : Icons.info,
                          color: _getStatusColor(rental.status),
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getStatusText(rental.status),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(rental.status),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                rental.itemTitle,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Детали аренды',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    label: 'Начало аренды',
                    value: dateFormat.format(rental.startDate),
                    icon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Конец аренды',
                    value: dateFormat.format(rental.endDate),
                    icon: Icons.event,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Стоимость аренды',
                    value: '${rental.totalPrice.toInt()}₽',
                    icon: Icons.payments,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Депозит',
                    value: '${rental.deposit.toInt()}₽',
                    icon: Icons.security,
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${(rental.totalPrice + rental.deposit).toInt()}₽',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'После завершения аренды вы сможете оставить рейтинг владельцу',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isActive)
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
                  text: 'Завершить аренду',
                  onPressed: _isLoading ? null : _completeRental,
                  isLoading: _isLoading,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

