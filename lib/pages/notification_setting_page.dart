import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/services/global_controller.dart';
import 'package:weather_app/services/notification_services.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  String city = '';
  String subcity = '';

  final GlobalController weatherController = Get.put(GlobalController());

  getAddress(lat, lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemark[0];
    setState(() {
      city = place.subAdministrativeArea!;
      subcity = place.locality!;
    });
  }

  @override
  void initState() {
    getAddress(
      weatherController.getLat().value,
      weatherController.getLon().value,
    );
    super.initState();
  }

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
                title: 'Weather in $city, $subcity now',
                body: '',
              );
            },
          ),
        ),
      ),
    );
  }
}
