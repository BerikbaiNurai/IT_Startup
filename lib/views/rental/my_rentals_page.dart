import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/rental_provider.dart';
import '../../viewmodels/auth_provider.dart';
import '../../widgets/product_card.dart';
import '../product_detail/product_detail_screen.dart';
import '../add_rental/add_rental_item_page.dart';

class MyRentalsPage extends StatelessWidget {
  const MyRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rentalProvider = Provider.of<RentalProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Пользователь не найден')),
      );
    }

    final myRentals = rentalProvider.getRentalsByOwner(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои аренды'),
      ),
      body: myRentals.isEmpty
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
                    'У вас пока нет товаров для аренды',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddRentalItemPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить товар'),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: myRentals.length,
              itemBuilder: (context, index) {
                final product = myRentals[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

