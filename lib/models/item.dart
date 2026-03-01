class Item {
  final String id;
  final String title;
  final String description;
  final String category;
  final double pricePerDay;
  final double deposit;
  final String ownerId;
  final String ownerName;
  final double ownerRating;
  final List<String> images;
  final String location;
  final bool isAvailable;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.pricePerDay,
    required this.deposit,
    required this.ownerId,
    required this.ownerName,
    this.ownerRating = 0.0,
    this.images = const [],
    required this.location,
    this.isAvailable = true,
  });
}

