import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/styles.dart';
import 'package:weather_app/pages/widgets/search_delegate.dart';
import 'package:weather_app/pages/widgets/weather_daily_box.dart';
import 'package:weather_app/pages/widgets/weather_hourly_box.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('EEEEE, dd MMMM yyyy').format(DateTime.now());
    String time = DateFormat.Hm().format(DateTime.now());

    // Header Widget (Lokasi saat ini & search button)
    Widget header() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lokasi
          Row(
            children: [
              Icon(Icons.location_on, size: 24, color: whiteColor),
              SizedBox(width: defaultRadius),
              Text(
                'Regol, Bandung',
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              )
            ],
          ),
          // Search button
          GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
            child: Icon(
              Icons.search,
              size: 24,
              color: whiteColor,
            ),
          ),
        ],
      );
    }

    // Widget informasi cuaca terkini di lokasi yang terdeteksi
    Widget weatherInfo() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
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
            // Tanggal dan Waktu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: whiteTextStyle),
                Text(time, style: whiteTextStyle)
              ],
            ),
            SizedBox(height: defaultVerticalMargin),
            // Suhu dan Status Cuaca
            Row(
              children: [
                // Icon cuaca
                Image.asset('assets/icons/weathers/09d.png', width: 64),
                SizedBox(width: defaultRadius),
                // Informasi cuaca
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '18°C',
                      style: whiteTextStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hujan Berawan',
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
            Text('Feels Like 23°C', style: whiteTextStyle)
          ],
        ),
      );
    }

    // Widget informasi cuaca beberapa jam kedepan
    Widget weatherHourly() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cuaca Per Jam',
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: medium,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 111,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return const WeatherHourlyBox(
                    imgUrl: 'assets/icons/weathers/09d.png',
                    temp: '21°C',
                    time: '16:00',
                  );
                },
                separatorBuilder: (context, index) => VerticalDivider(
                  color: transparent,
                  width: 10,
                ),
                itemCount: 8,
              ),
            )
          ],
        ),
      );
    }

    // Widget informasi cuaca 3/5 hari kedepan
    Widget weatherDaily() {
      return Container(
        margin: EdgeInsets.only(top: defaultVerticalMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Harian',
              style: whiteTextStyle.copyWith(
                fontSize: 20,
                fontWeight: medium,
              ),
            ),
            SizedBox(height: defaultHorizontalMargin),
            Column(
              children: const [
                WeatherDailyBox(),
                WeatherDailyBox(),
                WeatherDailyBox(),
              ],
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: defaultVerticalMargin,
              horizontal: defaultHorizontalMargin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                weatherInfo(),
                weatherHourly(),
                weatherDaily(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
