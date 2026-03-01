import '../constants/app_constants.dart';

class FormatUtils {
  static String formatPrice(double price) {
    return '${price.toInt()} ${AppConstants.currency}';
  }
  
  static String formatPricePerDay(double price) {
    return '${price.toInt()} ${AppConstants.currency}/день';
  }
  
  static String formatCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last4';
  }
}

