import 'package:flutter/foundation.dart';
import '../data/models/product.dart';
import '../data/mock_data.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = MockData.products;
  List<Product> _favorites = [];
  String _searchQuery = '';
  String _selectedCategory = 'Все';

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
    notifyListeners();
  }

  List<Product> getRentalProducts() {
    return _products.where((p) => p.isRental).toList();
  }
}

