import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/models/weather_data_daily.dart';
import 'package:weather_app/models/weather_data_hourly.dart';

class ApiServices {
  // final Dio _dio = Dio();

  String baseUrl(var lat, var lon) {
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&exclude=minutely';
    return url;
  }

  final String apiKey = '2c8848a279b83b708bd1998475800a02';

  WeatherData? weatherData;

  // Mengambil data cuaca berdasarkan gps
  Future<WeatherData> getWeather(lat, lon) async {
    // var response = await _dio.get(
    //   '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&exclude=minutely',
    // );
    var response = await http.get(
      Uri.parse(baseUrl(lat, lon)),
    );
    var jsonString = jsonDecode(response.body);
    weatherData = WeatherData(
      WeatherDataCurrent.fromJson(jsonString),
      WeatherDataHourly.fromJson(jsonString),
      WeatherDataDaily.fromJson(jsonString),
    );

    return weatherData!;
  }
}
