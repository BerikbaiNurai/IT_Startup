enum RentalStatus {
  pending,
  active,
  completed,
  cancelled,
}

class Rental {
  final String id;
  final String itemId;
  final String itemTitle;
  final String renterId;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final double deposit;
  final RentalStatus status;
  final DateTime createdAt;

  Rental({
    required this.id,
    required this.itemId,
    required this.itemTitle,
    required this.renterId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.deposit,
    required this.status,
    required this.createdAt,
  });
}

