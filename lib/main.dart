import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/auth_provider.dart';
import 'viewmodels/cart_provider.dart';
import 'viewmodels/product_provider.dart';
import 'viewmodels/order_provider.dart';
import 'viewmodels/rental_provider.dart';
import 'viewmodels/notification_provider.dart';
import 'views/main_screen.dart';
import 'views/auth/auth_screen.dart';

void main() {
  runApp(const TrustRentApp());
}

class TrustRentApp extends StatelessWidget {
  const TrustRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => RentalProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'TrustRent',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const MainScreen();
            }
            return const AuthScreen();
          },
        ),
      ),
    );
  }
}
