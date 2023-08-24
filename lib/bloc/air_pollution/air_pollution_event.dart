part of 'air_pollution_bloc.dart';

abstract class AirPollutionEvent extends Equatable {
  const AirPollutionEvent();
}

class AirPollutionEventStarted extends AirPollutionEvent {
  final double lat;
  final double lon;
  const AirPollutionEventStarted(this.lat, this.lon);

  @override
  List<Object?> get props => [];
}
