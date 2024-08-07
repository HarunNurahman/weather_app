import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';
import 'package:weather_app/shared/styles.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ListView(
        children: [
          currentWeatherSection(),
          hourlyWeatherSection(),
          dailyWeatherSection(),
          additionalInfoSection(),
        ],
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
        'Haurgeulis',
        style: whiteTextStyle.copyWith(fontWeight: medium, fontSize: 16),
      ),
    );
  }

  Widget currentWeatherSection() {
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
            'Thursday, 1 August 2024',
            style: whiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 24),
          // Weather Icon
          Image.asset('assets/icons/weathers/01d.png', width: 72),
          const SizedBox(height: 16),
          // Temperature
          Text('20°C', style: whiteTextStyle.copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          // Weather Description
          Text(
            'Partly Cloudy',
            style: whiteTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
          ),
          const SizedBox(height: 24),
          // Highest, lowest and feels like temperature
          Text(
            '30° / 20° Feels Like 31° C',
            style: whiteTextStyle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget hourlyWeatherSection() {
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
          // Hourly Weather Item
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 0, maxHeight: 120),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget dailyWeatherSection() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
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
                        height: 60,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                      items: [
                        messageBox('Message Box'),
                        messageBox(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                        ),
                        messageBox(
                          'Aliquam eu nulla a orci congue auctor finibus sit amet arcu',
                        ),
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
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget additionalInfoSection() {
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
          // Air Quality Card
          // const AirQualityCard(),
          // Additional Info Item
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Container(),
              Container(),
              Container(),
              Container(),
            ],
          )
        ],
      ),
    );
  }

  Widget messageBox(String text) {
    return Center(
      child: Text(
        text,
        style: whiteTextStyle.copyWith(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
