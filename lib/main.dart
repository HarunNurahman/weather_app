import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app/bloc/air_quality/air_quality_bloc.dart';
import 'package:weather_app/bloc/search/search_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';
import 'package:weather_app/firebase_options.dart';
import 'package:weather_app/pages/dashboard_page.dart';
import 'package:weather_app/services/bloc_observer.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/shared/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocationService().getLocation();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();

  initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(),
        ),
        BlocProvider(
          create: (context) => AirQualityBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: blackColor,
          appBarTheme: AppBarTheme(backgroundColor: blackColor),
        ),
        home: const DashboardPage(),
      ),
    );
  }
}
