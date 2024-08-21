part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchWeatherEvent extends SearchEvent {
  final String query;
  const SearchWeatherEvent(this.query);

  @override
  List<Object> get props => [query];
}
