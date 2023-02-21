import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:weather_app/pages/widgets/search_delegate.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: whiteColor, size: 24),
            const SizedBox(width: 8),
            // Lokasi
            RichText(
              text: TextSpan(
                text: city,
                style:
                    whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
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
      ],
    );
  }
}
