import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/pages/search_result_page.dart';
import 'package:weather_app/bloc/forecast/forecast_bloc.dart';
import 'package:weather_app/bloc/air_pollution/air_pollution_bloc.dart';

void main() {
  group('Integration Tests', () {
    testWidgets('Widget communication and API interaction',
        (WidgetTester tester) async {
      setupFirebaseCoreMocks();
      await Firebase.initializeApp();

      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize the required blocs with mock data or a test instance
      final forecastBloc = ForecastBloc();
      final airPollutionBloc = AirPollutionBloc();

      // Build the SearchResultPage with the required blocs
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ForecastBloc>.value(value: forecastBloc),
            BlocProvider<AirPollutionBloc>.value(value: airPollutionBloc),
          ],
          child: const MaterialApp(
              home: SearchResultPage(
            lat: -6.9396,
            lon: 107.6203,
            cityName: 'Bandung',
          )),
        ),
      );

      // Wait for the widgets to settle
      await tester.pumpAndSettle();

      // Interact with the widgets and check for desired outcomes
      // For example: Tap a button and check if it triggers the right API call
      // ...
      final gestureDetectorFinder = find.byType(GestureDetector);
      expect(gestureDetectorFinder, findsWidgets);
      await tester.pump();

      // Clean up blocs after tests
      forecastBloc.close();
      airPollutionBloc.close();
    });
  });
}
