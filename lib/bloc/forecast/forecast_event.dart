part of 'forecast_bloc.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();
}

class ForecastEventStarted extends ForecastEvent {
  final double lat;
  final double lon;
  const ForecastEventStarted(this.lat, this.lon);

  @override
  List<Object?> get props => [];
}
