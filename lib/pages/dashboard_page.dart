import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/bloc/air_quality/air_quality_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';
import 'package:weather_app/models/air_quality/air-quality_model.dart';
import 'package:weather_app/models/weather/weather_model.dart';
import 'package:weather_app/pages/search_page.dart';
import 'package:weather_app/pages/widgets/addon-info_item.dart';
import 'package:weather_app/pages/widgets/air-quality_card.dart';
import 'package:weather_app/pages/widgets/daily-weather_item.dart';
import 'package:weather_app/pages/widgets/hourly-weather_item.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/shared/app_format.dart';
import 'package:weather_app/shared/styles.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String city = ''; // Kota
  String locality = ''; // Kecamatan

  LocationService locationService = LocationService();

  // Get Address Function
  getAddress(lat, lon) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, lon);
    Placemark place = placemark[0];
    setState(() {
      city = place.subAdministrativeArea!;
      locality = place.locality!;
    });
  }

  Future<void> _initLocation() async {
    // This Function Will Request Permission To Access The User's Location And Obtain Location Data.
    await locationService.getLocation();

    // Checks If The Latitude And Longitude Of The locationService Are Not Null, Ensuring That The Location Has Been Successfully Retrieved.
    if (locationService.latitude != null && locationService.longitude != null) {
      // Calls The getAddress Function With The Retrieved Latitude And Longitude
      await getAddress(locationService.latitude!, locationService.longitude!);
      if (mounted) {
        // Sends A GetWeatherEvent Event To The WeatherBloc With Latitude And Longitude As Arguments
        context.read<WeatherBloc>().add(
              GetWeatherEvent(
                locationService.latitude!,
                locationService.longitude!,
              ),
            );

        // This Line Sends A GetAirQualityEvent Event To The AirQualityBloc With Latitude And Longitude As Arguments
        context.read<AirQualityBloc>().add(
              GetAirQualityEvent(
                locationService.latitude!,
                locationService.longitude!,
              ),
            );
      }
    }
  }

  @override
  void initState() {
    _initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return Center(
                child: CircularProgressIndicator(color: blueColor),
              );
            }

            if (state is WeatherSuccess) {
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      // User location and search button
                      headerSection(context),
                      // Current Weather Section
                      currentWeatherSection(), // Current weather information based on the user location
                      // Hourly Weather Section
                      hourlyWeatherSection(), // Hourly weather information up to 12 hours
                      // Daily Weather Section
                      dailyWeatherSection(), // Daily weather information up to 5 days and message box about weather description, etc.
                      // Additional Information Section
                      additionalInfoSection(),
                    ],
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

  Widget headerSection(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: whiteColor, size: 24),
        const SizedBox(width: 8),
        // User location
        Expanded(
          child: Text(
            '$locality, $city',
            style: whiteTextStyle.copyWith(fontWeight: medium),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          ),
          child: Icon(Icons.search, color: whiteColor, size: 24),
        ),
      ],
    );
  }

  Widget currentWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            margin: const EdgeInsets.only(top: 24),
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
                // Date and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppFormat.dateFormat(DateTime.now().toIso8601String()),
                      style: whiteTextStyle,
                    ),
                    Text(
                      AppFormat.dateTime(DateTime.now().toString()),
                      style: whiteTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Temperature and weather icon
                Row(
                  children: [
                    // Weather icon
                    Image.asset(
                      'assets/icons/weathers/${weather.current!.current.weather![0].icon}.png',
                      width: 64,
                    ),
                    const SizedBox(width: 12),
                    // Temperature
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.current!.current.temp}° C',
                            style: whiteTextStyle.copyWith(fontSize: 20),
                          ),
                          Text(
                            weather.current!.current.weather![0].description
                                .toString()
                                .toCapitalized(),
                            style: whiteTextStyle.copyWith(
                              fontSize: 20,
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
                      '${weather.daily!.daily[0].temp!.max}° / ${weather.daily!.daily[0].temp!.min}° C - Feels Like ${weather.current!.current.feelsLike!}° C',
                      style: whiteTextStyle.copyWith(fontSize: 16),
                    ),
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

  Widget hourlyWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherError) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            margin: const EdgeInsets.only(top: 24),
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
                // Hourly Weather Item
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
                      itemBuilder: (context, index) {
                        return HourlyWeatherItem(
                          imgUrl:
                              weather.hourly!.hourly[index].weather![0].icon!,
                          temp: weather.hourly!.hourly[index].temp!,
                          timeStamp: weather.hourly!.hourly[index].dt!,
                        );
                      },
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
          return Center(child: Text(state.errorMessage));
        }

        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
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
                // Daily Weather Item
                Column(
                  children: [
                    // Message Box
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
                    // Daily Weather Item
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
        if (state is WeatherSuccess) {
          WeatherModel weather = state.weather;
          return Container(
            margin: const EdgeInsets.only(top: 24),
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
                // Air Quality Card
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
                        // AQI Value
                        value: airQuality.data!.current!.pollution!.aqius!,
                        // Color Based on AQI
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
                        // Title Based on AQI
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
                // Additional Info Item
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
                    // Sunrise and Sunset Time
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
                    // Wind Speed
                    AddonItem(
                      title: 'Wind Speed',
                      value:
                          '${(weather.current!.current.windSpeed! * 10).round()} km/h',
                      imgUrl: 'ic_wind_speed',
                    ),
                    // UV Index
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
