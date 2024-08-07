import 'package:weather_app/models/weather/weather-current_model.dart';
import 'package:weather_app/models/weather/weather-daily_model.dart';
import 'package:weather_app/models/weather/weather-hourly_model.dart';

class WeatherModel {
  final WeatherCurrentModel? current;
  final WeatherHourlyModel? hourly;
  final WeatherDailyModel? daily;

  WeatherModel([this.current, this.hourly, this.daily]);
  WeatherCurrentModel getCurrentWeather() => current!;
  WeatherHourlyModel getHourlyWeather() => hourly!;
  WeatherDailyModel getDailyWeather() => daily!;
}
