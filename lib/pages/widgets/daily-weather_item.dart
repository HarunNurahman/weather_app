import 'package:flutter/material.dart';
import 'package:weather_app/shared/styles.dart';

class DailyWeatherItem extends StatelessWidget {
  const DailyWeatherItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blueColor4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Weather Icon
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: blueColor5,
            ),
            child: Image.asset('assets/icons/weathers/01d.png'),
          ),
          const SizedBox(width: 16),
          // Day and Weather Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Senin',
                  style: blackTextStyle.copyWith(fontWeight: bold),
                ),
                const SizedBox(height: 4),
                Text('Partly Cloudy', style: blackTextStyle)
              ],
            ),
          ),
          // Highest and Lowest Temperature
          Text(
            '30° | 20° C',
            style: blackTextStyle.copyWith(fontWeight: bold),
          ),
        ],
      ),
    );
  }
}
