import 'package:flutter/material.dart';

import '../../config/styles.dart';

class WeatherDailyBox extends StatelessWidget {
  final String day;
  final String imgUrl;
  final String weather;
  final String temp;

  const WeatherDailyBox({
    super.key,
    required this.day,
    required this.imgUrl,
    required this.weather,
    required this.temp,
  });

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
              imgUrl,
              width: 12,
            ),
          ),
          SizedBox(width: defaultHorizontalMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: blackTextStyle.copyWith(
                    color: blackColor2,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weather,
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
            '$temp°C',
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
