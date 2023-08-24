part of 'air_pollution_bloc.dart';

abstract class AirPollutionState extends Equatable {
  const AirPollutionState();

  @override
  List<Object> get props => [];
}

class AirPollutionInitial extends AirPollutionState {}

class AirPollutionLoading extends AirPollutionState {}

class AirPollutionSuccess extends AirPollutionState {
  final AirPollutionModel result;
  const AirPollutionSuccess(this.result);

  @override
  List<Object> get props => [result];
}

class AirPollutionError extends AirPollutionState {
  final String errorMessage;
  const AirPollutionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
