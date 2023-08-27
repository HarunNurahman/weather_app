import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/air_pollution_model.dart';
import 'package:weather_app/services/api_services.dart';

part 'air_pollution_event.dart';
part 'air_pollution_state.dart';

class AirPollutionBloc extends Bloc<AirPollutionEvent, AirPollutionState> {
  AirPollutionBloc() : super(AirPollutionBlocInitial()) {
    on<AirPollutionEvent>((event, emit) async {
      if (event is AirPollutionEventStarted) {
        emit(AirPollutionBlocLoading());
        try {
          AirPollutionModel airPollution;
          airPollution =
              (await ApiServices().getAirPollution()) as AirPollutionModel;

          emit(AirPollutionSuccess(airPollution));
        } catch (e) {
          emit(AirPollutionError(e.toString()));
        }
      }
    });
  }
}
