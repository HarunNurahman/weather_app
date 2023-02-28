part of 'forecast_bloc.dart';

abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastSuccess extends ForecastState {
  final List<ForecastWeatherModel> forecastWeather;
  const ForecastSuccess(this.forecastWeather);

  @override
  List<Object> get props => [forecastWeather];
}

class ForecastError extends ForecastState {
  final String errorMessage;
  const ForecastError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
