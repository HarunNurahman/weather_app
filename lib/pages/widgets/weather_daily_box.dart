import 'package:flutter/material.dart';

import '../../config/styles.dart';

class WeatherDailyBox extends StatelessWidget {
  const WeatherDailyBox({super.key});

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
              'assets/icons/weathers/09d.png',
              width: 12,
            ),
          ),
          SizedBox(width: defaultHorizontalMargin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selasa',
                  style: blackTextStyle.copyWith(
                    color: blackColor2,
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hujan Petir',
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
            '19°C',
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
