import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/services/api_services.dart';

class GlobalController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxDouble _lat = 0.0.obs;
  final RxDouble _lon = 0.0.obs;

  // GETTER FUNCTION
  RxBool checkLoading() => isLoading;
  RxDouble getLat() => _lat;
  RxDouble getLon() => _lon;

  // INITIALIZE LOCATION
  @override
  void onInit() {
    if (isLoading.isTrue) {
      getLocation();
    }
    super.onInit();
  }

  // GET WEATHER DATA
  final weatherData = WeatherData().obs;
  WeatherData getData() {
    return weatherData.value;
  }

  // REFRESH FUNCTION
  refreshData() async {
    getLocation();
    weatherData.value = await ApiServices().getWeather(_lat.value, _lon.value);
    isLoading.value = false;
    return weatherData.value;
  }

  // GET LOCATION FUNCTION FROM GEOLOCATOR
  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    // CHECK IF LOCATION ACCESS IS ENABLED
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enable location service",
          ),
        ),
      );
    }

    // CHECK LOCATION PERMISSION
    locationPermission = await Geolocator.checkPermission();

    // IF LOCATION PERMISSION IS DENIED
    if (locationPermission == LocationPermission.deniedForever) {
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
        return ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permission is denied, please try again",
            ),
          ),
        );
      }
    }

    // IF LOCATION PERMISSION IS GRANTED
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
