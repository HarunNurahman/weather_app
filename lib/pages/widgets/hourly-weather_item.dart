import 'package:flutter/material.dart';
import 'package:weather_app/shared/app_format.dart';
import 'package:weather_app/shared/styles.dart';

class HourlyWeatherItem extends StatelessWidget {
  final String imgUrl;
  final int temp;
  final int timeStamp;
  const HourlyWeatherItem({
    super.key,
    required this.imgUrl,
    required this.temp,
    required this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: blackColor2,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/icons/weathers/$imgUrl.png',
            width: 40,
          ),
          const SizedBox(height: 8),
          Text(
            '$temp°C',
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppFormat.getTime(timeStamp),
            style: whiteTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
