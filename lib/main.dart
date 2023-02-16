import 'package:flutter/material.dart';
import 'package:weather_app/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      home: DashboardPage(),
    );
  }
}
