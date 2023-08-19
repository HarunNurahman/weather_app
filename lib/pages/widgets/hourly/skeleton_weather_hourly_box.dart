import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/config/styles.dart';

class SkeletonWeatherHourlyBox extends StatelessWidget {
  const SkeletonWeatherHourlyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: blackColor3,
      highlightColor: grayColor,
      child: Container(
        width: 78,
        height: 107,
        decoration: BoxDecoration(
          color: blackColor3,
          borderRadius: BorderRadius.circular(defaultRadius),
        ),
      ),
    );
  }
}
