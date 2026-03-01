import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/items_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import 'item_detail_screen.dart';
import 'profile_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();
  final _itemsService = ItemsService();
  final _authService = AuthService();
  List<Item> _items = [];
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadItems() {
    setState(() {
      _items = _itemsService.getAllItems();
      _filteredItems = _items;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _filteredItems = _itemsService.searchItems(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrustRent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              hint: 'Поиск вещей...',
              controller: _searchController,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Нет доступных вещей'
                          : 'Ничего не найдено',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _ItemCard(item: item);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Item item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.category,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${item.pricePerDay.toInt()}₽/день',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.location,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.ownerRating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.ownerName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

