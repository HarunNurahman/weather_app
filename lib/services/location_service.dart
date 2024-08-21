import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  double? _latitude;
  double? _longitude;

  factory LocationService() => _instance;

  LocationService._internal();

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  /// Sets the default location of the device.
  ///
  /// This function is used when location permission is denied.
  /// It sets the latitude and longitude to a default value and displays a toast message to the user.
  ///
  /// Parameters: None
  ///
  /// Returns: None
  void _setDefaultLocation() {
    _latitude = -6.175389038073123;
    _longitude = 106.8271567748102;
    Fluttertoast.showToast(
      msg: "Location permission is denied. Default location is used.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

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

    // Check if location services are enabled.
    if (!serviceEnabled) {
      _setDefaultLocation();
      return;
    }

    // Check location permission
    // If permission is denied, request it only once.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Handle different permission states.
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _setDefaultLocation();
      return;
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
      // Ensure that location is updated before proceeding
      await getLocation();

      if (_latitude != null && _longitude != null) {
        await FirebaseFirestore.instance.collection('users').doc(token).update({
          'location': GeoPoint(_latitude!, _longitude!),
        });
      } else {
        throw Exception('Failed to get location data.');
      }
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    // Handle background fetch events
    String taskId = task.taskId;

    try {
      // Fetch the user's location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch all users' tokens from Firestore
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Iterate through each user document
      for (var doc in userSnapshot.docs) {
        // Update the user's location in Firestore
        await doc.reference.update({
          'location': GeoPoint(position.latitude, position.longitude),
        });
      }
    } catch (e) {
      print('Error: $e');
    }

    BackgroundFetch.finish(taskId);
  }

  void initPlatformState() async {
    // Initialize background fetch
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15, // Set the interval in minutes
          stopOnTerminate: false,
          enableHeadless: true,
        ), (String taskId) async {
      // Fetch the user's location and update Firestore
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Fetch all users' tokens from Firestore
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Iterate through each user document
      for (var doc in userSnapshot.docs) {
        // Update the user's location in Firestore
        await doc.reference.update({
          'location': GeoPoint(position.latitude, position.longitude),
        });
      }

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // This is the headless task handler. It will be called if the app is terminated.
      print('Headless event received.');
      BackgroundFetch.finish(taskId);
    });

    // Register background fetch headless task
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }
}
