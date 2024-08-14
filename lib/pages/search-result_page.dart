import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/bloc/air_quality/air_quality_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';
import 'package:weather_app/models/air_quality/air-quality_model.dart';
import 'package:weather_app/models/weather/weather_model.dart';
import 'package:weather_app/pages/widgets/addon-info_item.dart';
import 'package:weather_app/pages/widgets/air-quality_card.dart';
import 'package:weather_app/pages/widgets/daily-weather_item.dart';
import 'package:weather_app/pages/widgets/hourly-weather_item.dart';
import 'package:weather_app/shared/app_format.dart';
import 'package:weather_app/shared/styles.dart';

class SearchResultPage extends StatefulWidget {
  final double lat;
  final double lon;
  final String city;
  const SearchResultPage({
    super.key,
    required this.lat,
    required this.lon,
    required this.city,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String city = '';
  String province = '';

  getAddress() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      widget.lat,
      widget.lon,
    );
    Placemark place = placemark[0];
    setState(() {
      city = place.subAdministrativeArea!;
      province = place.administrativeArea!;
    });
  }

  @override
  void initState() {
    getAddress();
    context.read<WeatherBloc>().add(GetWeatherEvent(widget.lat, widget.lon));
    context.read<AirQualityBloc>().add(
          GetAirQualityEvent(widget.lat, widget.lon),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return Center(
              child: CircularProgressIndicator(color: blueColor),
            );
          }

          if (state is WeatherError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: whiteTextStyle,
              ),
            );
          }

          if (state is WeatherSuccess) {
            return ListView(
              children: [
                currentWeatherSection(),
                hourlyWeatherSection(),
                dailyWeatherSection(),
                additionalInfoSection(),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: blueColor,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: whiteColor),
      ),
      title: Text(
        '$city, $province',
        style: whiteTextStyle.copyWith(fontWeight: medium, fontSize: 20),
      ),
    );
  }

  Widget currentWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: whiteTextStyle,
            ),
          );
        }

        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            color: blueColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Date
                Text(
                  AppFormat.dateFormat(DateTime.now().toIso8601String()),
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(height: 24),
                // Weather Icon
                Image.asset(
                  'assets/icons/weathers/${weather.current!.current.weather![0].icon}.png',
                  width: 96,
                ),
                const SizedBox(height: 16),
                // Temperature
                Text(
                  '${weather.current!.current.temp!}°C',
                  style: whiteTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 4),
                // Weather description
                Text(
                  weather.current!.current.weather![0].description!
                      .toTitleCase(),
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Highest, lowest and feels like temperature
                Text(
                  '${weather.daily!.daily[0].temp!.max}° / ${weather.daily!.daily[0].temp!.min}° Feels Like ${weather.current!.current.feelsLike}° C',
                  style: whiteTextStyle.copyWith(fontSize: 16),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget hourlyWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: whiteTextStyle,
            ),
          );
        }

        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hourly',
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: medium,
                  ),
                ),
                // Hourly weather item
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 0,
                      maxHeight: 120,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: weather.hourly!.hourly.length >= 12
                          ? 12
                          : weather.hourly!.hourly.length,
                      itemBuilder: (context, index) => HourlyWeatherItem(
                        imgUrl: weather.hourly!.hourly[index].weather![0].icon!,
                        temp: weather.hourly!.hourly[index].temp!,
                        timeStamp: weather.hourly!.hourly[index].dt!,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget dailyWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: whiteTextStyle,
            ),
          );
        }

        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily',
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: medium,
                  ),
                ),
                // Daily weather item
                Column(
                  children: [
                    // Message box
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FlutterCarousel(
                        options: CarouselOptions(
                          enableInfiniteScroll: true,
                          showIndicator: false,
                          height: 60,
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                        ),
                        items: [
                          messageBox(weather.daily!.daily[0].summary!),
                          messageBox(
                            weather.current!.current.uvi! > 0.0
                                ? 'Don\'t miss the sunset!\nSunset will be at ${AppFormat.getTime(weather.current!.current.sunset!)}'
                                : 'Rise and shine!\nSunrise will be at ${AppFormat.getTime(weather.current!.current.sunset!)}',
                          ),
                          weather.current!.current.uvi! > 0.0
                              ? messageBox(
                                  weather.current!.current.uvi! <= 2
                                      ? 'UV index is low\nIt\'s great time to sunbathing outside'
                                      : weather.current!.current.uvi! > 2 &&
                                              weather.current!.current.uvi! <= 5
                                          ? 'UV index is moderate\nTry wear sunscreen or hat if you are going outside'
                                          : weather.current!.current.uvi! > 5 &&
                                                  weather.current!.current
                                                          .uvi! <=
                                                      7
                                              ? 'UV index is high\nSeek a shade, use sunscreen, slip on shirt and a hat'
                                              : 'UV index is extreme\njacket, sunscreen, and hat are must!',
                                )
                              : messageBox(''),
                        ],
                      ),
                    ),
                    // Daily weather item
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 350,
                        maxHeight: double.infinity,
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: weather.daily!.daily.length >= 5
                            ? 5
                            : weather.daily!.daily.length,
                        itemBuilder: (context, index) => DailyWeatherItem(
                          imgUrl: weather.daily!.daily[index].weather![0].icon!,
                          day: weather.daily!.daily[index].dt!,
                          desc: weather
                              .daily!.daily[index].weather![0].description!
                              .toTitleCase(),
                          highTemp: weather.daily!.daily[index].temp!.max!,
                          lowTemp: weather.daily!.daily[index].temp!.min!,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget additionalInfoSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherError) {
          return Center(
            child: Text(state.errorMessage),
          );
        }

        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(top: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Information',
                  style: whiteTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: medium,
                  ),
                ),
                // Air quality card
                BlocBuilder<AirQualityBloc, AirQualityState>(
                  builder: (context, state) {
                    if (state is AirQualityError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    }

                    if (state is AirQualitySuccess) {
                      AirQualityModel airQuality = state.airQuality;
                      return AirQualityCard(
                        // AQI value
                        value: airQuality.data!.current!.pollution!.aqius!,
                        // Color based on AQI
                        color: airQuality.data!.current!.pollution!.aqius! <= 50
                            ? greenColor
                            : airQuality.data!.current!.pollution!.aqius! >
                                        50 &&
                                    airQuality
                                            .data!.current!.pollution!.aqius! <=
                                        100
                                ? yellowColor
                                : airQuality.data!.current!.pollution!.aqius! >
                                            100 &&
                                        airQuality.data!.current!.pollution!
                                                .aqius! <=
                                            150
                                    ? orangeColor
                                    : airQuality.data!.current!.pollution!
                                                    .aqius! >
                                                150 &&
                                            airQuality.data!.current!.pollution!
                                                    .aqius! <=
                                                200
                                        ? redColor
                                        : airQuality.data!.current!.pollution!
                                                        .aqius! >
                                                    200 &&
                                                airQuality.data!.current!
                                                        .pollution!.aqius! <=
                                                    300
                                            ? purpleColor
                                            : maroonColor,
                        // Title based on AQI
                        title: airQuality.data!.current!.pollution!.aqius! <= 50
                            ? 'AQI - Good'
                            : airQuality.data!.current!.pollution!.aqius! >
                                        50 &&
                                    airQuality
                                            .data!.current!.pollution!.aqius! <=
                                        100
                                ? 'AQI - Moderate'
                                : airQuality.data!.current!.pollution!.aqius! >
                                            100 &&
                                        airQuality.data!.current!.pollution!
                                                .aqius! <=
                                            150
                                    ? 'AQI - Unhealty for Sensitive Group'
                                    : airQuality.data!.current!.pollution!
                                                    .aqius! >
                                                150 &&
                                            airQuality.data!.current!.pollution!
                                                    .aqius! <=
                                                200
                                        ? 'AQI - Unhealty'
                                        : airQuality.data!.current!.pollution!
                                                        .aqius! >
                                                    200 &&
                                                airQuality.data!.current!
                                                        .pollution!.aqius! <=
                                                    300
                                            ? 'AQI - Very Unhealthy'
                                            : 'AQI - Hazardous',
                        description: airQuality
                                    .data!.current!.pollution!.aqius! <=
                                50
                            ? 'The air quality is good and clean, and there is almost no danger.'
                            : airQuality.data!.current!.pollution!.aqius! >
                                        50 &&
                                    airQuality
                                            .data!.current!.pollution!.aqius! <=
                                        100
                                ? 'The air is in good shape. However, a small percentage of highly sensitive individuals may experience some health issue.'
                                : airQuality.data!.current!.pollution!.aqius! >
                                            100 &&
                                        airQuality.data!.current!.pollution!
                                                .aqius! <=
                                            150
                                    ? 'Members of sensitive groups may experience health effects, The general public is less likely to be affected.'
                                    : airQuality.data!.current!.pollution!
                                                    .aqius! >
                                                150 &&
                                            airQuality.data!.current!.pollution!
                                                    .aqius! <=
                                                200
                                        ? 'Some members of the general public may suffer from health effects, while members of vulnerable groups may suffer from more serious health.'
                                        : airQuality.data!.current!.pollution!
                                                        .aqius! >
                                                    200 &&
                                                airQuality.data!.current!
                                                        .pollution!.aqius! <=
                                                    300
                                            ? 'Health alert: The risk of health effects is increased for everyone.'
                                            : 'Health warning of emergency conditions: everyone is more likely to be affected.',
                      );
                    }
                    return Container();
                  },
                ),
                // Additional info item
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    // Humidity
                    AddonItem(
                      title: 'Humidity',
                      value: '${weather.current!.current.humidity.toString()}%',
                      imgUrl: 'ic_humid',
                    ),
                    // Sunrise and sunset time
                    weather.current!.current.uvi! > 0.0
                        ? AddonItem(
                            title: 'Sunset',
                            value: AppFormat.getTime(
                              weather.current!.current.sunset!,
                            ),
                            imgUrl: 'ic_sunset',
                          )
                        : AddonItem(
                            title: 'Sunrise',
                            value: AppFormat.getTime(
                              weather.current!.current.sunset!,
                            ),
                            imgUrl: 'ic_sunrise',
                          ),
                    // Wind speed
                    AddonItem(
                      title: 'Wind Speed',
                      value:
                          '${(weather.current!.current.windSpeed! * 10).round()} km/h',
                      imgUrl: 'ic_wind_speed',
                    ),
                    // UV index
                    weather.current!.current.uvi! > 0.0
                        ? AddonItem(
                            title: 'UV Index',
                            value: weather.current!.current.uvi.toString(),
                            imgUrl: 'ic_uvi',
                          )
                        : AddonItem(
                            title: 'Cloudiness',
                            value: '${weather.current!.current.clouds}%',
                            imgUrl: 'ic_fog',
                          ),
                  ],
                )
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget messageBox(String text) {
    return Center(
      child: Text(
        text,
        style: whiteTextStyle.copyWith(fontSize: 18),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
