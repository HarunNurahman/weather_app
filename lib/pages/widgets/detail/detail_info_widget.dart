import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_app/bloc/air_pollution/air_pollution_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_box.dart';

class DetailInfoWidget extends StatefulWidget {
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
  State<DetailInfoWidget> createState() => _DetailInfoWidgetState();
}

class _DetailInfoWidgetState extends State<DetailInfoWidget> {
  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String value = DateFormat('Hm').format(time);

    return value;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.detailInfo.current.sunrise);
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
              'Detail Information',
              style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: medium),
            ),
            SizedBox(height: defaultHorizontalMargin),
            // Widget polusi udara
            BlocBuilder<AirPollutionBloc, AirPollutionState>(
              builder: (context, state) {
                if (state is AirPollutionLoading) {
                  return Shimmer.fromColors(
                    baseColor: blackColor4,
                    highlightColor: grayColor,
                    child: Container(
                      width: 345,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        color: blackColor4,
                      ),
                    ),
                  );
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
                          progressColor: airPollutionModel.data.current.pollution.aqius <=
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
                                              : airPollutionModel.data.current
                                                              .pollution.aqius >
                                                          300 &&
                                                      airPollutionModel
                                                              .data
                                                              .current
                                                              .pollution
                                                              .aqius <=
                                                          500
                                                  ? maroonColor
                                                  : null,
                          percent:
                              airPollutionModel.data.current.pollution.aqius /
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
                                          airPollutionModel.data.current.pollution.aqius <=
                                              100
                                      ? yellowColor
                                      : airPollutionModel.data.current.pollution.aqius > 100 &&
                                              airPollutionModel.data.current
                                                      .pollution.aqius <=
                                                  150
                                          ? orangeColor
                                          : airPollutionModel.data.current.pollution.aqius > 150 &&
                                                  airPollutionModel.data.current
                                                          .pollution.aqius <=
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
                                                  : airPollutionModel
                                                                  .data
                                                                  .current
                                                                  .pollution
                                                                  .aqius >
                                                              300 &&
                                                          airPollutionModel
                                                                  .data
                                                                  .current
                                                                  .pollution
                                                                  .aqius <=
                                                              500
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (airPollutionModel
                                      .data.current.pollution.aqius <=
                                  50) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ] else if (airPollutionModel
                                          .data.current.pollution.aqius >
                                      50 &&
                                  airPollutionModel
                                          .data.current.pollution.aqius <=
                                      100) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ] else if (airPollutionModel
                                          .data.current.pollution.aqius >
                                      100 &&
                                  airPollutionModel
                                          .data.current.pollution.aqius <=
                                      150) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ] else if (airPollutionModel
                                          .data.current.pollution.aqius >
                                      150 &&
                                  airPollutionModel
                                          .data.current.pollution.aqius <=
                                      200) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ] else if (airPollutionModel
                                          .data.current.pollution.aqius >
                                      200 &&
                                  airPollutionModel
                                          .data.current.pollution.aqius <=
                                      300) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ],
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
                DetailInfoBox(
                  imgUrl: 'assets/icons/ic_humid.png',
                  value: '${widget.detailInfo.current.humidity}%',
                  title: 'Humidity',
                ),
                DetailInfoBox(
                  imgUrl: getTime(widget.detailInfo.current.sunrise!) == getTime(widget.detailInfo.current.sunset!)
                      ? 'assets/icons/ic_sunrise.png'
                      : 'assets/icons/ic_sunset.png',
                  value: getTime(widget.detailInfo.current.sunrise!) == getTime(widget.detailInfo.current.sunset!)
                      ? getTime(widget.detailInfo.current.sunrise!)
                      : getTime(widget.detailInfo.current.sunset!),
                  title: getTime(widget.detailInfo.current.sunrise!) == getTime(widget.detailInfo.current.sunset!)
                      ? 'Sunrise'
                      : 'Sunset',
                ),

                DetailInfoBox(
                  imgUrl: 'assets/icons/ic_wind_speed.png',
                  value: '${widget.detailInfo.current.windSpeed} km/h',
                  title: 'Wind Speed',
                ),
                DateTime.now().hour > 6 && DateTime.now().hour <= 18
                    ? DetailInfoBox(
                        imgUrl: 'assets/icons/ic_uvi.png',
                        value: '${widget.detailInfo.current.uvi}',
                        title: 'UV Index',
                      )
                    : DetailInfoBox(
                        imgUrl: 'assets/icons/ic_fog.png',
                        value: '${widget.detailInfo.current.clouds}%',
                        title: 'Cloudiness',
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
