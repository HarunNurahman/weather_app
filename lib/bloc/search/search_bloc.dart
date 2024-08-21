import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/forecast/forecast_model.dart';
import 'package:weather_app/services/api_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is SearchWeatherEvent) {
        try {
          emit(SearchLoading());
          ForecastModel forecast = await ApiService().getForecast(event.query);
          emit(SearchSuccess(forecast));
        } catch (e) {
          emit(SearchFailed(e.toString()));
        }
      }
    });
  }
}
