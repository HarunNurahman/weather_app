import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/search_weather/search_weather_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/search_result_page.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: blueColor,
        elevation: 0,
      ),
      // Border Color
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      // Typing Style
      textTheme: TextTheme(
        titleLarge: whiteTextStyle.copyWith(
          decoration: TextDecoration.none,
        ),
      ),
      // Text Selection Style
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: whiteColor,
        selectionColor: blueColor,
      ),
      hintColor: whiteColor,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_rounded),
      );

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchWeatherBloc()
        ..add(
          SearchWeatherEventStarted(query),
        ),
      child: BlocBuilder<SearchWeatherBloc, SearchWeatherState>(
        builder: (context, state) {
          if (state is SearchWeatherLoading) {
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: blueColor,
                ),
              ),
            );
          } else if (state is SearchWeatherSuccess) {
            return SearchResultPage();
          } else {
            return Center(
              child: Text(
                'Kota Tidak Ditemukan',
                style: whiteTextStyle,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: blackColor,
    );
  }
}
