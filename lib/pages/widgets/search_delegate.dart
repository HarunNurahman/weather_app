import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/search_weather/search_weather_bloc.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/models/search_weather_model.dart';
import 'package:weather_app/pages/search_result_page.dart';

class MySearchDelegate extends SearchDelegate {
  String getTime(final timeStamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String value = DateFormat('Hm').format(time);

    return value;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: blackColor,
        elevation: 0,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: whiteTextStyle.copyWith(
          decoration: TextDecoration.none,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: whiteColor,
        selectionColor: blueColor,
      ),
      hintColor: whiteColor,
    );
  }

  // DELETE BUTTON
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

  // BACK BUTTON
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_rounded),
      );

  // BUILD SEARCH RESULT
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
            // LOADING STATE
            return Container(
              color: blackColor,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: blueColor,
                  ),
                ),
              ),
            );
          } else if (state is SearchWeatherSuccess) {
            // SUCCESS STATE
            // SEARCH RESULT BOX
            SearchWeatherModel search = state.searchResult;
            return Scaffold(
              backgroundColor: blackColor,
              body: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchResultPage(
                        lat: search.coord!.lat!,
                        lon: search.coord!.lon!,
                        cityName: search.name!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: defaultVerticalMargin,
                    horizontal: defaultHorizontalMargin,
                  ),
                  height: 210,
                  padding: EdgeInsets.all(defaultVerticalMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultRadius),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4F7FFA),
                        Color(0xFF335FD1),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CITY NAME
                      Text(
                        search.name!,
                        style: whiteTextStyle.copyWith(fontWeight: bold),
                      ),
                      SizedBox(height: defaultVerticalMargin),
                      Row(
                        children: [
                          // WEATHER ICON
                          Image.asset(
                            'assets/icons/weathers/${search.weather![0].icon}.png',
                            width: 64,
                          ),
                          SizedBox(width: defaultRadius),
                          // DIVIDER
                          Container(
                            height: 50,
                            width: 1,
                            color: whiteColor.withOpacity(0.5),
                          ),
                          SizedBox(width: defaultRadius),
                          // TEMP AND WEATHER DESCRIPTION
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${search.main!.temp}°C',
                                style: whiteTextStyle.copyWith(fontSize: 20),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                search.weather![0].description!.toCapitalized(),
                                style: whiteTextStyle.copyWith(
                                  fontSize: 20,
                                  fontWeight: semibold,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: defaultVerticalMargin),
                      // FEELS LIKE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Feels Like ${search.main!.feelsLike}°C',
                            style: whiteTextStyle,
                          ),
                          Text(
                            'Last Updated at ${getTime(search.dt)}',
                            style: whiteTextStyle.copyWith(fontSize: 10),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            // ERROR STATE
            return Container(
              color: blackColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/city-error-state.svg',
                      width: 196,
                    )
                  ],
                ),
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
