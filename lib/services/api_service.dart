import 'dart:convert';

import 'package:weather_app/models/air_quality/air-quality_model.dart';
import 'package:weather_app/models/forecast/forecast_model.dart';
import 'package:weather_app/models/weather/weather-current_model.dart';
import 'package:weather_app/models/weather/weather-daily_model.dart';
import 'package:weather_app/models/weather/weather-hourly_model.dart';
import 'package:weather_app/models/weather/weather_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // OpenWeatherMap API
  String owmApiKey = '2c8848a279b83b708bd1998475800a02';
  String owmSearchUrl = 'https://api.openweathermap.org/data/2.5';
  String owmBaseUrl(lat, lon) {
    String url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$owmApiKey&units=metric&exclude=minutely';
    return url;
  }

  // IQ Air API
  String iqAirApiKey = '4d51d89e-cf0a-4ee5-960c-f37bbb0a0131';
  String airQualityUrl(lat, lon) {
    String url =
        'http://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$lon&key=$iqAirApiKey';
    return url;
  }

  // Retrieve weather data from the API based on the given latitude (lat) and longitude (lon) coordinates
  Future<WeatherModel> getWeather(lat, lon) async {
    try {
      // The function sends an HTTP GET request to the URL generated by the baseUrl(lat, lon) function.
      final response = await http.get(
        Uri.parse(owmBaseUrl(lat, lon)),
      );
      if (response.statusCode == 200) {
        // Responses received from the API in JSON format are parsed into Dart objects using jsonDecode.
        var jsonString = jsonDecode(response.body);

        // The parsed JSON data is then used to create a WeatherModel object
        WeatherModel weather = WeatherModel(
          WeatherCurrentModel.fromJson(jsonString),
          WeatherHourlyModel.fromJson(jsonString),
          WeatherDailyModel.fromJson(jsonString),
        );

        return weather;
      }

      throw Exception('Failed to get weather data');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ForecastModel> getForecast(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$owmSearchUrl/forecast?q=$query&appid=$owmApiKey&units=metric',
        ),
      );
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        return ForecastModel.fromJson(jsonString);
      }

      throw Exception('Failed to get forecast data');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Retrieve air quality data from the API based on the given latitude (lat) and longitude (lon) coordinates
  Future<AirQualityModel> getAirQuality(lat, lon) async {
    try {
      final response = await http.get(Uri.parse(airQualityUrl(lat, lon)));
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        return AirQualityModel.fromJson(jsonString);
      }

      throw Exception('Failed to get air quality data');
    } catch (e) {
      throw Exception(e);
    }
  }
}