import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Dashboard Page',
          style: blackTextStyle.copyWith(
            fontWeight: regular,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
