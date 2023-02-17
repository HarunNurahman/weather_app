import 'package:flutter/material.dart';

import '../../config/styles.dart';

class WeatherHourlyBox extends StatelessWidget {
  final String imgUrl;
  final String temp;
  final String time;
  const WeatherHourlyBox({
    super.key,
    required this.imgUrl,
    required this.temp,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: defaultRadius,
        horizontal: defaultVerticalMargin,
      ),
      decoration: BoxDecoration(
        color: blackColor3,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imgUrl, width: 40),
          const SizedBox(height: 8),
          Text(
            temp,
            style: whiteTextStyle.copyWith(
              fontWeight: semibold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: whiteTextStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
