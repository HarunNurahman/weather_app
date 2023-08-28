import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:weather_app/bloc/air_pollution/air_pollution_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_box.dart';

class DetailInfoWidget extends StatelessWidget {
  final WeatherDataCurrent detailInfo;
  final double lat;
  final double lon;
  const DetailInfoWidget({
    super.key,
    required this.detailInfo,
    required this.lat,
    required this.lon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AirPollutionBloc()..add(AirPollutionEventStarted(lat, lon)),
      child: Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Information',
              style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: medium),
            ),
            SizedBox(height: defaultHorizontalMargin),
            // Widget polusi udara
            BlocBuilder<AirPollutionBloc, AirPollutionState>(
              builder: (context, state) {
                if (state is AirPollutionBlocLoading) {
                  return const SizedBox();
                } else if (state is AirPollutionSuccess) {
                  AirPollutionModel airPollutionModel = state.airPollutionModel;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: blackColor4,
                      borderRadius: BorderRadius.circular(defaultRadius),
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
                              : airPollutionModel.data.current.pollution.aqius >
                                          50 &&
                                      airPollutionModel
                                              .data.current.pollution.aqius <=
                                          100
                                  ? yellowColor
                                  : airPollutionModel.data.current.pollution
                                                  .aqius >
                                              100 &&
                                          airPollutionModel.data.current
                                                  .pollution.aqius <=
                                              150
                                      ? orangeColor
                                      : airPollutionModel.data.current.pollution
                                                      .aqius >
                                                  150 &&
                                              airPollutionModel.data.current
                                                      .pollution.aqius <=
                                                  200
                                          ? redColor
                                          : airPollutionModel.data.current
                                                          .pollution.aqius >
                                                      200 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
                                                      300
                                              ? purpleColor
                                              : null,
                          percent: 0.13,
                          center: Text(
                            '${airPollutionModel.data.current.pollution.aqius}',
                            style: whiteTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: bold,
                              color: airPollutionModel
                                          .data.current.pollution.aqius <=
                                      50
                                  ? greenColor
                                  : airPollutionModel.data.current.pollution
                                                  .aqius >
                                              50 &&
                                          airPollutionModel.data.current
                                                  .pollution.aqius <=
                                              100
                                      ? yellowColor
                                      : airPollutionModel.data.current.pollution
                                                      .aqius >
                                                  100 &&
                                              airPollutionModel.data.current
                                                      .pollution.aqius <=
                                                  150
                                          ? orangeColor
                                          : airPollutionModel.data.current
                                                          .pollution.aqius >
                                                      150 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
                                                      200
                                              ? redColor
                                              : airPollutionModel.data.current
                                                              .pollution.aqius >
                                                          200 &&
                                                      airPollutionModel
                                                              .data
                                                              .current
                                                              .pollution
                                                              .aqius <=
                                                          300
                                                  ? purpleColor
                                                  : null,
                            ),
                          ),
                          // footer: Text(
                          //   'PM 2.5',
                          //   style:
                          //       whiteTextStyle.copyWith(fontWeight: semibold),
                          // ),
                        ),
                        const SizedBox(width: 19),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AQI - Very Good',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: semibold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'The air quality is good and clean, and there is almost no danger',
                                style: whiteTextStyle,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  print(state.toString());
                  return const SizedBox();
                }
              },
            ),
            SizedBox(height: defaultHorizontalMargin),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DetailInfoBox(
                  imgUrl: 'assets/icons/ic_humid.png',
                  value: '${detailInfo.current.humidity}%',
                  title: 'Humidity',
                ),
                DetailInfoBox(
                  imgUrl: 'assets/icons/ic_pressure.png',
                  value: '${detailInfo.current.pressure} hPa',
                  title: 'Pressure',
                ),
                DetailInfoBox(
                  imgUrl: 'assets/icons/ic_wind_speed.png',
                  value: '${detailInfo.current.windSpeed} km/h',
                  title: 'Wind Speed',
                ),
                DetailInfoBox(
                  imgUrl: 'assets/icons/ic_fog.png',
                  value:
                      '${detailInfo.current.visibility!.roundToDouble() / 1000} Km',
                  title: 'Visibility',
                ),
              ],
            ),
            // Row(
            //   children: [
            //     DetailInfoBox(
            //       imgUrl: 'assets/icons/ic_humid.png',
            //       value: '${detailInfo.current.humidity}%',
            //       title: 'Humidity',
            //     ),
            //     SizedBox(width: defaultHorizontalMargin),
            //     DetailInfoBox(
            //       imgUrl: 'assets/icons/ic_pressure.png',
            //       value: '${detailInfo.current.pressure} hPa',
            //       title: 'Pressure',
            //     ),
            //   ],
            // ),
            // SizedBox(height: defaultHorizontalMargin),
            // Row(
            //   children: [
            //     DetailInfoBox(
            //       imgUrl: 'assets/icons/ic_wind_speed.png',
            //       value: '${detailInfo.current.windSpeed} km/h',
            //       title: 'Wind Speed',
            //     ),
            //     SizedBox(width: defaultHorizontalMargin),
            //     DetailInfoBox(
            //       imgUrl: 'assets/icons/ic_fog.png',
            //       value:
            //           '${detailInfo.current.visibility!.roundToDouble() / 1000} Km',
            //       title: 'Visibility',
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
