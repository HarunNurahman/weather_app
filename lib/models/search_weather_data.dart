class SearchWeatherModel {
  SearchWeatherModel({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
  });

  int? dt;
  List<MainClass>? main;
  List<Weather>? weather;
  List<Clouds>? clouds;
  List<Wind>? wind;
  int? visibility;
  double? pop;

  /* (json["main"] as List<dynamic>)
            .map((e) => MainClass.fromJson(e as Map<String, dynamic>))
            .toList() 
  */

  factory SearchWeatherModel.fromJson(Map<String, dynamic> json) =>
      SearchWeatherModel(
        dt: json["dt"],
        main: (json["main"] as List<dynamic>)
            .map((e) => MainClass.fromJson(e as Map<String, dynamic>))
            .toList(),
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
            .toList(),
        clouds:
            List<Clouds>.from(json["clouds"].map((x) => Clouds.fromJson(x))),
        wind: (json["wind"] as List<dynamic>)
            .map((e) => Wind.fromJson(e as Map<String, dynamic>))
            .toList(),
        visibility: json["visibility"],
        pop: json["pop"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main?.map((e) => e.toJson()).toList(),
        "weather": weather?.map((e) => e.toJson()).toList(),
        "clouds": clouds?.map((e) => e.toJson()).toList(),
        "wind": wind?.map((e) => e.toJson()).toList(),
        "visibility": visibility,
        "pop": pop,
      };
}

class Wind {
  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  double speed;
  int deg;
  double gust;

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"]?.toDouble(),
        deg: json["deg"],
        gust: json["gust"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
      };
}

class Clouds {
  Clouds({
    required this.all,
  });

  int all;

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

class MainClass {
  MainClass({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.seaLevel,
    required this.grndLevel,
    required this.humidity,
    required this.tempKf,
  });

  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int seaLevel;
  int grndLevel;
  int humidity;
  double tempKf;

  factory MainClass.fromJson(Map<String, dynamic> json) => MainClass(
        temp: json["temp"]?.toDouble(),
        feelsLike: json["feels_like"]?.toDouble(),
        tempMin: json["temp_min"]?.toDouble(),
        tempMax: json["temp_max"]?.toDouble(),
        pressure: json["pressure"],
        seaLevel: json["sea_level"],
        grndLevel: json["grnd_level"],
        humidity: json["humidity"],
        tempKf: json["temp_kf"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
        "humidity": humidity,
        "temp_kf": tempKf,
      };
}

class Weather {
  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  int id;
  String? main;
  String? description;
  String? icon;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };
}
