import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/search/search_bloc.dart';
import 'package:weather_app/models/forecast/forecast_model.dart';
import 'package:weather_app/pages/search-result_page.dart';
import 'package:weather_app/shared/styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(),
      child: Scaffold(
        appBar: appBar(searchController.text),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(
                child: CircularProgressIndicator(color: blueColor),
              );
            }

            if (state is SearchFailed) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: whiteTextStyle,
                ),
              );
            }

            if (state is SearchSuccess) {
              ForecastModel forecast = state.forecast;
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                children: [
                  // Search Result
                  //// Search result card if location is found by user
                  searchResult(
                    city: forecast.city!.name,
                    imgUrl: forecast.list![0].weather![0].icon,
                    temp: forecast.list![0].main!.temp!.round(),
                    description: forecast.list![0].weather![0].description!
                        .toCapitalized(),
                    tempMax: forecast.list![0].main!.tempMax!.round(),
                    tempMin: forecast.list![0].main!.tempMin!.round(),
                    feelsLike: forecast.list![0].main!.feelsLike!.round(),
                    // Go to search result page
                    ontap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchResultPage(),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  AppBar appBar(String query) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: whiteColor),
      ),
      title: TextField(
        controller: searchController,
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            context.read<SearchBloc>().add(SearchWeatherEvent(query));
          }
        },
        style: whiteTextStyle.copyWith(fontWeight: medium),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: whiteTextStyle.copyWith(fontWeight: medium),
          border: InputBorder.none,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            searchController.clear();
          },
          icon: Icon(Icons.close, color: whiteColor),
        ),
      ],
    );
  }

  Widget searchResult({
    VoidCallback? ontap,
    String? city,
    String? imgUrl,
    int? temp,
    String? description,
    int? tempMin,
    int? tempMax,
    int? feelsLike,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [blueColor6, blueColor7],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Name
            Text(
              city!,
              style: whiteTextStyle.copyWith(
                fontSize: 16,
                fontWeight: bold,
              ),
            ),
            const SizedBox(height: 12),
            // Temperature and weather icon
            Row(
              children: [
                // Weather icon
                Image.asset('assets/icons/weathers/$imgUrl.png', width: 72),
                const SizedBox(width: 12),
                // Temperature
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$temp° C',
                        style: whiteTextStyle.copyWith(fontSize: 24),
                      ),
                      Text(
                        description!,
                        style: whiteTextStyle.copyWith(
                          fontSize: 22,
                          fontWeight: semibold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Highest, lowest and feels like temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$tempMax° / $tempMin° Feels Like $feelsLike° C',
                  style: whiteTextStyle.copyWith(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}