import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/services/api_services.dart';

part 'air_pollution_event.dart';
part 'air_pollution_state.dart';

class AirPollutionBloc extends Bloc<AirPollutionEvent, AirPollutionState> {
  AirPollutionBloc() : super(AirPollutionInitial()) {
    on<AirPollutionEvent>((event, emit) async {
      if (event is AirPollutionEventStarted) {
        emit(AirPollutionLoading());
        try {
          AirPollutionModel airPollution;
          airPollution =
              (await ApiServices().getAirPollution(event.lat, event.lon));

          emit(AirPollutionSuccess(airPollution));
        } catch (e) {
          emit(AirPollutionError(e.toString()));
        }
      }
    });
  }
}
