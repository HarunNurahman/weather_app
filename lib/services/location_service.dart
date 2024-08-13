import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  double? _latitude;
  double? _longitude;

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _latitude = position.latitude;
    _longitude = position.longitude;
  }

  Future<void> updateUserLocation(String token) async {
    try {
      await getLocation();

      FirebaseFirestore.instance.collection('users').doc(token).update({
        'location': GeoPoint(_latitude!, _longitude!),
      });
    } catch (e) {
      print('Failed to update location: $e');
    }
  }
}
