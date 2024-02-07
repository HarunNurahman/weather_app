import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/services/api_services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/models/weather_data.dart';
import 'package:weather_app/models/search_weather_model.dart';
import 'package:weather_app/models/air_pollution_model.dart';

// A MOCK CLASS FOR APISERVICE
class MockApiServices extends Mock implements ApiServices {}

void main() {
  final apiServices = MockApiServices();

  group('ApiServices Tests', () {
    // Test getWeather method
    test('returns WeatherData on successful weather fetch', () async {
      final fakeWeatherData = WeatherData();
      when(() => apiServices.getWeather(any(), any()))
          .thenAnswer((_) async => fakeWeatherData);

      final result = await apiServices.getWeather(-6.9396, 107.6203);

      expect(result, equals(fakeWeatherData));
    });

    // Test searchWeather method
    test('returns SearchWeatherModel on successful weather search', () async {
      // Arrange
      final fakeSearchWeatherModel =
          SearchWeatherModel(/*...*/); // Add necessary fake data
      when(() => apiServices.searchWeather(any()))
          .thenAnswer((_) async => fakeSearchWeatherModel);

      // Act
      final result = await apiServices.searchWeather('query');

      // Assert
      expect(result, equals(fakeSearchWeatherModel));
    });

    // Test getAirPollution method
    test('returns AirPollutionModel on successful air pollution fetch',
        () async {
      // Arrange
      final fakeAirPollutionModel = AirPollutionModel(
        status: 'success',
        data: Data(
          city: 'Bandung',
          state: 'West Java',
          country: 'Indonesia',
          location: Location(type: 'Point', coordinates: [-6.9396, 107.6203]),
          current: Current(
            pollution: Pollution(
              ts: DateTime.now(),
              aqius: 50,
              mainus: 'Good',
              aqicn: 1,
              maincn: 'Hujan Ringan',
            ),
          ),
        ),
      ); // Add necessary fake data
      when(() => apiServices.getAirPollution(any(), any()))
          .thenAnswer((_) async => fakeAirPollutionModel);

      // Act
      final result = await apiServices.getAirPollution(-6.9396, 107.6203);

      // Assert
      expect(result, equals(fakeAirPollutionModel));
    });
  });
}
