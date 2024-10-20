import 'package:flutter/material.dart';

// App color
Color blackColor = const Color(0xFF201D1D);
Color blackColor2 = const Color(0xFF242222);
Color blackColor3 = const Color(0xFF242425);

Color whiteColor = const Color(0xFFFFFFFF);

Color grayColor = const Color(0xFF494343);
Color grayColor2 = const Color(0xFFE4E4E4);

Color blueColor = const Color(0xFF4F80FA);
Color blueColor2 = const Color(0xFFD2DFFF);
Color blueColor3 = const Color(0xFF9AB6FF);
Color blueColor4 = const Color(0xFF4F7FFA);
Color blueColor5 = const Color(0xFF335FD1);

Color greenColor = const Color(0xFF2AA837);

Color yellowColor = const Color(0xFFFFCF23);
Color orangeColor = const Color(0xFFFEA120);
Color redColor = const Color(0xFFDC0703);
Color purpleColor = const Color(0xFF5B255F);
Color maroonColor = const Color(0xFF722221);

// App text style
TextStyle whiteTextStyle = TextStyle(
  fontFamily: 'SF Pro Display',
  color: whiteColor,
);
TextStyle blackTextStyle = TextStyle(
  fontFamily: 'SF Pro Display',
  color: blackColor,
);

// App font weight
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

// Capitalize text extension
extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
