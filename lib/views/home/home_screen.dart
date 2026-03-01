import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../viewmodels/product_provider.dart';
import '../../viewmodels/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import '../catalog/catalog_screen.dart';
import '../product_detail/product_detail_screen.dart';
import '../search/search_screen.dart';
import '../add_rental/add_rental_item_page.dart';
import '../rental/my_rentals_page.dart';
import '../orders/orders_screen.dart';
import '../notifications/notifications_page.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';
import '../../viewmodels/auth_provider.dart';
import '../../viewmodels/notification_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              final unreadCount = notificationProvider.unreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 9 ? '9+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 12),
                      Text(
                        'Поиск...',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -20,
                      child: Icon(
                        Icons.laptop,
                        size: 200,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Арендуй все что хочешь',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
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

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Категории',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: MockData.categories.length,
                      itemBuilder: (context, index) {
                        final category = MockData.categories[index];
                        return CategoryChip(
                          label: category,
                          isSelected: productProvider.selectedCategory == category,
                          onTap: () {
                            productProvider.setCategory(category);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CatalogScreen(initialCategory: category),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // New Products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Новые товары',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CatalogScreen()),
                          );
                        },
                        child: const Text('Все'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productProvider.getNewProducts().length,
                      itemBuilder: (context, index) {
                        final product = productProvider.getNewProducts()[index];
                        return SizedBox(
                          width: 180,
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(productId: product.id),
                                ),
                              );
                            },
                            onFavoriteTap: () {
                              productProvider.toggleFavorite(product.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // All Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Все товары',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
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
                        onFavoriteTap: () {
                          productProvider.toggleFavorite(product.id);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
                  child: user?.avatarUrl == null
                      ? Text(
                          (user?.name.isNotEmpty == true ? user!.name[0] : 'U').toUpperCase(),
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  user?.name ?? 'Пользователь',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главная'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Мои аренды'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MyRentalsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Добавить товар для аренды'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRentalItemPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Заказы'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Уведомления'),
            trailing: Consumer<NotificationProvider>(
              builder: (context, notificationProvider, _) {
                final unreadCount = notificationProvider.unreadCount;
                if (unreadCount <= 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Выйти', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Выйти?'),
                  content: const Text('Вы уверены, что хотите выйти?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        authProvider.logout();
                        Navigator.pop(context);
                      },
                      child: const Text('Выйти'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

