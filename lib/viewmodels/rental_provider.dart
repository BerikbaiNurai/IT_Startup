import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/services/local_database_service.dart';
import '../data/models/chat_message.dart';
import '../data/models/product.dart';
import '../data/models/rental_request.dart';
import '../data/models/review.dart';

class RentalProvider with ChangeNotifier {
  final List<Product> _rentalItems = [];
  final List<RentalRequest> _requests = [];
  final List<ChatMessage> _messages = [];
  final List<Review> _reviews = [];

  List<Product> get rentalItems => _rentalItems;
  List<RentalRequest> get requests => List.unmodifiable(_requests);
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<Review> get reviews => List.unmodifiable(_reviews);

  RentalProvider() {
    _load();
  }

  void addRentalItem(Product product) {
    _rentalItems.add(product);
    unawaited(_save());
    notifyListeners();
  }

  void createRentalRequest({
    required Product product,
    required String renterId,
    required String renterName,
    required int days,
  }) {
    final request = RentalRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: product.id,
      productName: product.name,
      ownerId: product.ownerId,
      renterId: renterId,
      renterName: renterName,
      days: days,
      rentTotal: product.rentPricePerDay * days,
      deposit: product.deposit,
      status: RentalRequestStatus.pending,
      createdAt: DateTime.now(),
    );
    _requests.insert(0, request);
    unawaited(_save());
    notifyListeners();
  }

  List<Product> getRentalsByOwner(String ownerId) {
    return _rentalItems.where((item) => item.ownerId == ownerId).toList();
  }

  void removeRentalItem(String productId) {
    _rentalItems.removeWhere((item) => item.id == productId);
    unawaited(_save());
    notifyListeners();
  }

  List<RentalRequest> getIncomingRequests(String ownerId) {
    return _requests.where((r) => r.ownerId == ownerId).toList();
  }

  List<RentalRequest> getOutgoingRequests(String renterId) {
    return _requests.where((r) => r.renterId == renterId).toList();
  }

  void updateRequestStatus(String requestId, RentalRequestStatus status) {
    final index = _requests.indexWhere((request) => request.id == requestId);
    if (index < 0) return;
    _requests[index] = _requests[index].copyWith(status: status);
    unawaited(_save());
    notifyListeners();
  }

  void sendMessage({
    required String fromUserId,
    required String toUserId,
    required String productId,
    required String text,
  }) {
    final value = text.trim();
    if (value.isEmpty) return;
    _messages.insert(
      0,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: fromUserId,
        toUserId: toUserId,
        productId: productId,
        text: value,
        createdAt: DateTime.now(),
      ),
    );
    unawaited(_save());
    notifyListeners();
  }

  List<ChatMessage> getMessagesForUser(String userId) {
    return _messages
        .where((message) => message.fromUserId == userId || message.toUserId == userId)
        .toList();
  }

  void addReview({
    required String fromUserId,
    required String toUserId,
    required String requestId,
    required double rating,
    String comment = '',
  }) {
    final alreadyExists = _reviews.any(
      (review) => review.requestId == requestId && review.fromUserId == fromUserId,
    );
    if (alreadyExists) return;
    _reviews.insert(
      0,
      Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: fromUserId,
        toUserId: toUserId,
        requestId: requestId,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      ),
    );
    unawaited(_save());
    notifyListeners();
  }

  double getAverageRatingForUser(String userId) {
    final userReviews = _reviews.where((review) => review.toUserId == userId).toList();
    if (userReviews.isEmpty) return 0;
    final total = userReviews.fold<double>(0, (sum, review) => sum + review.rating);
    return total / userReviews.length;
  }

  int getReviewsCountForUser(String userId) {
    return _reviews.where((review) => review.toUserId == userId).length;
  }

  void _load() {
    final rentalsBox = LocalDatabaseService.getBox(LocalDatabaseService.rentalsBox);
    final requestsData = rentalsBox.get('requests');
    if (requestsData is List) {
      _requests
        ..clear()
        ..addAll(
          requestsData.map(
            (item) => RentalRequest.fromMap(Map<dynamic, dynamic>.from(item)),
          ),
        );
    }
    final rentalItemsData = rentalsBox.get('rental_items');
    if (rentalItemsData is List) {
      _rentalItems
        ..clear()
        ..addAll(
          rentalItemsData.map(
            (item) => Product.fromMap(Map<dynamic, dynamic>.from(item)),
          ),
        );
    }

    final chatsBox = LocalDatabaseService.getBox(LocalDatabaseService.chatsBox);
    final messagesData = chatsBox.get('messages');
    if (messagesData is List) {
      _messages
        ..clear()
        ..addAll(
          messagesData.map(
            (item) => ChatMessage.fromMap(Map<dynamic, dynamic>.from(item)),
          ),
        );
    }

    final reviewsBox = LocalDatabaseService.getBox(LocalDatabaseService.reviewsBox);
    final reviewsData = reviewsBox.get('reviews');
    if (reviewsData is List) {
      _reviews
        ..clear()
        ..addAll(
          reviewsData.map(
            (item) => Review.fromMap(Map<dynamic, dynamic>.from(item)),
          ),
        );
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final rentalsBox = LocalDatabaseService.getBox(LocalDatabaseService.rentalsBox);
    await rentalsBox.put('requests', _requests.map((item) => item.toMap()).toList());
    await rentalsBox.put(
      'rental_items',
      _rentalItems.map((item) => item.toMap()).toList(),
    );

    final chatsBox = LocalDatabaseService.getBox(LocalDatabaseService.chatsBox);
    await chatsBox.put('messages', _messages.map((item) => item.toMap()).toList());

    final reviewsBox = LocalDatabaseService.getBox(LocalDatabaseService.reviewsBox);
    await reviewsBox.put('reviews', _reviews.map((item) => item.toMap()).toList());

    await Future.wait([rentalsBox.flush(), chatsBox.flush(), reviewsBox.flush()]);
  }
}

