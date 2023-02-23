import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_data_current.dart';

import '../../../config/styles.dart';

class WeatherInfoWidget extends StatefulWidget {
  final WeatherDataCurrent currentWeather;
  const WeatherInfoWidget({super.key, required this.currentWeather});

  @override
  State<WeatherInfoWidget> createState() => _WeatherInfoWidgetState();
}

class _WeatherInfoWidgetState extends State<WeatherInfoWidget> {
  String dateFormat = DateFormat('EEEEE, dd MMMM yyyy').format(DateTime.now());
  String timeFormat = DateFormat.Hms().format(DateTime.now());

  Timer? time;

  // Auto-update waktu (hh:mm:ss)
  @override
  void initState() {
    time = Timer.periodic(
      const Duration(seconds: 1),
      (t) => update(),
    );
    super.initState();
  }

  void update() {
    setState(() {
      timeFormat = DateFormat.Hms().format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultVerticalMargin),
      padding: EdgeInsets.all(defaultVerticalMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultRadius),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F7FFA),
            Color(0xFF335FD1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tanggal dan Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateFormat, style: whiteTextStyle),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    timeFormat,
                    style: whiteTextStyle,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: defaultVerticalMargin),
          // Suhu dan Status Cuaca
          Row(
            children: [
              // Icon cuaca
              Image.asset(
                'assets/icons/weathers/${widget.currentWeather.current.weather![0].icon}.png',
                width: 64,
              ),
              SizedBox(width: defaultRadius),
              // Divider
              Container(
                height: 50,
                width: 1,
                color: whiteColor.withOpacity(0.5),
              ),
              SizedBox(width: defaultRadius),
              // Informasi cuaca
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.currentWeather.current.temp}°C',
                    style: whiteTextStyle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.currentWeather.current.weather![0].description
                        .toString()
                        .toTitleCase(),
                    style: whiteTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semibold,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: defaultVerticalMargin),
          Text(
            'Feels Like ${widget.currentWeather.current.feelsLike}°C',
            style: whiteTextStyle,
          )
        ],
      ),
    );
  }
}
