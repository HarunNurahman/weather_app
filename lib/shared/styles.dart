import 'package:flutter/material.dart';

// App Color
Color blackColor = const Color(0xFF201D1D);
Color blackColor2 = const Color(0xFF201C1C);
Color blackColor3 = const Color(0xFF242222);
Color blackColor4 = const Color(0xFF242425);

Color whiteColor = const Color(0xFFFFFFFF);
Color whiteColor2 = const Color(0xFFEEEBEB);

Color grayColor = const Color(0xFF494343);
Color grayColor2 = const Color(0xFFE4E4E4);

Color blueColor = const Color(0xFF4F80FA);
Color blueColor2 = const Color(0xFF3C6EEF);
Color blueColor3 = const Color(0xFF158C96);
Color blueColor4 = const Color(0xFFD2DFFF);
Color blueColor5 = const Color(0xFF9AB6FF);
Color blueColor6 = const Color(0xFF4F7FFA);
Color blueColor7 = const Color(0xFF335FD1);

Color greenColor = const Color(0xFF2AA837);

Color transparent = Colors.transparent;

Color yellowColor = const Color(0xFFFFCF23);
Color orangeColor = const Color(0xFFFEA120);
Color redColor = const Color(0xFFDC0703);
Color purpleColor = const Color(0xFF5B255F);
Color maroonColor = const Color(0xFF722221);

// App Text Style
TextStyle whiteTextStyle = TextStyle(
  fontFamily: 'SF Pro Display',
  color: whiteColor,
);
TextStyle blackTextStyle = TextStyle(
  fontFamily: 'SF Pro Display',
  color: blackColor,
);

// App Font Weight
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

// Capitalize Text Extension
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}