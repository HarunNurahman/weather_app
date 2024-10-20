import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:weather_app/shared/styles.dart';

class AirQualityCard extends StatelessWidget {
  final int value;
  final String title;
  final String description;
  final Color color;
  const AirQualityCard({
    super.key,
    required this.value,
    required this.title,
    required this.description,
    this.color = const Color(0xFF2AA837),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blackColor3,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Percent Indicator
          CircularPercentIndicator(
            radius: 42,
            lineWidth: 5,
            percent: value / 500,
            progressColor: color,
            arcBackgroundColor: grayColor2,
            arcType: ArcType.FULL,
            circularStrokeCap: CircularStrokeCap.round,
            center: Text(
              value.toString(),
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Air Quality Result and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: whiteTextStyle.copyWith(
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
