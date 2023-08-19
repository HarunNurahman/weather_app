import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';

class SkeletonDetailInfoBox extends StatelessWidget {
  const SkeletonDetailInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 70,
      padding: EdgeInsets.all(defaultHorizontalMargin),
      decoration: BoxDecoration(
        color: blackColor4,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
    );
  }
}
