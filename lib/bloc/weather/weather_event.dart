part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class CurrentWeatherEvent extends WeatherEvent {
  final double lat;
  final double lon;
  const CurrentWeatherEvent(this.lat, this.lon);

  @override
  List<Object> get props => [lat, lon];
}
