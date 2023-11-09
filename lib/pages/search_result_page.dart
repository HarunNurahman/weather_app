import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/bloc/air_pollution/air_pollution_bloc.dart';
import 'package:weather_app/bloc/forecast/forecast_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/pages/widgets/search_result/search_result_daily.dart';
import 'package:weather_app/pages/widgets/search_result/search_result_detail.dart';
import 'package:weather_app/pages/widgets/search_result/search_result_hourly.dart';
// import 'package:weather_app/services/notification_services.dart';

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
  DateTime? scheduleTime = DateTime.now();

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

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String value = DateFormat('Hm').format(time);

    return value;
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
            return Shimmer.fromColors(
              baseColor: blueColor,
              highlightColor: blueColor3,
              child: Container(
                color: blueColor,
                width: double.infinity,
                height: 375,
                margin: EdgeInsets.symmetric(vertical: defaultVerticalMargin),
              ),
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
                    Image.asset(
                      'assets/icons/weathers/${forecast.current!.current.weather![0].icon}.png',
                      width: 96,
                    ),
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
                      height: 115,
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
                    BlocBuilder<AirPollutionBloc, AirPollutionState>(
                      builder: (context, state) {
                        if (state is AirPollutionLoading) {
                          return Shimmer.fromColors(
                            baseColor: blackColor4,
                            highlightColor: grayColor,
                            child: Container(
                              width: double.infinity,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                                color: blackColor4,
                              ),
                            ),
                          );
                        } else if (state is AirPollutionSuccess) {
                          AirPollutionModel airPollutionModel =
                              state.airPollutionModel;
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: blackColor4,
                              borderRadius:
                                  BorderRadius.circular(defaultRadius),
                            ),
                            child: Row(
                              children: [
                                CircularPercentIndicator(
                                  radius: 42,
                                  lineWidth: 6,
                                  arcType: ArcType.FULL,
                                  arcBackgroundColor: const Color(0xFFE4E4E4),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: airPollutionModel
                                              .data.current.pollution.aqius <=
                                          50
                                      ? greenColor
                                      : airPollutionModel.data.current.pollution.aqius > 50 &&
                                              airPollutionModel.data.current.pollution.aqius <=
                                                  100
                                          ? yellowColor
                                          : airPollutionModel.data.current.pollution.aqius > 100 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
                                                      150
                                              ? orangeColor
                                              : airPollutionModel.data.current.pollution.aqius > 150 &&
                                                      airPollutionModel
                                                              .data
                                                              .current
                                                              .pollution
                                                              .aqius <=
                                                          200
                                                  ? redColor
                                                  : airPollutionModel.data.current.pollution.aqius > 200 &&
                                                          airPollutionModel
                                                                  .data
                                                                  .current
                                                                  .pollution
                                                                  .aqius <=
                                                              300
                                                      ? purpleColor
                                                      : airPollutionModel.data.current.pollution.aqius > 300 &&
                                                              airPollutionModel
                                                                      .data
                                                                      .current
                                                                      .pollution
                                                                      .aqius <=
                                                                  500
                                                          ? maroonColor
                                                          : null,
                                  percent: airPollutionModel
                                          .data.current.pollution.aqius /
                                      500,
                                  center: Text(
                                    '${airPollutionModel.data.current.pollution.aqius}',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 18,
                                      fontWeight: bold,
                                      color: airPollutionModel.data.current.pollution.aqius <=
                                              50
                                          ? greenColor
                                          : airPollutionModel.data.current.pollution.aqius > 50 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
                                                      100
                                              ? yellowColor
                                              : airPollutionModel.data.current.pollution.aqius > 100 &&
                                                      airPollutionModel
                                                              .data
                                                              .current
                                                              .pollution
                                                              .aqius <=
                                                          150
                                                  ? orangeColor
                                                  : airPollutionModel.data.current.pollution.aqius > 150 &&
                                                          airPollutionModel
                                                                  .data
                                                                  .current
                                                                  .pollution
                                                                  .aqius <=
                                                              200
                                                      ? redColor
                                                      : airPollutionModel
                                                                      .data
                                                                      .current
                                                                      .pollution
                                                                      .aqius >
                                                                  200 &&
                                                              airPollutionModel
                                                                      .data
                                                                      .current
                                                                      .pollution
                                                                      .aqius <=
                                                                  300
                                                          ? purpleColor
                                                          : airPollutionModel.data.current.pollution.aqius > 300 && airPollutionModel.data.current.pollution.aqius <= 500
                                                              ? maroonColor
                                                              : null,
                                    ),
                                  ),
                                  footer: Text(
                                    'AQI',
                                    style: whiteTextStyle.copyWith(
                                      fontWeight: bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 19),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (airPollutionModel
                                              .data.current.pollution.aqius <=
                                          50) ...[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Very Good',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: semibold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'The air quality is good and clean, and there is almost no danger.',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else if (airPollutionModel.data.current
                                                  .pollution.aqius >
                                              50 &&
                                          airPollutionModel.data.current
                                                  .pollution.aqius <=
                                              100) ...[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Moderate',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: semibold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'The air is in good shape. However, a small percentage of highly sensitive individuals may experience some health issue.',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else if (airPollutionModel.data.current
                                                  .pollution.aqius >
                                              100 &&
                                          airPollutionModel.data.current
                                                  .pollution.aqius <=
                                              150) ...[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unhealthy for Sensitive Groups',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: semibold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Members of sensitive groups may experience health effects, The general public is less likely to be affected.',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else if (airPollutionModel.data.current
                                                  .pollution.aqius >
                                              150 &&
                                          airPollutionModel.data.current
                                                  .pollution.aqius <=
                                              200) ...[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unhealthy',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: semibold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Some members of the general public may suffer from health effects, while members of vulnerable groups may suffer from more serious health.',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else if (airPollutionModel.data.current
                                                  .pollution.aqius >
                                              200 &&
                                          airPollutionModel.data.current
                                                  .pollution.aqius <=
                                              300) ...[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Very Unhealthy',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: semibold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Health alert: The risk of health effects is increased for everyone.',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Hazardous',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: semibold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Health warning of emergency conditions: everyone is more likely to be affected.',
                                              style: whiteTextStyle.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: defaultHorizontalMargin),
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        SearchResultDetail(
                          imgUrl: 'assets/icons/ic_humid.png',
                          value: '${forecast.current!.current.humidity}%',
                          title: 'Humidity',
                        ),
                        forecast.current!.current.uvi! > 0.0
                            ? SearchResultDetail(
                                imgUrl: 'assets/icons/ic_sunset.png',
                                title: 'Sunset',
                                value:
                                    getTime(forecast.current!.current.sunset),
                              )
                            : SearchResultDetail(
                                imgUrl: 'assets/icons/ic_sunrise.png',
                                title: 'Sunrise',
                                value:
                                    getTime(forecast.current!.current.sunrise),
                              ),
                        SearchResultDetail(
                          imgUrl: 'assets/icons/ic_wind_speed.png',
                          value: '${forecast.current!.current.windSpeed} km/h',
                          title: 'Wind Speed',
                        ),
                        forecast.current!.current.uvi! > 0.0
                            ? SearchResultDetail(
                                imgUrl: 'assets/icons/ic_uvi.png',
                                value: '${forecast.current!.current.uvi}',
                                title: 'UV Index',
                              )
                            : SearchResultDetail(
                                imgUrl: 'assets/icons/ic_fog.png',
                                value: '${forecast.current!.current.clouds}%',
                                title: 'Cloudiness',
                              )
                      ],
                    )
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ForecastBloc()..add(ForecastEventStarted(widget.lat, widget.lon)),
        ),
        BlocProvider(
          create: (context) => AirPollutionBloc()
            ..add(AirPollutionEventStarted(widget.lat, widget.lon)),
        ),
      ],
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
