part of 'air_quality_bloc.dart';

sealed class AirQualityState extends Equatable {
  const AirQualityState();

  @override
  List<Object> get props => [];
}

final class AirQualityInitial extends AirQualityState {}

final class AirQualityLoading extends AirQualityState {}

final class AirQualitySuccess extends AirQualityState {
  final AirQualityModel airQuality;
  const AirQualitySuccess(this.airQuality);

  @override
  List<Object> get props => [airQuality];
}

final class AirQualityError extends AirQualityState {
  final String errorMessage;
  const AirQualityError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
