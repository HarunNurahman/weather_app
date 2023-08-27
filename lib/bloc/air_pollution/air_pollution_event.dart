part of 'air_pollution_bloc.dart';

abstract class AirPollutionEvent extends Equatable {
  const AirPollutionEvent();
}

class AirPollutionEventStarted extends AirPollutionEvent {
  @override
  List<Object?> get props => [];
}
