part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchSuccess extends SearchState {
  final ForecastModel forecast;
  const SearchSuccess(this.forecast);

  @override
  List<Object> get props => [forecast];
}

final class SearchFailed extends SearchState {
  final String errorMessage;
  const SearchFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
