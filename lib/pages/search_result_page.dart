import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/forecast/forecast_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/forecast_weather_model.dart';
import 'package:weather_app/models/search_weather_model.dart';
import 'package:weather_app/pages/detail_example.dart';
import 'package:weather_app/pages/hourly_example.dart';

class SearchResultPage extends StatefulWidget {
  final SearchWeatherModel searchResult;
  const SearchResultPage({
    super.key,
    required this.searchResult,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String dateFormat = DateFormat('EEEEE, dd MMMM yyyy').format(DateTime.now());
  String timeFormat = DateFormat.Hms().format(DateTime.now());

  Timer? time;

  @override
  void initState() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) => update());
    super.initState();
  }

  void update() {
    if (mounted) {
      setState(() {
        timeFormat = DateFormat.Hms().format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget untuk appbar
    PreferredSizeWidget appBar() {
      return AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            size: 16,
            color: whiteColor,
          ),
        ),
        title: BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return const SizedBox();
            } else if (state is ForecastSuccess) {
              List<ForecastWeatherModel> forecast = state.forecastWeather;
              return Text(
                'Test',
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 16,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      );
    }

    // Widget untuk konten hourly, dan detail informasi
    Widget content() {
      // Cuaca saat ini
      Widget currentWeather() {
        return BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return const SizedBox();
            } else if (state is ForecastSuccess) {
              ForecastWeatherModel forecast =
                  state.forecastWeather as ForecastWeatherModel;
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: defaultVerticalMargin),
                child: Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: dateFormat,
                          style: whiteTextStyle,
                          children: [
                            TextSpan(
                              text: ' - $timeFormat',
                              style: whiteTextStyle,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: defaultVerticalMargin),
                      Image.asset(
                          'assets/icons/weathers/${forecast.weather![0].icon}.png',
                          width: 64),
                      const SizedBox(height: 18),
                      Text(
                        '${forecast.main!.temp}°C',
                        style: whiteTextStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        forecast.weather![0].description!,
                        style: whiteTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: semibold,
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              print(state.toString());
              return const SizedBox();
            }
          },
        );
      }

      // Widget untuk detail informasi (humidity, air pressure, wind speed, visibility)
      Widget detailInfo() {
        return BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return const SizedBox();
            } else if (state is ForecastSuccess) {
              List<ForecastWeatherModel> forecast = state.forecastWeather;
              return Container(
                margin: EdgeInsets.symmetric(vertical: defaultVerticalMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Information',
                      style: whiteTextStyle.copyWith(
                          fontSize: 20, fontWeight: medium),
                    ),
                    SizedBox(height: defaultHorizontalMargin),
                    Row(
                      children: [
                        DetailExample(
                          imgUrl: 'assets/icons/ic_humid.png',
                          value: '${forecast[0].main!.humidity}%',
                          title: 'Humidity',
                        ),
                        SizedBox(width: defaultHorizontalMargin),
                        DetailExample(
                          imgUrl: 'assets/icons/ic_pressure.png',
                          value: '${forecast[0].main!.pressure} hPa',
                          title: 'Pressure',
                        ),
                      ],
                    ),
                    SizedBox(height: defaultHorizontalMargin),
                    Row(
                      children: [
                        DetailExample(
                          imgUrl: 'assets/icons/ic_wind_speed.png',
                          value: '${forecast[0].wind!.speed} km/h',
                          title: 'Wind Speed',
                        ),
                        SizedBox(width: defaultHorizontalMargin),
                        DetailExample(
                          imgUrl: 'assets/icons/ic_fog.png',
                          value: '${forecast[0].visibility! / 1000} km',
                          title: 'Visibility',
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              print(state.toString());

              return const SizedBox();
            }
          },
        );
      }

      return BlocBuilder<ForecastBloc, ForecastState>(
        builder: (context, state) {
          if (state is ForecastLoading) {
            return const SizedBox();
          } else if (state is ForecastSuccess) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: defaultHorizontalMargin,
              ),
              color: blackColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  currentWeather(),
                  detailInfo(),
                ],
              ),
            );
          } else {
            print(state.toString());
            return const SizedBox();
          }
        },
      );
    }

    return BlocProvider(
      create: (context) =>
          ForecastBloc()..add(ForecastEventStarted(widget.searchResult.name!)),
      child: Scaffold(
        backgroundColor: blueColor,
        appBar: appBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                content(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
