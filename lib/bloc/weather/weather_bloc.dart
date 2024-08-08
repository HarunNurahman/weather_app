import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/forecast/forecast_model.dart';
import 'package:weather_app/models/weather/weather_model.dart';
import 'package:weather_app/services/api_service.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      if (event is GetWeatherEvent) {
        try {
          emit(WeatherLoading());
          WeatherModel weatherModel = await ApiService().getWeather(
            event.lat,
            event.lon,
          );

          emit(WeatherSuccess(weatherModel));
        } catch (e) {
          emit(WeatherError(e.toString()));
        }
      }
    });
  }
}
