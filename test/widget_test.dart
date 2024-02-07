import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/pages/dashboard_page.dart';
import 'package:weather_app/pages/search_result_page.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Dashboard Page widget test', (WidgetTester tester) async {
      // FAKE FIRECORE INITIALIZATION
      setupFirebaseCoreMocks();
      await Firebase.initializeApp();

      TestWidgetsFlutterBinding.ensureInitialized();

      // BUILD THE DASHBOARDPAGE WIDGET BY PUMPING IT INTO THE WIDGET TESTER.
      await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

      // CHECK IF WIDGETS ARE FOUND IN THE WIDGET TREE.
      expect(find.byType(DashboardPage), findsWidgets);

      // CHECK IF CERTAIN WIDGETS ARE FOUND IN THE WIDGET TREE.
      expect(
        find.byType(Scaffold),
        findsOneWidget,
      ); // CHECK IF THERE IS EXACTLY ONE SCAFFOLD WIDGET.

      expect(
        find.byType(GestureDetector),
        findsWidgets,
      ); // CHECK IF THERE ARE ANY GESTURE DETECTOR WIDGET.

      expect(
        find.byType(SingleChildScrollView),
        findsWidgets,
      ); // CHECK IF THERE ARE ANY SINGLECHILDSCROLLVIEW WIDGET.

      expect(
        find.byType(Column),
        findsWidgets,
      ); // CHECK IF THERE ARE ANY COLUMN WIDGETS.
    });

    testWidgets('Search Result Page widget test', (WidgetTester tester) async {
      // BUILD THE SEARCHRESULTPAGE WIDGET BY PUMPING IT INTO THE WIDGET TESTER.
      await tester.pumpWidget(
        const MaterialApp(
          home: SearchResultPage(
            lat: -6.9396,
            lon: 107.6203,
            cityName: 'Bandung',
          ),
        ),
      );

      // CHECK IF CERTAIN WIDGETS ARE FOUND IN THE WIDGET TREE.
      expect(
        find.byType(Scaffold),
        findsOneWidget,
      ); // CHECK IF THERE IS EXACTLY ONE SCAFFOLD WIDGET.

      expect(
        find.byType(AppBar),
        findsOneWidget,
      ); // CHECK IF THERE IS EXACTLY ONE APPBAR WIDGET.

      expect(
        find.byType(SingleChildScrollView),
        findsOneWidget,
      ); // CHECK IF THERE IS EXACTLY ONE SINGLECHILDSCROLLVIEW WIDGET.

      expect(
        find.byType(Column),
        findsWidgets,
      ); // CHECK IF THERE ARE ANY COLUMN WIDGETS.
    });
  });
}
