import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/services/api_services.dart';

class GlobalController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxDouble _lat = 0.0.obs;
  final RxDouble _lon = 0.0.obs;

  RxBool checkLoading() => isLoading;
  RxDouble getLat() => _lat;
  RxDouble getLon() => _lon;

  @override
  void onInit() {
    if (isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  final weatherData = WeatherData().obs;
  WeatherData getData() {
    return weatherData.value;
  }

  refreshData() async {
    getLocation();
    weatherData.value = await ApiServices().getWeather(_lat.value, _lon.value);
    isLoading.value = false;
    return weatherData.value;
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      // return Future.error("Please enable location service");
      return ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enable location service",
          ),
        ),
      );
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // return Future.error(
      //   "Location permission is denied, please enable on setting",
      // );
      return ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "Location permission is denied, please enable on setting",
          ),
        ),
      );
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        // return Future.error("Location permission is denied, please try again");
        return ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permission is denied, please try again",
            ),
          ),
        );
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((value) {
      _lat.value = value.latitude;
      _lon.value = value.longitude;
      return ApiServices()
          .getWeather(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        isLoading.value = false;
      });
    });
  }
}
