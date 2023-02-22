import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_widget.dart';
import 'package:weather_app/pages/widgets/detail_info_box.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_box.dart';
import 'package:weather_app/pages/widgets/current/weather_info_box.dart';
import 'package:weather_app/pages/widgets/hourly/weather_hourly_widget.dart';
import 'package:weather_app/services/global_controller.dart';

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
      return WeatherInfo(
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
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Informasi',
              style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: medium),
            ),
            SizedBox(height: defaultHorizontalMargin),
            Row(
              children: [
                const DetailInfoBox(
                  imgUrl: 'assets/icons/ic_humid.png',
                  value: '86%',
                  title: 'Kelembaban',
                ),
                SizedBox(width: defaultHorizontalMargin),
                const DetailInfoBox(
                  imgUrl: 'assets/icons/ic_pressure.png',
                  value: '940 hPa',
                  title: 'Tekanan Udara',
                ),
              ],
            ),
            SizedBox(height: defaultHorizontalMargin),
            Row(
              children: [
                const DetailInfoBox(
                  imgUrl: 'assets/icons/ic_wind_speed.png',
                  value: '1 km/h',
                  title: 'Wind Speed',
                ),
                SizedBox(width: defaultHorizontalMargin),
                const DetailInfoBox(
                  imgUrl: 'assets/icons/ic_fog.png',
                  value: '14%',
                  title: 'Kabut',
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Obx(
          () => globalController.isLoading.isTrue
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Mengambil Data...',
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: light,
                        ),
                      ),
                      SizedBox(height: defaultVerticalMargin),
                      CircularProgressIndicator(color: blueColor),
                    ],
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
