import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Color List
Color blackColor = const Color(0xFF201D1D);
Color blackColor2 = const Color(0xFF201C1C);
Color blackColor3 = const Color(0xFF242222);
Color blackColor4 = const Color(0xFF242425);

Color whiteColor = const Color(0xFFFFFFFF);
Color whiteColor2 = const Color(0xFFEEEBEB);

Color grayColor = const Color(0xFF494343);

Color blueColor = const Color(0xFF4F80FA);
Color blueColor2 = const Color(0xFF3C6EEF);
Color blueColor3 = const Color(0xFF158C96);
Color blueColor4 = const Color(0xFFD2DFFF);
Color blueColor5 = const Color(0xFF9AB6FF);

Color greenColor = const Color(0xFF2AA837);

Color transparent = Colors.transparent;

Color yellowColor = Colors.yellow;
Color orangeColor = Colors.deepOrange;
Color redColor = Colors.redAccent;
Color purpleColor = Colors.deepPurple;

// Text Style List
TextStyle whiteTextStyle = TextStyle(
  fontFamily: 'SF Pro Display',
  color: whiteColor,
);
TextStyle blackTextStyle = TextStyle(
  fontFamily: 'SF Pro Display',
  color: blackColor,
);

// Font Weight List
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

// Default Margin dan Default Radius Value
double defaultHorizontalMargin = 16.0;
double defaultVerticalMargin = 24.0;
double defaultRadius = 12.0;

// Kapital pada huruf pertama
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

// App Format (format tanggal)
class AppFormat {
  static String dateFormat(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);

    return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(dateTime);
  }
}
