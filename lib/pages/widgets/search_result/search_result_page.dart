import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/forecast/forecast_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/widgets/search_result/search_result_daily.dart';
import 'package:weather_app/pages/widgets/search_result/search_result_detail.dart';
import 'package:weather_app/pages/widgets/search_result/search_result_hourly.dart';

class SearchResultPage extends StatefulWidget {
  final double lat;
  final double lon;
  final String cityName;
  const SearchResultPage({
    super.key,
    required this.lat,
    required this.lon,
    required this.cityName,
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
        title: Text(
          widget.cityName,
          style: whiteTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 16,
          ),
        ),
      );
    }

    // Cuaca saat ini
    Widget currentWeather() {
      return BlocBuilder<ForecastBloc, ForecastState>(
        builder: (context, state) {
          if (state is ForecastLoading) {
            return Center(
              child: CircularProgressIndicator(color: whiteColor),
            );
          } else if (state is ForecastSuccess) {
            WeatherData forecast = state.forecastWeather;
            return Container(
              color: blueColor,
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
                        'assets/icons/weathers/${forecast.current!.current.weather![0].icon}.png',
                        width: 64),
                    const SizedBox(height: 18),
                    Text(
                      '${forecast.current!.current.temp}°C',
                      style: whiteTextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      forecast.current!.current.weather![0].description!
                          .toTitleCase(),
                      style: whiteTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semibold,
                      ),
                    ),
                    SizedBox(height: defaultVerticalMargin),
                    Text(
                      'Feels Like ${forecast.current!.current.feelsLike}°C',
                      style: whiteTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: light,
                      ),
                    ),
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

    // Widget untuk konten hourly, dan detail informasi
    Widget content() {
      Widget hourly() {
        return BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return const SizedBox();
            } else if (state is ForecastSuccess) {
              WeatherData forecast = state.forecastWeather;
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
                    SizedBox(
                      height: 111,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return SearchResultHourly(
                            temp: forecast.hourly!.hourly[index].temp!,
                            timeStamp: forecast.hourly!.hourly[index].dt!,
                            imgUrl: forecast
                                .hourly!.hourly[index].weather![0].icon!,
                          );
                        },
                        separatorBuilder: (context, index) => VerticalDivider(
                          color: transparent,
                          width: 10,
                        ),
                        itemCount: forecast.hourly!.hourly.length >= 6
                            ? 6
                            : forecast.hourly!.hourly.length,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      }

      Widget daily() {
        return BlocBuilder<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return const SizedBox();
            } else if (state is ForecastSuccess) {
              WeatherData forecast = state.forecastWeather;

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
                    SizedBox(height: defaultHorizontalMargin),
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => SearchResultDaily(
                          day: forecast.daily!.daily[index].dt!,
                          imgUrl:
                              forecast.daily!.daily[index].weather![0].icon!,
                          weather: forecast
                              .daily!.daily[index].weather![0].description!,
                          minTemp: forecast.daily!.daily[index].temp!.min!,
                          maxTemp: forecast.daily!.daily[index].temp!.max!,
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
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
              WeatherData forecast = state.forecastWeather;
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
                        SearchResultDetail(
                          imgUrl: 'assets/icons/ic_humid.png',
                          value: '${forecast.current!.current.humidity}%',
                          title: 'Humidity',
                        ),
                        SizedBox(width: defaultHorizontalMargin),
                        SearchResultDetail(
                          imgUrl: 'assets/icons/ic_pressure.png',
                          value: '${forecast.current!.current.pressure} hPa',
                          title: 'Pressure',
                        ),
                      ],
                    ),
                    SizedBox(height: defaultHorizontalMargin),
                    Row(
                      children: [
                        SearchResultDetail(
                          imgUrl: 'assets/icons/ic_wind_speed.png',
                          value: '${forecast.current!.current.windSpeed} km/h',
                          title: 'Wind Speed',
                        ),
                        SizedBox(width: defaultHorizontalMargin),
                        SearchResultDetail(
                          imgUrl: 'assets/icons/ic_fog.png',
                          value:
                              '${forecast.current!.current.visibility! / 1000} km',
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
                  hourly(),
                  daily(),
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
          ForecastBloc()..add(ForecastEventStarted(widget.lat, widget.lon)),
      child: Scaffold(
        backgroundColor: blueColor,
        appBar: appBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                currentWeather(),
                content(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
