import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/shared/styles.dart';

class SkeletonLoading extends StatelessWidget {
  const SkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Header Section
          skeletonHeader(),
          // Current Weather Section
          skeletonCurrentWeather(),
          // Hourly Weather Section
          skeletonHourlyWeather(),
          // Daily Weather Section
          skeletonDailyWeather(),
          // Detail Information Section
          skeletonDetailInformation(),
        ],
      ),
    );
  }

  Widget skeletonHeader() {
    return Row(
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: whiteColor, size: 24),
            const SizedBox(width: 8),
            // USER LOCATION
            Text('Finding Location...', style: whiteTextStyle),
          ],
        ),
        const Spacer(),
        // SEARCH BUTTON
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.search,
            size: 24,
            color: whiteColor,
          ),
        ),
      ],
    );
  }

  Widget skeletonCurrentWeather() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF4F7FFA),
      highlightColor: const Color(0xFF335FD1),
      child: Container(
        width: double.infinity,
        height: 193,
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4F7FFA),
              Color(0xFF335FD1),
            ],
          ),
        ),
      ),
    );
  }

  Widget skeletonHourlyWeather() {
    Widget skeletonWeatherHourlyBox() {
      return Shimmer.fromColors(
        baseColor: blackColor2,
        highlightColor: grayColor,
        child: Container(
          width: 78,
          height: 107,
          decoration: BoxDecoration(
            color: blackColor2,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly',
            style: whiteTextStyle.copyWith(
              fontSize: 20,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              skeletonWeatherHourlyBox(),
              skeletonWeatherHourlyBox(),
              skeletonWeatherHourlyBox(),
              skeletonWeatherHourlyBox(),
            ],
          )
        ],
      ),
    );
  }

  Widget skeletonDailyWeather() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily',
            style: whiteTextStyle.copyWith(
              fontSize: 20,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Shimmer.fromColors(
                baseColor: blueColor2,
                highlightColor: blueColor3,
                child: Container(
                  width: double.infinity,
                  height: 72,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: blueColor2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget skeletonDetailInformation() {
    Widget skeletonDetailInfoBox() {
      return Container(
        width: 150,
        height: 70,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: blackColor3,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Information',
            style: whiteTextStyle.copyWith(
              fontSize: 20,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: blackColor3,
            highlightColor: grayColor,
            child: Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: blackColor3,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Shimmer.fromColors(
              baseColor: blackColor3,
              highlightColor: grayColor,
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  skeletonDetailInfoBox(),
                  skeletonDetailInfoBox(),
                  skeletonDetailInfoBox(),
                  skeletonDetailInfoBox(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
