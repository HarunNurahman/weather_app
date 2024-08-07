import 'package:flutter/material.dart';
import 'package:weather_app/shared/app_format.dart';
import 'package:weather_app/shared/styles.dart';

class DailyWeatherItem extends StatelessWidget {
  final String imgUrl;
  final int day;
  final String desc;
  final int highTemp;
  final int lowTemp;
  const DailyWeatherItem({
    super.key,
    required this.imgUrl,
    required this.day,
    required this.desc,
    required this.highTemp,
    required this.lowTemp,
  });

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
            child: Image.asset('assets/icons/weathers/$imgUrl.png'),
          ),
          const SizedBox(width: 16),
          // Day and Weather Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppFormat.getDay(day),
                  style: blackTextStyle.copyWith(fontWeight: bold),
                ),
                Text(desc, style: blackTextStyle)
              ],
            ),
          ),
          // Highest and Lowest Temperature
          Text(
            '$highTemp° | $lowTemp° C',
            style: blackTextStyle.copyWith(fontWeight: bold),
          ),
        ],
      ),
    );
  }
}
