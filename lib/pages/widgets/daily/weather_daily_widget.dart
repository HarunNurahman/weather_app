import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/air_pollution/air_pollution_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/models/weather_data_daily.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_box.dart';

class WeatherDailyWidget extends StatefulWidget {
  final WeatherDataDaily dailyWeather;
  final WeatherDataCurrent currentWeather;
  final double lat;
  final double lon;
  const WeatherDailyWidget({
    super.key,
    required this.dailyWeather,
    required this.lat,
    required this.lon,
    required this.currentWeather,
  });

  @override
  State<WeatherDailyWidget> createState() => _WeatherDailyWidgetState();
}

class _WeatherDailyWidgetState extends State<WeatherDailyWidget> {
  int currentIndex = 0;

  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String value = DateFormat('Hm').format(time);

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirPollutionBloc()
        ..add(
          AirPollutionEventStarted(widget.lat, widget.lon),
        ),
      child: Container(
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
            // MESSAGE BOX
            BlocBuilder<AirPollutionBloc, AirPollutionState>(
              builder: (context, state) {
                if (state is AirPollutionLoading) {
                  return const SizedBox();
                } else if (state is AirPollutionSuccess) {
                  AirPollutionModel airPollutionModel = state.airPollutionModel;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(defaultHorizontalMargin),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(defaultRadius),
                      color: blueColor,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          CarouselSlider(
                            items: [
                              // WEATHER SUMMARY MESSAGE
                              Center(
                                child: Text(
                                  widget.dailyWeather.daily[0].summary!,
                                  style: whiteTextStyle.copyWith(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // AIR POLLUTION MESSAGE
                              Center(
                                child: Text(
                                  airPollutionModel
                                              .data.current.pollution.aqius <=
                                          50
                                      ? 'The air quality is satisfactory and poses little or no health risk.'
                                      : airPollutionModel.data.current.pollution
                                                      .aqius >
                                                  50 &&
                                              airPollutionModel.data.current
                                                      .pollution.aqius <=
                                                  100
                                          ? 'It\'s good day for low-intensity activities outside.'
                                          : airPollutionModel.data.current
                                                          .pollution.aqius >
                                                      100 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
                                                      150
                                              ? 'It\'s ok to hang out outside, just not too long.'
                                              : airPollutionModel.data.current
                                                              .pollution.aqius >
                                                          150 &&
                                                      airPollutionModel
                                                              .data
                                                              .current
                                                              .pollution
                                                              .aqius <=
                                                          200
                                                  ? 'Make sure to wear a mask if you are outside'
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
                                                      ? 'Air quality can cause health effects for everyone.'
                                                      : 'Air quality is hazardous.',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                              // UVI INDEX MESSAGE
                              if (widget.currentWeather.current.uvi! > 0) ...[
                                Center(
                                  child: Text(
                                    widget.currentWeather.current.uvi! <= 2
                                        ? 'UV index is low\nIt\'s great time to sunbathing outside'
                                        : widget.currentWeather.current.uvi! >
                                                    2 &&
                                                widget.currentWeather.current
                                                        .uvi! <=
                                                    5
                                            ? 'UV index is moderate\nTry wear sunscreen or hat if you are going outside'
                                            : widget.currentWeather.current
                                                            .uvi! >
                                                        5 &&
                                                    widget.currentWeather
                                                            .current.uvi! <=
                                                        7
                                                ? 'UV index is high\nSeek a shade, use sunscreen, slip on shirt and a hat'
                                                : 'UV index is extreme\nJacket, sunscreen, and hat are must!',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                              // SUNRISE AND SUNSET MESSAGE
                              Center(
                                child: Text(
                                  widget.currentWeather.current.uvi! > 0.0
                                      ? 'Don\'t miss the sunset!\nSunset will be at ${getTime(widget.currentWeather.current.sunset!)}'
                                      : 'Rise and shine!\nSunrise will be at ${getTime(widget.currentWeather.current.sunrise!)}',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                            options: CarouselOptions(
                              height: 40,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              pauseAutoPlayInFiniteScroll: true,
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  print(AirPollutionError(state.toString()));
                  return const CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: defaultHorizontalMargin),
            SizedBox(
              height: 410,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => WeatherDailyBox(
                  day: widget.dailyWeather.daily[index].dt!,
                  imgUrl: widget.dailyWeather.daily[index].weather![0].icon!,
                  weather:
                      widget.dailyWeather.daily[index].weather![0].description!,
                  minTemp: widget.dailyWeather.daily[index].temp!.min!,
                  maxTemp: widget.dailyWeather.daily[index].temp!.max!,
                ),
                itemCount: widget.dailyWeather.daily.length = 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
