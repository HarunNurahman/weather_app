import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/search_weather_model.dart';
import 'package:weather_app/services/api_services.dart';

part 'search_weather_event.dart';
part 'search_weather_state.dart';

class SearchWeatherBloc extends Bloc<SearchWeatherEvent, SearchWeatherState> {
  SearchWeatherBloc() : super(SearchWeatherInitial()) {
    on<SearchWeatherEvent>((event, emit) async {
      if (event is SearchWeatherEventStarted) {
        emit(SearchWeatherLoading());
        try {
          final searchResult = await ApiServices().searchWeather(event.query);
          emit(SearchWeatherSuccess(searchResult as SearchWeatherModel));
        } catch (e) {
          emit(SearchWeatherError(e.toString()));
        }
      }
    });
  }
}
