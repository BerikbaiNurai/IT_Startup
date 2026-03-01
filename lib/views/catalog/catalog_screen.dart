import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock_data.dart';
import '../../viewmodels/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/category_chip.dart';
import '../product_detail/product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialCategory;

  const CatalogScreen({super.key, this.initialCategory});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false)
            .setCategory(widget.initialCategory!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
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
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        productProvider.setSearchQuery(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Поиск...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.categories.length,
              itemBuilder: (context, index) {
                final category = MockData.categories[index];
                return CategoryChip(
                  label: category,
                  isSelected: productProvider.selectedCategory == category,
                  onTap: () {
                    productProvider.setCategory(category);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Products Grid
          Expanded(
            child: productProvider.products.isEmpty
                ? Center(
                    child: Text(
                      'Товары не найдены',
                      style: TextStyle(color: Colors.grey.shade600),
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
          ),
        ],
      ),
    );
  }
}

