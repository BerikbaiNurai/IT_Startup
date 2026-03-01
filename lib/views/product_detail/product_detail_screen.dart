import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/product_provider.dart';
import '../../viewmodels/cart_provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../core/utils/format_utils.dart';
import '../../core/constants/app_constants.dart';
import '../rental/rental_confirmation_page.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final product = productProvider.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Товар не найден')),
        body: const Center(child: Text('Товар не найден')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              productProvider.toggleFavorite(product.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: product.images.isNotEmpty
                        ? Image.network(
                            product.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),

                        // Rating
                        Row(
                          children: [
                            Icon(Icons.star, size: 20, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating.toStringAsFixed(1)} (${product.reviewCount} отзывов)',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Prices
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Покупка',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  FormatUtils.formatPrice(product.price),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Аренда/день',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  FormatUtils.formatPricePerDay(product.rentPricePerDay),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Deposit
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.security, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Депозит: ${FormatUtils.formatPrice(product.deposit)} (блокируется)',
                                  style: TextStyle(color: Colors.blue.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          'Описание',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),

                        // Owner Info
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Text(
                                  product.ownerName[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.ownerName,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 16, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text('${product.ownerRating.toStringAsFixed(1)}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.location_on, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(product.location),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (product.isRental)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RentalConfirmationPage(product: product),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text('Арендовать сейчас'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (product.isRental) const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        cartProvider.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Товар добавлен в корзину'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Добавить в корзину'),
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

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 80,
        color: Colors.grey.shade400,
      ),
    );
  }
}

