import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/widgets/detail_info_box.dart';
import 'package:weather_app/pages/widgets/search_delegate.dart';
import 'package:weather_app/pages/widgets/weather_daily_box.dart';
import 'package:weather_app/pages/widgets/weather_hourly_box.dart';
import 'package:weather_app/services/global_controller.dart';

import 'widgets/header_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalController globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEEEE, dd MMMM yyyy').format(DateTime.now());
    String time = DateFormat.Hm().format(DateTime.now());

    // Header Widget (Lokasi saat ini & search button)
    // Widget header() {
    //   return const HeaderWidget();
    // }

    // Widget informasi cuaca terkini di lokasi yang terdeteksi
    Widget weatherInfo() {
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
                Text(date, style: whiteTextStyle),
                Text(time, style: whiteTextStyle)
              ],
            ),
            SizedBox(height: defaultVerticalMargin),
            // Suhu dan Status Cuaca
            Row(
              children: [
                // Icon cuaca
                Image.asset('assets/icons/weathers/09d.png', width: 64),
                SizedBox(width: defaultRadius),
                // Informasi cuaca
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '18°C',
                      style: whiteTextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hujan Berawan',
                      style: whiteTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semibold,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: defaultVerticalMargin),
            Text('Feels Like 23°C', style: whiteTextStyle)
          ],
        ),
      );
    }

    // Widget informasi cuaca beberapa jam kedepan
    Widget weatherHourly() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuaca Per Jam',
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 111,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const WeatherHourlyBox(
                    imgUrl: 'assets/icons/weathers/09d.png',
                    temp: '21°C',
                    time: '16:00',
                  );
                },
                separatorBuilder: (context, index) => VerticalDivider(
                  color: transparent,
                  width: 10,
                ),
                itemCount: 8,
              ),
            )
          ],
        ),
      );
    }

    // Widget informasi cuaca 3/5 hari kedepan
    Widget weatherDaily() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Harian',
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: medium,
              ),
            ),
            SizedBox(height: defaultHorizontalMargin),
            Column(
              children: const [
                WeatherDailyBox(
                  day: 'Senin',
                  imgUrl: 'assets/icons/weathers/09d.png',
                  weather: 'Cerah Berawan',
                  temp: '23',
                ),
                WeatherDailyBox(
                  day: 'Selasa',
                  imgUrl: 'assets/icons/weathers/09d.png',
                  weather: 'Mendung',
                  temp: '24',
                ),
                WeatherDailyBox(
                  day: 'Rabu',
                  imgUrl: 'assets/icons/weathers/09d.png',
                  weather: 'Hujan Angin',
                  temp: '23',
                ),
              ],
            )
          ],
        ),
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
        child: Obx(() => globalController.isLoading.isTrue
            ? Center(
                child: CircularProgressIndicator(color: blueColor),
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
                      HeaderWidget(),
                      weatherInfo(),
                      weatherHourly(),
                      weatherDaily(),
                      detailInformation(),
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}
