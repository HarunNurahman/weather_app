# Weather Forecast Application

Weather Forecast application built with Dart/Flutter. For this project, I used GetX and Flutter_Bloc as state management. For data sources, I'm using API from OpenWeatherMap API. Thanks to [Reynaldi Daniel](https://www.figma.com/@heyrey) for his UI Design as inspiration for the front end of this application, I will attach the link for his UI design right below this description.

UI Design https://www.figma.com/community/file/1055880209981553884 by [Reynaldi Daniel](https://www.figma.com/@heyrey)

## Features
1. Showing current weather by your current location using a geolocator or GPS on your phone (permission may required)
2. Showing hourly (up to 12 hours) and daily weather
3. Search based on city name

## Installation
Visit [OpenWeatherMap](https://openweathermap.org/) and register with your account.
After registering, the next step is to go to https://home.openweathermap.org/api_keys and acquire your API key.
When you acquire your API key, you can go to  ```lib/services/api_services.dart``` and change ```apiKey``` to your API key.

```String apiKey = YOUR_API_KEY```

Run the project simply by typing ```flutter run``` on your terminal

## Dependencies
- [`dio`](): ^5.0.0
- [`equatable`](): ^2.0.5
- [`flutter_bloc`](): ^8.1.2
- [`flutter_datetime_picker_plus`](): ^2.0.1
- [`flutter_local_notifications`](): ^15.1.0+1
- [`geocoding`](): ^2.0.5
- [`geolocator`](): ^9.0.2
- [`get`](): ^4.6.5
- [`google_fonts`](): ^4.0.3
- [`http`](): ^0.13.5
- [`intl`](): ^0.18.0
- [`location`](): ^4.4.0
- [ `shimmer`](): ^3.0.0
