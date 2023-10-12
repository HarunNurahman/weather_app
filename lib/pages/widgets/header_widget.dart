import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:weather_app/pages/widgets/search_delegate.dart';
import 'package:weather_app/services/notification_services.dart';

import '../../config/styles.dart';
import '../../services/global_controller.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
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

    // Foreground state notification
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        NotificationService().showNotification(
          title:
              '$subcity • ${weatherController.getData().current!.current.temp}°C',
          body:
              '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
        );
      });
    });

    // Background state notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        NotificationService().showNotification(
          title:
              '$subcity • ${weatherController.getData().current!.current.temp}°C',
          body:
              '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
        );
      });
    });

    // Terminated state notification
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          NotificationService().showNotification(
            title:
                '$subcity • ${weatherController.getData().current!.current.temp}°C',
            body:
                '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
          );
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: whiteColor, size: 24),
            const SizedBox(width: 8),
            // Lokasi
            RichText(
              text: TextSpan(
                text: city,
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
                children: [
                  TextSpan(
                    text: ', $subcity',
                    style: whiteTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        // Search button
        GestureDetector(
          onTap: () {
            showSearch(
              context: context,
              delegate: MySearchDelegate(),
            );
          },
          child: Icon(
            Icons.search,
            size: 24,
            color: whiteColor,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            NotificationService().showNotification(
              title:
                  '$subcity • ${weatherController.getData().current!.current.temp}°C',
              body:
                  '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
            );
          },
          child: Icon(
            Icons.notifications,
            size: 24,
            color: whiteColor,
          ),
        ),
      ],
    );
  }
}
