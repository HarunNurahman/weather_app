import 'package:flutter/material.dart';
import 'package:weather_app/shared/styles.dart';

class AddonItem extends StatelessWidget {
  const AddonItem({super.key});

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
          Image.asset('assets/icons/ic_humid.png', width: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '70%',
                style: whiteTextStyle.copyWith(fontWeight: bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Humidity',
                style: whiteTextStyle,
              ),
            ],
          )
        ],
      ),
    );
  }
}
