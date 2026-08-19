import 'package:flutter/material.dart';
import 'package:smart_book/features/auth/auth_exports.dart';

import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );

      case AppRoutes.main:
      // استبدلها بشاشتك الرئيسية الفعليّة (مثل HomeScreen أو MainScreen)
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Main Screen')),
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}