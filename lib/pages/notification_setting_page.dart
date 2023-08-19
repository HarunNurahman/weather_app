import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/services/notification_services.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Center(
        child: Center(
          child: ElevatedButton(
            child: const Text('Show notifications'),
            onPressed: () {
              NotificationService().showNotification(
                title: 'Sample title',
                body: 'It works!',
              );
            },
          ),
        ),
      ),
    );
  }
}
