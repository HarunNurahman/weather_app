import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/air_quality/air-quality_model.dart';
import 'package:weather_app/services/api_service.dart';

part 'air_quality_event.dart';
part 'air_quality_state.dart';

class AirQualityBloc extends Bloc<AirQualityEvent, AirQualityState> {
  AirQualityBloc() : super(AirQualityInitial()) {
    on<AirQualityEvent>((event, emit) async {
      if (event is GetAirQualityEvent) {
        try {
          emit(AirQualityLoading());
          AirQualityModel airQualityModel =
              await ApiService().getAirQuality(event.lat, event.lon);
          emit(AirQualitySuccess(airQualityModel));
        } catch (e) {
          emit(AirQualityError(e.toString()));
        }
      }
    });
  }
}
