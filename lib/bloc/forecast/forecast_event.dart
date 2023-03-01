part of 'forecast_bloc.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();
}

class ForecastEventStarted extends ForecastEvent {
  final String cityName;
  const ForecastEventStarted(this.cityName);

  @override
  List<Object?> get props => [];
}
