import 'package:flutter/material.dart';
import 'screens/auth_page.dart';
import 'screens/main_navigation_page.dart';
import 'screens/add_transaction_page.dart';
import 'screens/splash_screen.dart';

/// Central route generator that returns MaterialPageRoute for known routes.
/// Keeps routing logic in one place so different Navigators can resolve names.
class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case '/main':
        return MaterialPageRoute(
          builder: (_) => const MainNavigationPage(),
          settings: settings,
        );
      case '/add-transaction':
        return MaterialPageRoute(
          builder: (_) => const AddTransactionPage(),
          settings: settings,
        );
      case '/auth':
        return MaterialPageRoute(
          builder: (_) => const AuthPage(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
