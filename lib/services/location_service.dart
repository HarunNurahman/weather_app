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

  // Retrieves the current location of the device.
  //
  // This function checks if location services are enabled and if the necessary permissions are granted.
  // If location services are disabled or permissions are denied, it throws an exception.
  // Otherwise, it retrieves the current position with high accuracy and updates the latitude and longitude fields.
  //
  // Returns a Future that completes when the location is retrieved.
  //
  // Throws an exception if location services are disabled or permissions are denied.
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

  // Updates the location of a user in the Firestore database.
  //
  // This function takes a token as a parameter, retrieves the current location of the device,
  // and updates the corresponding user document in the 'users' collection with the new location.
  //
  // The location is represented as a GeoPoint object, which contains the latitude and longitude.
  //
  // If an error occurs during the update process, it is caught and printed to the console.
  //
  // Parameters:
  //   token (String): The token of the user whose location is to be updated.
  //
  // Returns:
  //   Future<void>: A Future that completes when the location is updated.
  Future<void> updateUserLocation(String token) async {
    try {
      await getLocation();

      FirebaseFirestore.instance.collection('users').doc(token).update({
        'location': GeoPoint(_latitude!, _longitude!),
      });
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }
}
