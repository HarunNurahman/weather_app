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
  final TextEditingController dateTimeController = TextEditingController();

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
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 16,
            color: whiteColor,
          ),
        ),
        title: Text(
          'Notification Setting',
          style: whiteTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: blackColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultVerticalMargin),
        children: [
          const SizedBox(height: 30),
          TextFormField(
            showCursor: false,
            readOnly: true,
            onTap: () {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                onChanged: (dateTime) => scheduleTime = dateTime,
                onConfirm: (dateTime) {
                  debugPrint('Notification Scheduled for $scheduleTime');
                  NotificationService().scheduledNotification(
                    title:
                        'Weather $city at ${scheduleTime!.hour}:${scheduleTime!.minute}',
                    body:
                        '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()}: ${weatherController.getData().current!.current.temp}°C/${weatherController.getData().daily!.daily[0].temp!.max}°C',
                    scheduledNotificationDateTime: scheduleTime!,
                  );
                },
              );
            },
            decoration: InputDecoration(
              hintText: 'Select Date & Time',
              hintStyle: whiteTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semibold,
              ),
              contentPadding: EdgeInsets.all(defaultRadius),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ElevatedButton(
//   child: const Text('Show notifications'),
//   onPressed: () {
//     NotificationService().showNotification(
//       title: '$city, $subcity',
//       body:
//           '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()}: ${weatherController.getData().current!.current.temp}°C',
//     );
//   },
// ),
