import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseService {
  static const String productsBox = 'products_box';
  static const String userBox = 'user_box';
  static const String cartBox = 'cart_box';
  static const String notificationsBox = 'notifications_box';
  static const String rentalsBox = 'rentals_box';
  static const String chatsBox = 'chats_box';
  static const String reviewsBox = 'reviews_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(productsBox),
      Hive.openBox(userBox),
      Hive.openBox(cartBox),
      Hive.openBox(notificationsBox),
      Hive.openBox(rentalsBox),
      Hive.openBox(chatsBox),
      Hive.openBox(reviewsBox),
    ]);
  }

  static Box getBox(String boxName) => Hive.box(boxName);
}
