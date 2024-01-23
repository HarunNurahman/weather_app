import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_widget.dart';
import 'package:weather_app/pages/widgets/current/weather_info_box.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_widget.dart';
import 'package:weather_app/pages/widgets/detail/skeleton_detail_info_box.dart';
import 'package:weather_app/pages/widgets/hourly/skeleton_weather_hourly_box.dart';
import 'package:weather_app/pages/widgets/hourly/weather_hourly_widget.dart';
import 'package:weather_app/services/global_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/services/notification_services.dart';

import 'widgets/header_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalController weatherController = Get.put(
    GlobalController(),
    permanent: true,
  );

  @override
  void initState() {
    // Foreground state notification
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        NotificationService().showNotification(
          title:
              'Current Weather • ${weatherController.getData().current!.current.temp}°C',
          body:
              '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
        );
      });
    });

    // Background state notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        NotificationService().showNotification(
          title: '• ${weatherController.getData().current!.current.temp}°C',
          body:
              '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
        );
      });
    });

    // FirebaseMessaging.onBackgroundMessage((message) {
    //   return NotificationService().showNotification(
    //     title:
    //         '$subcity • ${weatherController.getData().current!.current.temp}°C',
    //     body:
    //         '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
    //   );
    // });

    // Terminated state notification
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          NotificationService().showNotification(
            title: '• ${weatherController.getData().current!.current.temp}°C',
            body:
                '${weatherController.getData().current!.current.weather![0].description.toString().toTitleCase()} • High ${weatherController.getData().daily!.daily[0].temp!.max}°C | Low ${weatherController.getData().daily!.daily[0].temp!.min}°C',
          );
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(
              const Duration(seconds: 2),
              () => weatherController.refreshData(),
            );
          },
          child: Obx(
            () => weatherController.isLoading.isTrue
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
      ),
    );
  }

  // Header Widget (Lokasi saat ini & search button)
  Widget header() {
    return const HeaderWidget();
  }

  // Widget informasi cuaca terkini di lokasi yang terdeteksi
  Widget weatherInfo() {
    return WeatherInfoWidget(
      currentWeather: weatherController.getData().getCurrentWeather(),
      onTap: () async {
        await launchUrl(
          Uri.parse(
            'https://openweathermap.org/weathermap?basemap=map&cities=true&layer=temperature&lat=${weatherController.getLat().value}&lon=${weatherController.getLon().value}&zoom=10',
          ),
        );
      },
    );
  }

  // Widget informasi cuaca beberapa jam kedepan
  Widget weatherHourly() {
    return WeatherHourlyWidget(
      weatherHourly: weatherController.getData().getHourlyWeather(),
    );
  }

  // Widget informasi cuaca 3/5 hari kedepan
  Widget weatherDaily() {
    return WeatherDailyWidget(
      dailyWeather: weatherController.getData().getDailyWeather(),
      currentWeather: weatherController.getData().getCurrentWeather(),
      lat: weatherController.getLat().value,
      lon: weatherController.getLon().value,
    );
  }

  // Widget detail informasi cuaca (humidity, air pressure, wind speed, fog)
  Widget detailInformation() {
    return DetailInfoWidget(
      detailInfo: weatherController.getData().getCurrentWeather(),
      lat: weatherController.getLat().value,
      lon: weatherController.getLon().value,
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
            Text('Mencari Lokasi...', style: whiteTextStyle),
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
          onTap: () {},
          child: Icon(
            Icons.notifications,
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
            child: Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                color: blackColor4,
              ),
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
}
