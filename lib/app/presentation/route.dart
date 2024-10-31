import 'package:flutter/material.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/presentation/pages/login_pages/login_page.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/presentation/pages/home_pages/home_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => SafeArea(child: LoginPage()));
      case home:
        return MaterialPageRoute(builder: (_) => SafeArea(child: HomePage()));
      default:
        return MaterialPageRoute(
            builder: (_) => SafeArea(
                  child: Scaffold(
                    body: Center(
                      child: Text('No route defined for ${settings.name}'),
                    ),
                  ),
                ));
    }
  }
}
