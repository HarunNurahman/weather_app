import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/weather_data_hourly.dart';
import 'package:weather_app/pages/widgets/hourly/weather_hourly_box.dart';

class WeatherHourlyWidget extends StatefulWidget {
  final WeatherDataHourly weatherHourly;
  const WeatherHourlyWidget({super.key, required this.weatherHourly});

  @override
  State<WeatherHourlyWidget> createState() => _WeatherHourlyWidgetState();
}

class _WeatherHourlyWidgetState extends State<WeatherHourlyWidget> {
  @override
  Widget build(BuildContext context) {
    Widget weatherHourlyList() {
      return SizedBox(
        height: 115,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return WeatherHourlyBox(
              temp: widget.weatherHourly.hourly[index].temp!,
              timeStamp: widget.weatherHourly.hourly[index].dt!,
              index: index,
              imgUrl: widget.weatherHourly.hourly[index].weather![0].icon!,
            );
          },
          separatorBuilder: (context, index) => VerticalDivider(
            color: transparent,
            width: 10,
          ),
          itemCount: widget.weatherHourly.hourly.length >= 6
              ? 6
              : widget.weatherHourly.hourly.length,
        ),
      );
    }

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
          weatherHourlyList(),
        ],
      ),
    );
  }
}
