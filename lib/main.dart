import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/pages/dashboard_page.dart';
import 'package:weather_app/services/notification_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}
