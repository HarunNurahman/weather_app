# Weather Forecast Application

The weather forecast application was built with Dart/Flutter. For this project, I used BLoC as state management. For data sources, I'm using API from OpenWeatherMap API. Thanks to [Reynaldi Daniel](https://www.figma.com/@heyrey) for his UI Design as inspiration for the front end of this application, I will attach the link for his UI design right below this description.

UI Design https://www.figma.com/community/file/1055880209981553884 by [Reynaldi Daniel](https://www.figma.com/@heyrey)

## Features
1. Showing current weather by your current location using a geolocator or GPS on your phone (permission may required)
2. Showing hourly (up to 12 hours) and daily weather
3. Search based on city name

## Installation
Visit [OpenWeatherMap](https://openweathermap.org/) and IQAir [IQAir](https://www.iqair.com/) and register with your account.

After registering, the next step is to go to https://home.openweathermap.org/api_keys and https://dashboard.iqair.com/personal/api-keys and acquire your API key.

When you acquire your API key, you can create a file ```api_key.dart``` in ```shared``` folder

```
api_key.dart

String owmApiKey = YOUR_API_KEY
String iqAirApiKey = YOUR_API_KEY
```

Run the project simply by typing 
```
flutter pub get
flutter run
``` 
on your terminal

## Dependencies
- [`bloc`](): ^8.1.4
- [`cloud_firestore`](): ^5.0.1
- [`firebase_core`](): ^3.1.0
- [`firebase_core_platform_interface`](): ^5.0.0
- [`firebase_messaging`](): ^15.1.0
- [`flutter_bloc`](): ^8.1.6
- [`flutter_carousel_widget`](): ^2.3.0
- [`flutter_local_notifications`](): ^17.1.2
- [`fluttertoast`](): ^8.2.7
- [`geocoding`](): ^3.0.0
- [`geolocator`](): ^12.0.0
- [`http`](): ^1.2.1
- [`intl`](): ^0.19.0
- [`location`](): ^7.0.0
- [`percent_indicator`](): ^4.2.3
- [`shimmer`](): ^3.0.0
- [`url_launcher`](): ^6.3.0
- [ `shimmer`](): ^3.0.0
