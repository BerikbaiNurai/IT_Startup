import 'package:flutter/foundation.dart';
import '../data/models/product.dart';
import '../data/models/user.dart';

class RentalProvider with ChangeNotifier {
  final List<Product> _rentalItems = [];
  final List<Product> _userRentals = [];

  List<Product> get rentalItems => _rentalItems;
  List<Product> get userRentals => _userRentals;

  void addRentalItem(Product product) {
    _rentalItems.add(product);
    notifyListeners();
  }

  void addUserRental(Product product) {
    _userRentals.add(product);
    notifyListeners();
  }

  List<Product> getRentalsByOwner(String ownerId) {
    return _rentalItems.where((item) => item.ownerId == ownerId).toList();
  }

  void removeRentalItem(String productId) {
    _rentalItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}

