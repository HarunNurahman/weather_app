// class City {
//   City({
//     this.id,
//     this.name,
//     this.coord,
//     this.country,
//     this.population,
//     this.timezone,
//     this.sunrise,
//     this.sunset,
//   });

//   int? id;
//   String? name;
//   Coord? coord;
//   String? country;
//   int? population;
//   int? timezone;
//   int? sunrise;
//   int? sunset;

//   factory City.fromJson(Map<String, dynamic> json) => City(
//         id: json["id"],
//         name: json["name"],
//         coord: Coord.fromJson(json["coord"]),
//         country: json["country"],
//         population: json["population"],
//         timezone: json["timezone"],
//         sunrise: json["sunrise"],
//         sunset: json["sunset"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "coord": coord!.toJson(),
//         "country": country,
//         "population": population,
//         "timezone": timezone,
//         "sunrise": sunrise,
//         "sunset": sunset,
//       };
// }

// class Coord {
//   Coord({
//     this.lat,
//     this.lon,
//   });

//   double? lat;
//   double? lon;

//   factory Coord.fromJson(Map<String, dynamic> json) => Coord(
//         lat: json["lat"].toDouble(),
//         lon: json["lon"].toDouble(),
//       );

//   Map<String, dynamic> toJson() => {
//         "lat": lat,
//         "lon": lon,
//       };
// }

class ForecastWeatherModel {
  ForecastWeatherModel({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
  });

  int? dt;
  Main? main;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  double? pop;

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) =>
      ForecastWeatherModel(
        dt: json["dt"],
        main: Main.fromJson(json["main"]),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        clouds: Clouds.fromJson(json["clouds"]),
        wind: Wind.fromJson(json["wind"]),
        visibility: json["visibility"],
        pop: json["pop"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main!.toJson(),
        "weather": List<dynamic>.from(weather!.map((x) => x.toJson())),
        "clouds": clouds!.toJson(),
        "wind": wind!.toJson(),
        "visibility": visibility,
        "pop": pop,
      };
}

class Clouds {
  Clouds({
    this.all,
  });

  int? all;

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

class Main {
  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? seaLevel;
  int? grndLevel;
  int? humidity;
  int? tempKf;

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
        feelsLike: json["feels_like"].toDouble(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
        pressure: json["pressure"],
        seaLevel: json["sea_level"],
        grndLevel: json["grnd_level"],
        humidity: json["humidity"],
        tempKf: json["temp_kf"],
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
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  int? id;
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

class Wind {
  Wind({
    this.speed,
    this.deg,
    this.gust,
  });

  double? speed;
  int? deg;
  double? gust;

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"].toDouble(),
        deg: json["deg"],
        gust: json["gust"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
      };
}
