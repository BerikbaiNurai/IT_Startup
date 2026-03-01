class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final double rating;
  final int totalOrders;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    this.rating = 0.0,
    this.totalOrders = 0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? bio,
    double? rating,
    int? totalOrders,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
    );
  }
}

