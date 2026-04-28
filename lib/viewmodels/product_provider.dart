import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/product.dart';
import '../data/mock_data.dart';
import '../core/services/local_database_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _favorites = [];
  String _searchQuery = '';
  String _selectedCategory = 'Все';

  ProductProvider() {
    _loadProducts();
  }

  List<Product> get products => _filteredProducts;
  List<Product> get favorites => _favorites;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Product> get _filteredProducts {
    var filtered = List<Product>.from(_products);

    // Filter by category
    if (_selectedCategory != 'Все') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index >= 0) {
      _products[index] = _products[index].copyWith(
        isFavorite: !_products[index].isFavorite,
      );
      
      if (_products[index].isFavorite) {
        _favorites.add(_products[index]);
      } else {
        _favorites.removeWhere((p) => p.id == productId);
      }
      
      unawaited(_saveProducts());
      notifyListeners();
    }
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getNewProducts() {
    return _products.take(5).toList();
  }

  void addProduct(Product product) {
    _products.insert(0, product);
    unawaited(_saveProducts());
    notifyListeners();
  }

  List<Product> getRentalProducts() {
    return _products.where((p) => p.isRental).toList();
  }

  void _loadProducts() {
    final box = LocalDatabaseService.getBox(LocalDatabaseService.productsBox);
    final stored = box.get('items');

    if (stored is List && stored.isNotEmpty) {
      _products = stored
          .map((e) => Product.fromMap(Map<dynamic, dynamic>.from(e)))
          .toList();
    } else {
      _products = List<Product>.from(MockData.products);
      unawaited(_saveProducts());
    }
    _favorites = _products.where((p) => p.isFavorite).toList();
    notifyListeners();
  }

  Future<void> _saveProducts() async {
    final box = LocalDatabaseService.getBox(LocalDatabaseService.productsBox);
    await box.put('items', _products.map((p) => p.toMap()).toList());
    await box.flush();
  }
}

