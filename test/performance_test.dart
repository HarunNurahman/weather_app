import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/services/api_services.dart';
import 'package:http/http.dart' as http;

void main() async {
  setupFirebaseCoreMocks();
  await Firebase.initializeApp();
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Application Performance Tests', () {
    late ApiServices apiServices;
    late http.Client client;
    setUp(() {
      client = http.Client();
      apiServices = ApiServices();
    });

    test('Loading Time Performance Test', () async {
      final Stopwatch stopwatch = Stopwatch()..start();
      await apiServices.getWeather(-6.9396, 107.6203);
      stopwatch.stop();
      print('Weather API loading time: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('Response Time Performance Test', () async {
      final Stopwatch stopwatch = Stopwatch()..start();
      final response = await client.get(
        Uri.parse(
            'https://api.openweathermap.org/data/3.0/onecall?lat=-6.9396&lon=107.6203&appid=2c8848a279b83b708bd1998475800a02&units=metric&exclude=minutely'),
      );
      stopwatch.stop();
      print('API response time: ${stopwatch.elapsedMilliseconds}ms');
      expect(response.statusCode, 200);
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('API Interaction Performance Test', () async {
      final Stopwatch stopwatch = Stopwatch()..start();
      final result = await apiServices.searchWeather('Bandung');
      stopwatch.stop();
      print(
          'Search Weather API interaction time: ${stopwatch.elapsedMilliseconds}ms');
      expect(result, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    tearDown(() {
      client.close();
    });
  });
}
