import 'package:flutter/material.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/weather_data_daily.dart';
import 'package:weather_app/pages/widgets/daily/weather_daily_box.dart';

class WeatherDailyWidget extends StatefulWidget {
  final WeatherDataDaily dailyWeather;
  const WeatherDailyWidget({super.key, required this.dailyWeather});

  @override
  State<WeatherDailyWidget> createState() => _WeatherDailyWidgetState();
}

class _WeatherDailyWidgetState extends State<WeatherDailyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultVerticalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harian',
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
    );
  }
}
