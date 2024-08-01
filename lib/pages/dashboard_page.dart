import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/widgets/addon-info_item.dart';
import 'package:weather_app/pages/widgets/air-quality_card.dart';
import 'package:weather_app/pages/widgets/daily-weather_item.dart';
import 'package:weather_app/pages/widgets/hourly-weather_item.dart';
import 'package:weather_app/shared/app_format.dart';
import 'package:weather_app/shared/styles.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                headerSection(), // User location and search button
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
        ),
      ),
    );
  }

  Widget headerSection() {
    return Row(
      children: [
        Icon(Icons.location_on, color: whiteColor, size: 24),
        const SizedBox(width: 8),
        // User location
        Expanded(
          child: Text(
            'Kota Bandung, Kecamatan Regol',
            style: whiteTextStyle.copyWith(fontWeight: medium),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.search, color: whiteColor, size: 24),
      ],
    );
  }

  Widget currentWeatherSection() {
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
              Text('Thursday, 1 August 2024', style: whiteTextStyle),
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
              Image.asset('assets/icons/weathers/01d.png', width: 64),
              const SizedBox(width: 12),
              // Temperature
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '29° C',
                      style: whiteTextStyle.copyWith(fontSize: 20),
                    ),
                    Text(
                      'Partly Cloudy',
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
                '30° / 20° Feels Like 31° C',
                style: whiteTextStyle.copyWith(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget hourlyWeatherSection() {
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
              constraints: const BoxConstraints(minHeight: 0, maxHeight: 120),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return const HourlyWeatherItem();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget dailyWeatherSection() {
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
                child: CarouselSlider(
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
                    return const DailyWeatherItem();
                  },
                ),
              )
            ],
          ),
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

  Widget additionalInfoSection() {
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
          const AirQualityCard(),
          // Additional Info Item
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              AddonItem(),
              AddonItem(),
              AddonItem(),
              AddonItem(),
            ],
          )
        ],
      ),
    );
  }
}
