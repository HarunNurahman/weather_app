part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherSuccess extends WeatherState {
  final WeatherModel weather;
  const WeatherSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}

final class WeatherError extends WeatherState {
  final String errorMessage;
  const WeatherError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
