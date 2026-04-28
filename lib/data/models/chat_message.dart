class ChatMessage {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String productId;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.productId,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'productId': productId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      productId: map['productId'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
