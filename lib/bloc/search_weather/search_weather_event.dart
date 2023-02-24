part of 'search_weather_bloc.dart';

abstract class SearchWeatherEvent extends Equatable {
  const SearchWeatherEvent();
}

class SearchWeatherEventStarted extends SearchWeatherEvent {
  final String query;
  const SearchWeatherEventStarted(this.query);

  @override
  List<Object?> get props => [];
}
