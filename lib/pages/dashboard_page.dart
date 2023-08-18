import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_widget.dart';
import 'package:weather_app/pages/widgets/current/weather_info_box.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_widget.dart';
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: whiteColor, size: 24),
              const SizedBox(width: 8),
              // Lokasi
              Shimmer.fromColors(
                baseColor: whiteColor,
                highlightColor: grayColor,
                child: Container(
                  width: 152,
                  height: 17,
                  color: whiteColor,
                ),
              )
            ],
          ),
          // Search button
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

    // Skeleton Loading Animation untuk currentWeather
    Widget skeletonCurrentWeather() {
      return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal dan Waktu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFormat, style: whiteTextStyle),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      timeFormat,
                      style: whiteTextStyle,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: defaultVerticalMargin),
            // Suhu dan Status Cuaca
            Row(
              children: [
                // Icon cuaca
                Shimmer.fromColors(
                  baseColor: whiteColor,
                  highlightColor: blueColor5,
                  child: Container(
                    width: 64,
                    height: 64,
                    color: whiteColor,
                  ),
                ),
                SizedBox(width: defaultRadius),
                // Divider
                Container(
                  height: 50,
                  width: 1,
                  color: whiteColor.withOpacity(0.5),
                ),
                SizedBox(width: defaultRadius),
                // Informasi cuaca
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: whiteColor,
                      highlightColor: blueColor5,
                      child: Container(
                        width: 46,
                        height: 24,
                        color: whiteColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Shimmer.fromColors(
                      baseColor: whiteColor,
                      highlightColor: blueColor5,
                      child: Container(
                        width: 134,
                        height: 64,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: defaultVerticalMargin),
            Shimmer.fromColors(
              baseColor: whiteColor,
              highlightColor: blueColor5,
              child: Container(
                width: 164,
                height: 17,
                color: whiteColor,
              ),
            ),
          ],
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
