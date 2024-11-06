import 'package:flutter/material.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/presentation/route.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/services/signalr_service.dart';

void main() {
  final signalRService = SignalRService();
  runApp(MainApp(signalRService: signalRService)); // Remove `const` here
}

class MainApp extends StatelessWidget {
  final SignalRService signalRService;

  const MainApp({super.key, required this.signalRService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes(signalRService: signalRService).generateRoute,
      initialRoute: AppRoutes.login,
    );
  }
}
