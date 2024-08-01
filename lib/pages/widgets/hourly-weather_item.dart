import 'package:flutter/material.dart';
import 'package:weather_app/shared/styles.dart';

class HourlyWeatherItem extends StatelessWidget {
  const HourlyWeatherItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: blackColor3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/icons/weathers/01d.png',
            width: 40,
          ),
          const SizedBox(height: 8),
          Text(
            '30°C',
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '12:00',
            style: whiteTextStyle,
          ),
        ],
      ),
    );
  }
}
