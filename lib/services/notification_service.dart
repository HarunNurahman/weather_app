import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app/services/location_service.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final LocationService locationService = LocationService();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Request notification permission
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // Get FCM Token
    final fCMToken = await firebaseMessaging.getToken();
    // Save the token to cloud firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(fCMToken)
        .set({'token': fCMToken});
    // Update user location
    locationService.updateUserLocation(fCMToken!);

    AndroidInitializationSettings initSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var setting = InitializationSettings(android: initSetting);

    await notificationsPlugin.initialize(
      setting,
      onDidReceiveNotificationResponse: (details) async {
        print(details);
      },
    );
  }

  notificationDetail() => const NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          importance: Importance.max,
          priority: Priority.high,
          channelDescription: 'channelDescription',
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      );

  // Shows a notification with the given id, title, body, and payload.
  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetail(),
    );
  }
}
