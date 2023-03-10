import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/forecast_weather_model.dart';
import 'package:weather_app/models/search_weather_model.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/models/weather_data_daily.dart';
import 'package:weather_app/models/weather_data_hourly.dart';

class ApiServices {
  final Dio _dio = Dio();

  String baseUrl(var lat, var lon) {
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&exclude=minutely';
    return url;
  }

  String apiKey = '2c8848a279b83b708bd1998475800a02';
  String searchUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherData? weatherData;

  // Mengambil data cuaca berdasarkan gps
  Future<WeatherData> getWeather(lat, lon) async {
    try {
      // var response = await _dio.get(
      //   '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&exclude=minutely',
      // );
      final response = await http.get(
        Uri.parse(baseUrl(lat, lon)),
      );
      var jsonString = jsonDecode(response.body);
      weatherData = WeatherData(
        WeatherDataCurrent.fromJson(jsonString),
        WeatherDataHourly.fromJson(jsonString),
        WeatherDataDaily.fromJson(jsonString),
      );

      return weatherData!;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<SearchWeatherModel> searchWeather(String query) async {
    try {
      final response = await _dio
          .get('$searchUrl/weather?q=$query&appid=$apiKey&units=metric');
      SearchWeatherModel searchResult =
          SearchWeatherModel.fromJson(response.data);

      return searchResult;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ForecastWeatherModel>> getWeatherForecast(
    String cityName,
  ) async {
    try {
      final response = await _dio.get(
          '$searchUrl/forecast?q=$cityName&appid=$apiKey&units=metric');
      var forecast = response.data["list"] as List;
      List<ForecastWeatherModel> weatherForecast =
          forecast.map((e) => ForecastWeatherModel.fromJson(e)).toList();
      return weatherForecast;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
