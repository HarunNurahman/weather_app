part of 'search_weather_bloc.dart';

abstract class SearchWeatherState extends Equatable {
  const SearchWeatherState();

  @override
  List<Object> get props => [];
}

class SearchWeatherInitial extends SearchWeatherState {}

class SearchWeatherLoading extends SearchWeatherState {}

class SearchWeatherSuccess extends SearchWeatherState {
  final List<SearchWeatherModel> searchResult;
  const SearchWeatherSuccess(this.searchResult);

  @override
  List<Object> get props => [searchResult];
}

class SearchWeatherError extends SearchWeatherState {
  final String errorMessage;
  const SearchWeatherError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
