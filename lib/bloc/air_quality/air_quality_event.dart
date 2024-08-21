part of 'air_quality_bloc.dart';

sealed class AirQualityEvent extends Equatable {
  const AirQualityEvent();

  @override
  List<Object> get props => [];
}

class GetAirQualityEvent extends AirQualityEvent {
  final double lat;
  final double lon;
  const GetAirQualityEvent(this.lat, this.lon);

  @override
  List<Object> get props => [lat, lon];
}
