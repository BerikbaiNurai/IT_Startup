enum RentalRequestStatus { pending, approved, declined }

class RentalRequest {
  final String id;
  final String productId;
  final String productName;
  final String ownerId;
  final String renterId;
  final String renterName;
  final int days;
  final double rentTotal;
  final double deposit;
  final RentalRequestStatus status;
  final DateTime createdAt;

  const RentalRequest({
    required this.id,
    required this.productId,
    required this.productName,
    required this.ownerId,
    required this.renterId,
    required this.renterName,
    required this.days,
    required this.rentTotal,
    required this.deposit,
    required this.status,
    required this.createdAt,
  });

  RentalRequest copyWith({
    RentalRequestStatus? status,
  }) {
    return RentalRequest(
      id: id,
      productId: productId,
      productName: productName,
      ownerId: ownerId,
      renterId: renterId,
      renterName: renterName,
      days: days,
      rentTotal: rentTotal,
      deposit: deposit,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'ownerId': ownerId,
      'renterId': renterId,
      'renterName': renterName,
      'days': days,
      'rentTotal': rentTotal,
      'deposit': deposit,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RentalRequest.fromMap(Map<dynamic, dynamic> map) {
    return RentalRequest(
      id: map['id'] ?? '',
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      renterId: map['renterId'] ?? '',
      renterName: map['renterName'] ?? '',
      days: (map['days'] ?? 1).toInt(),
      rentTotal: (map['rentTotal'] ?? 0.0).toDouble(),
      deposit: (map['deposit'] ?? 0.0).toDouble(),
      status: RentalRequestStatus.values.firstWhere(
        (value) => value.name == map['status'],
        orElse: () => RentalRequestStatus.pending,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
