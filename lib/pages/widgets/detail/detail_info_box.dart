import 'package:flutter/material.dart';

import '../../../config/styles.dart';

class DetailInfoBox extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String value;
  const DetailInfoBox({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(defaultHorizontalMargin),
      decoration: BoxDecoration(
        color: blackColor4,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        children: [
          Image.asset(imgUrl, width: 24),
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
