import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/models/forecast_weather_model.dart';
import 'package:weather_app/models/search_weather_model.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/weather_data_current.dart';
import 'package:weather_app/models/weather_data_daily.dart';
import 'package:weather_app/models/weather_data_hourly.dart';

class ApiServices {
  final Dio _dio = Dio();
  // Create an instance of Firebase Messaging
  final firebaseMessaging = FirebaseMessaging.instance;

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
      // print('Call getWeather');
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

  // API Pencarian cuaca berdasarkan query kota
  Future<SearchWeatherModel> searchWeather(String query) async {
    try {
      // print('Call searchWeather');
      final response = await _dio
          .get('$searchUrl/weather?q=$query&appid=$apiKey&units=metric');
      SearchWeatherModel searchResult =
          SearchWeatherModel.fromJson(response.data);

      return searchResult;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // API untuk search result
  Future<List<ForecastWeatherModel>> getWeatherForecast(
    String cityName,
  ) async {
    try {
      // print('Call getWeatherForecast');

      final response = await _dio
          .get('$searchUrl/forecast?q=$cityName&appid=$apiKey&units=metric');
      var forecast = response.data["list"] as List;
      List<ForecastWeatherModel> weatherForecast =
          forecast.map((e) => ForecastWeatherModel.fromJson(e)).toList();
      return weatherForecast;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // API untuk polusi udara berdasarkan lat & lon
  Future<AirPollutionModel> getAirPollution(double lat, double lon) async {
    try {
      // print("Call getAirPollution");
      final response = await _dio.get(
        'http://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$lon&key=4d51d89e-cf0a-4ee5-960c-f37bbb0a0131',
      );
      AirPollutionModel airPollutionResult =
          AirPollutionModel.fromJson(response.data);
      return airPollutionResult;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Funtion untuk inisialisasi notifikasi
  Future<void> initNotification() async {
    // Request permission untuk menerima notifikasi
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // Mengambil FCM token
    final fCMToken = await firebaseMessaging.getToken();
    print('Token : $fCMToken');
  }
}
