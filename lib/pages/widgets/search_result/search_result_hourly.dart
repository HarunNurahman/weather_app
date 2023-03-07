import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';

class SearchResultHourly extends StatelessWidget {
  final int temp;
  final int timeStamp;
  final String imgUrl;
  const SearchResultHourly({
    super.key,
    required this.temp,
    required this.timeStamp,
    required this.imgUrl,
  });

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String value = DateFormat('Hm').format(time);

    return value;
  }

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
          Image.asset('assets/icons/weathers/$imgUrl.png', width: 40),
          const SizedBox(height: 8),
          Text(
            '${temp.toString()}°C',
            style: whiteTextStyle.copyWith(
              fontWeight: semibold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            getTime(timeStamp),
            style: whiteTextStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
