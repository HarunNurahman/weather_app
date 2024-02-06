import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/pages/dashboard_page.dart';
import 'package:weather_app/pages/search_result_page.dart';
import 'package:weather_app/pages/widgets/header_widget.dart'; // Import the file where the widget you want to test is located.

void main() {
  // Define the testWidgets function to start the widget test.
  testWidgets('Search Result Page widget test', (WidgetTester tester) async {
    // Build the SearchResultPage widget by pumping it into the widget tester.
    await tester.pumpWidget(const MaterialApp(
        home: SearchResultPage(
      lat: -6.9396,
      lon: 107.6203,
      cityName: 'Bandung',
    )));

    // Check if certain widgets are found in the widget tree.
    expect(find.byType(AppBar),
        findsOneWidget); // Check if there is exactly one AppBar widget.
    expect(find.byType(Scaffold),
        findsOneWidget); // Check if there is exactly one Scaffold widget.
    expect(find.byType(SingleChildScrollView),
        findsOneWidget); // Check if there is exactly one SingleChildScrollView widget.
    expect(find.byType(Column),
        findsWidgets); // Check if there are any Column widgets.
  });

  testWidgets('Dashboard Page widget test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(HeaderWidget), findsOneWidget);
  });
}
