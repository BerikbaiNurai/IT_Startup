class Rating {
  final String id;
  final String rentalId;
  final String fromUserId;
  final String toUserId;
  final double score;
  final String? comment;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.rentalId,
    required this.fromUserId,
    required this.toUserId,
    required this.score,
    this.comment,
    required this.createdAt,
  });
}

