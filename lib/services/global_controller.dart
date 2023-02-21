import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/services/api_services.dart';

class GlobalController extends GetxController {
  final RxDouble lat = 0.0.obs; // Kirim nilai lat ke API
  final RxDouble lon = 0.0.obs; // Kirim nilai lon ke API
  final RxBool isLoading = true.obs;

  RxDouble getLat() => lat;
  RxDouble getLon() => lon;
  RxBool checkLoading() => isLoading;

  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  final weatherData = WeatherData().obs;
  WeatherData getData() {
    return weatherData.value;
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    // Apabila location service tidak diizinkan
    if (!isServiceEnabled) {
      return Future.error('Please Enable Location Service');
    }

    // Cek location service permission
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(
        'Location Permission is Denied, Please Enable on Settings',
      );
    } else if (locationPermission == LocationPermission.denied) {
      // request ulang location permission
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location Permission is Denied, Please Try Again');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((value) {
      lat.value = value.latitude;
      lon.value = value.longitude;

      return ApiServices()
          .getWeather(value.latitude, value.longitude)
          .then((value) {
        weatherData.value;
      });
    });
  }
}
