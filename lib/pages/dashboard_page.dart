import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/notification_setting_page.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_widget.dart';
import 'package:weather_app/pages/widgets/current/weather_info_box.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_widget.dart';
import 'package:weather_app/pages/widgets/detail/skeleton_detail_info_box.dart';
import 'package:weather_app/pages/widgets/hourly/skeleton_weather_hourly_box.dart';
import 'package:weather_app/pages/widgets/hourly/weather_hourly_widget.dart';
import 'package:weather_app/services/global_controller.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/header_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String dateFormat = DateFormat('EEEEE, dd MMMM yyyy').format(DateTime.now());
  String timeFormat = DateFormat.Hms().format(DateTime.now());

  Timer? time;

  final GlobalController globalController = Get.put(
    GlobalController(),
    permanent: true,
  );

  // Auto-update waktu (hh:mm:ss)
  @override
  void initState() {
    time = Timer.periodic(
      const Duration(seconds: 1),
      (t) => update(),
    );
    super.initState();
  }

  void update() {
    setState(() {
      timeFormat = DateFormat.Hms().format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Header Widget (Lokasi saat ini & search button)
    Widget header() {
      return const HeaderWidget();
    }

    // Widget informasi cuaca terkini di lokasi yang terdeteksi
    Widget weatherInfo() {
      return WeatherInfoWidget(
        currentWeather: globalController.getData().getCurrentWeather(),
      );
    }

    // Widget informasi cuaca beberapa jam kedepan
    Widget weatherHourly() {
      return WeatherHourlyWidget(
        weatherHourly: globalController.getData().getHourlyWeather(),
      );
    }

    // Widget informasi cuaca 3/5 hari kedepan
    Widget weatherDaily() {
      return WeatherDailyWidget(
        dailyWeather: globalController.getData().getDailyWeather(),
      );
    }

    // Widget detail informasi cuaca (humidity, air pressure, wind speed, fog)
    Widget detailInformation() {
      return DetailInfoWidget(
        detailInfo: globalController.getData().getCurrentWeather(),
      );
    }

    // Skeleton Loading Animation untuk header
    Widget skeletonHeader() {
      return Row(
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: whiteColor, size: 24),
              const SizedBox(width: 8),
              // Lokasi
              Shimmer.fromColors(
                baseColor: whiteColor,
                highlightColor: whiteColor2,
                child: Container(
                  width: 152,
                  height: 17,
                  color: whiteColor,
                ),
              )
            ],
          ),
          const Spacer(),
          // Search button
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.search,
              size: 24,
              color: whiteColor,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Get.to(
              NotificationSettingPage(),
            ),
            child: Icon(
              Icons.settings,
              size: 24,
              color: whiteColor,
            ),
          ),
        ],
      );
    }

    // Skeleton Loading Animation untuk currentWeather
    Widget skeletonCurrentWeather() {
      return Shimmer.fromColors(
        baseColor: const Color(0xFF4F7FFA),
        highlightColor: const Color(0xFF335FD1),
        child: Container(
          width: double.infinity,
          height: 193,
          margin: EdgeInsets.only(top: defaultVerticalMargin),
          padding: EdgeInsets.all(defaultVerticalMargin),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(defaultRadius),
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

    // Skeleton Loading Animation untuk hourlyWeather
    Widget skeletonHourlyWeather() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonWeatherHourlyBox(),
                SkeletonWeatherHourlyBox(),
                SkeletonWeatherHourlyBox(),
                SkeletonWeatherHourlyBox(),
              ],
            )
          ],
        ),
      );
    }

    // Skeleton Loading Animation untuk dailyWeather
    Widget skeletonDailyWeather() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
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
                  baseColor: blueColor4,
                  highlightColor: blueColor5,
                  child: Container(
                    width: double.infinity,
                    height: 72,
                    padding: EdgeInsets.all(defaultHorizontalMargin),
                    margin: EdgeInsets.only(bottom: defaultRadius),
                    decoration: BoxDecoration(
                      color: blueColor4,
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    // Skeleton Loading Animation untuk detailWeatherInfo
    Widget skeletonDetailInfo() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
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
              baseColor: blackColor4,
              highlightColor: grayColor,
              child: const Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SkeletonDetailInfoBox(),
                  SkeletonDetailInfoBox(),
                  SkeletonDetailInfoBox(),
                  SkeletonDetailInfoBox(),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Obx(
          () => globalController.isLoading.isTrue
              // ? Center(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         CircularProgressIndicator(
              //           color: whiteColor,
              //           strokeWidth: 0.5,
              //         ),
              //         SizedBox(height: defaultVerticalMargin),
              //         Text(
              //           'Mengambil Data...',
              //           style: whiteTextStyle.copyWith(
              //             fontSize: 12,
              //             fontWeight: light,
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              ? SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: defaultVerticalMargin,
                      horizontal: defaultHorizontalMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        skeletonHeader(),
                        skeletonCurrentWeather(),
                        skeletonHourlyWeather(),
                        skeletonDailyWeather(),
                        skeletonDetailInfo(),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: defaultVerticalMargin,
                      horizontal: defaultHorizontalMargin,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        header(),
                        weatherInfo(),
                        weatherHourly(),
                        weatherDaily(),
                        detailInformation(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
