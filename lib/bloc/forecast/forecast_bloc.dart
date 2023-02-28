import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/forecast_weather_model.dart';
import 'package:weather_app/services/api_services.dart';

part 'forecast_event.dart';
part 'forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(ForecastInitial()) {
    on<ForecastEvent>((event, emit) async {
      if (event is ForecastEventStarted) {
        emit(ForecastLoading());
        try {
          List<ForecastWeatherModel> forecastWeather;
          forecastWeather =
              await ApiServices().getWeatherForecast(event.lat, event.lon);
          emit(ForecastSucess(forecastWeather));
        } catch (e) {
          emit(ForecastError(e.toString()));
        }
      }
    });
  }
}
