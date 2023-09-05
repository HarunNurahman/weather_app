part of 'air_pollution_bloc.dart';

abstract class AirPollutionState extends Equatable {
  const AirPollutionState();

  @override
  List<Object> get props => [];
}

class AirPollutionInitial extends AirPollutionState {}

class AirPollutionLoading extends AirPollutionState {}

class AirPollutionSuccess extends AirPollutionState {
  final AirPollutionModel airPollutionModel;
  const AirPollutionSuccess(this.airPollutionModel);

  @override
  List<Object> get props => [airPollutionModel];
}

class AirPollutionError extends AirPollutionState {
  final String errorMessage;
  const AirPollutionError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
