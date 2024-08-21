import 'package:flutter/material.dart';
import 'package:weather_app/shared/styles.dart';

class AddonItem extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String value;
  const AddonItem({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackColor4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/$imgUrl.png',
            width: 24,
            color: blueColor,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: whiteTextStyle.copyWith(fontWeight: bold),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: whiteTextStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
