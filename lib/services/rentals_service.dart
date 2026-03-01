import '../models/rental.dart';

class RentalsService {
  static final List<Rental> _rentals = [];

  List<Rental> getUserRentals(String userId) {
    return _rentals.where((rental) => 
      rental.renterId == userId || rental.ownerId == userId
    ).toList();
  }

  Rental? getRentalById(String id) {
    try {
      return _rentals.firstWhere((rental) => rental.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Rental> createRental({
    required String itemId,
    required String itemTitle,
    required String renterId,
    required String ownerId,
    required DateTime startDate,
    required DateTime endDate,
    required double totalPrice,
    required double deposit,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final rental = Rental(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: itemId,
      itemTitle: itemTitle,
      renterId: renterId,
      ownerId: ownerId,
      startDate: startDate,
      endDate: endDate,
      totalPrice: totalPrice,
      deposit: deposit,
      status: RentalStatus.active,
      createdAt: DateTime.now(),
    );
    
    _rentals.add(rental);
    return rental;
  }

  Future<void> completeRental(String rentalId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _rentals.indexWhere((r) => r.id == rentalId);
    if (index != -1) {
      final rental = _rentals[index];
      _rentals[index] = Rental(
        id: rental.id,
        itemId: rental.itemId,
        itemTitle: rental.itemTitle,
        renterId: rental.renterId,
        ownerId: rental.ownerId,
        startDate: rental.startDate,
        endDate: rental.endDate,
        totalPrice: rental.totalPrice,
        deposit: rental.deposit,
        status: RentalStatus.completed,
        createdAt: rental.createdAt,
      );
    }
  }
}

