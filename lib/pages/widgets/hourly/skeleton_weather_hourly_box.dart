import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/config/styles.dart';

class SkeletonWeatherHourlyBox extends StatelessWidget {
  const SkeletonWeatherHourlyBox({super.key});

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
          Shimmer.fromColors(
            baseColor: whiteColor,
            highlightColor: blackColor3,
            child: Container(
              width: 40,
              height: 40,
              color: whiteColor,
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: whiteColor,
            highlightColor: blackColor3,
            child: Container(
              width: 23,
              height: 17,
              color: whiteColor,
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: whiteColor,
            highlightColor: blackColor3,
            child: Container(
              width: 44,
              height: 14,
              color: whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
