class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final double rating;
  final int totalRentals;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.rating = 0.0,
    this.totalRentals = 0,
  });
}

