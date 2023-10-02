import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/styles.dart';

class WeatherDailyBox extends StatelessWidget {
  final int day;
  final String imgUrl;
  final String weather;
  final int minTemp;
  final int maxTemp;

  const WeatherDailyBox({
    super.key,
    required this.day,
    required this.imgUrl,
    required this.weather,
    required this.minTemp,
    required this.maxTemp,
  });

  String getDay(final day) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(day * 1000);
    final x = DateFormat('EEEE').format(time);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(defaultHorizontalMargin),
      margin: EdgeInsets.only(bottom: defaultRadius),
      decoration: BoxDecoration(
        color: blueColor4,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: blueColor5,
            ),
            child: Image.asset(
              'assets/icons/weathers/$imgUrl.png',
              width: 12,
            ),
          ),
          SizedBox(width: defaultHorizontalMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getDay(day),
                  style: blackTextStyle.copyWith(
                    color: blackColor2,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weather.toCapitalized(),
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    color: grayColor,
                    fontWeight: light,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${minTemp.toString()}°C | ${maxTemp.toString()}°C',
            style: blackTextStyle.copyWith(
              color: blackColor2,
              fontWeight: semibold,
            ),
          )
        ],
      ),
    );
  }
}
