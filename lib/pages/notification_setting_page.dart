import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/services/global_controller.dart';
import 'package:weather_app/services/notification_services.dart';

DateTime? scheduleTime = DateTime.now();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Show notifications'),
              onPressed: () {
                NotificationService().showNotification(
                  title: '$city, $subcity',
                  body:
                      '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()}: ${weatherController.getData().current!.current.temp}°C',
                );
              },
            ),
            DateTimePickerText(),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Scheduled Notification'),
              onPressed: () {
                debugPrint('Notification Scheduled for $scheduleTime');
                NotificationService().scheduledNotification(
                  title: '',
                  body: '$scheduleTime',
                  scheduledNotificationDateTime: scheduleTime!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimePickerText extends StatefulWidget {
  const DateTimePickerText({super.key});

  @override
  State<DateTimePickerText> createState() => _DateTimePickerTextState();
}

class _DateTimePickerTextState extends State<DateTimePickerText> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (dateTime) => scheduleTime = dateTime,
          onConfirm: (dateTime) {},
        );
      },
      child: Text(
        'Select Date & Time',
        style: whiteTextStyle.copyWith(
          color: blueColor,
        ),
      ),
    );
  }
}
