import 'package:flutter/material.dart';
import '../models/rental.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'catalog_screen.dart';

class RatingScreen extends StatefulWidget {
  final Rental rental;

  const RatingScreen({super.key, required this.rental});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double _rating = 5.0;
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    setState(() => _isLoading = true);
    
    // Симуляция отправки рейтинга
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Спасибо за ваш отзыв!'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // Вернуться на главный экран
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CatalogScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оставить отзыв'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              'Как прошла аренда?',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.rental.itemTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Text(
              'Оцените владельца',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 48,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              _rating.toInt().toString(),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Text(
              'Комментарий (необязательно)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hint: 'Оставьте отзыв о владельце...',
              controller: _commentController,
              maxLines: 5,
            ),
            const SizedBox(height: 48),
            CustomButton(
              text: 'Отправить отзыв',
              onPressed: _isLoading ? null : _submitRating,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

