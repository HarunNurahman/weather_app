import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/air_pollution/air_pollution_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/models/weather_data_daily.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_box.dart';

class WeatherDailyWidget extends StatefulWidget {
  final WeatherDataDaily dailyWeather;
  final double lat;
  final double lon;
  const WeatherDailyWidget({
    super.key,
    required this.dailyWeather,
    required this.lat,
    required this.lon,
  });

  @override
  State<WeatherDailyWidget> createState() => _WeatherDailyWidgetState();
}

class _WeatherDailyWidgetState extends State<WeatherDailyWidget> {
  int currentIndex = 0;
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
                  return const CircularProgressIndicator();
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CarouselSlider(
                            items: [
                              Center(
                                child: Text(
                                  widget.dailyWeather.daily[0].summary!,
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  airPollutionModel
                                              .data.current.pollution.aqius <=
                                          50
                                      ? 'The air quality is good and clean, and there is almost no danger.'
                                      : airPollutionModel.data.current.pollution
                                                      .aqius >
                                                  50 &&
                                              airPollutionModel.data.current
                                                      .pollution.aqius <=
                                                  100
                                          ? 'The air is in good shape. However, a small percentage of highly sensitive individuals may experience some health issue.'
                                          : airPollutionModel.data.current
                                                          .pollution.aqius >
                                                      100 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
                                                      150
                                              ? 'Members of sensitive groups may experience health effects, The general public is less likely to be affected.'
                                              : '',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: medium,
                                  ),
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
              height: 240,
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
                itemCount: widget.dailyWeather.daily.length = 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
