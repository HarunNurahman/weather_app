import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/search_result_page.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_widget.dart';
import 'package:weather_app/pages/widgets/current/weather_info_box.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_widget.dart';
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
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(),
          ),
        ),
        child: WeatherInfoWidget(
          currentWeather: globalController.getData().getCurrentWeather(),
        ),
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
