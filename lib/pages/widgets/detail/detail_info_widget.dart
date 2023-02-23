import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/pages/widgets/detail/detail_info_box.dart';

class DetailInfoWidget extends StatelessWidget {
  final WeatherDataCurrent detailInfo;
  const DetailInfoWidget({super.key, required this.detailInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultVerticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Information',
            style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: medium),
          ),
          SizedBox(height: defaultHorizontalMargin),
          Row(
            children: [
              DetailInfoBox(
                imgUrl: 'assets/icons/ic_humid.png',
                value: '${detailInfo.current.humidity}%',
                title: 'Humidity',
              ),
              SizedBox(width: defaultHorizontalMargin),
              DetailInfoBox(
                imgUrl: 'assets/icons/ic_pressure.png',
                value: '${detailInfo.current.pressure} hPa',
                title: 'Air Pressure',
              ),
            ],
          ),
          SizedBox(height: defaultHorizontalMargin),
          Row(
            children: [
              DetailInfoBox(
                imgUrl: 'assets/icons/ic_wind_speed.png',
                value: '${detailInfo.current.windSpeed} km/h',
                title: 'Wind Speed',
              ),
              SizedBox(width: defaultHorizontalMargin),
              DetailInfoBox(
                imgUrl: 'assets/icons/ic_fog.png',
                value: '${detailInfo.current.visibility! / 1000} Km',
                title: 'Visibility',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
