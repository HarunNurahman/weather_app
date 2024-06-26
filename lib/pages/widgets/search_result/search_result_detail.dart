import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';

class SearchResultDetail extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String value;
  const SearchResultDetail({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.438,
      padding: EdgeInsets.all(defaultHorizontalMargin),
      decoration: BoxDecoration(
        color: blackColor4,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        children: [
          Image.asset(imgUrl, width: 24, color: blueColor),
          SizedBox(width: defaultRadius),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: whiteTextStyle.copyWith(
                    fontWeight: semibold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
