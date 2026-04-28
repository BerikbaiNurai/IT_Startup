class Product {
  final String id;
  final String name;
  final String description;
  final double price; // Buy price
  final double rentPricePerDay; // Rent price per day
  final double deposit;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String category;
  final String ownerId;
  final String ownerName;
  final double ownerRating;
  final String location;
  final bool isFavorite;
  final bool isRental; // Can be rented
  final String condition; // New, Good, Used

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rentPricePerDay,
    required this.deposit,
    this.images = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.category,
    required this.ownerId,
    required this.ownerName,
    this.ownerRating = 0.0,
    required this.location,
    this.isFavorite = false,
    this.isRental = true,
    this.condition = 'Good',
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rentPricePerDay,
    double? deposit,
    List<String>? images,
    double? rating,
    int? reviewCount,
    String? category,
    String? ownerId,
    String? ownerName,
    double? ownerRating,
    String? location,
    bool? isFavorite,
    bool? isRental,
    String? condition,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rentPricePerDay: rentPricePerDay ?? this.rentPricePerDay,
      deposit: deposit ?? this.deposit,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerRating: ownerRating ?? this.ownerRating,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      isRental: isRental ?? this.isRental,
      condition: condition ?? this.condition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'rentPricePerDay': rentPricePerDay,
      'deposit': deposit,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerRating': ownerRating,
      'location': location,
      'isFavorite': isFavorite,
      'isRental': isRental,
      'condition': condition,
    };
  }

  factory Product.fromMap(Map<dynamic, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      rentPricePerDay: (map['rentPricePerDay'] ?? 0).toDouble(),
      deposit: (map['deposit'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? const []),
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: (map['reviewCount'] ?? 0).toInt(),
      category: map['category'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerName: map['ownerName'] ?? '',
      ownerRating: (map['ownerRating'] ?? 0).toDouble(),
      location: map['location'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      isRental: map['isRental'] ?? true,
      condition: map['condition'] ?? 'Good',
    );
  }
}

