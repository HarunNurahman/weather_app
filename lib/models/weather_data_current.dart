class WeatherDataCurrent {
  final Current current;
  WeatherDataCurrent({required this.current});

  factory WeatherDataCurrent.fromJson(Map<String, dynamic> json) =>
      WeatherDataCurrent(current: Current.fromJson(json['current']));
}

class Current {
  int? sunrise;
  int? sunset;
  int? temp;
  int? humidity;
  int? clouds;
  int? pressure;
  int? visibility;
  int? feelsLike;
  double? uvi;
  double? windSpeed;
  List<Weather>? weather;

  Current({
    this.sunrise,
    this.sunset,
    this.temp,
    this.humidity,
    this.clouds,
    this.pressure,
    this.visibility,
    this.feelsLike,
    this.uvi,
    this.windSpeed,
    this.weather,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        sunrise: json['sunrise'] as int?,
        sunset: json['sunset'] as int?,
        temp: (json['temp'] as num?)?.round(),
        humidity: json['humidity'] as int?,
        clouds: json['clouds'] as int?,
        pressure: json['pressure'] as int?,
        visibility: json['visibility'] as int?,
        feelsLike: (json['feels_like'] as num?)?.round(),
        uvi: (json['uvi'] as num?)!.toDouble(),
        windSpeed: (json['wind_speed'] as num?)?.toDouble(),
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'temp': temp,
        'humidity': humidity,
        'clouds': clouds,
        'pressure': pressure,
        'visibility': visibility,
        'feels_like': feelsLike,
        'uvi': uvi,
        'wind_speed': windSpeed,
        'weather': weather?.map((e) => e.toJson()).toList(),
      };
}

class Weather {
  int? id;
  String? main;
  String? description;
  String? icon;

  Weather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json['id'] as int?,
        main: json['main'] as String?,
        description: json['description'] as String?,
        icon: json['icon'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}
