class AirPollutionModel {
  Coord? coord;
  List<ListElement>? listElement;

  AirPollutionModel({
    this.coord,
    this.listElement,
  });

  factory AirPollutionModel.fromJson(Map<String, dynamic> json) =>
      AirPollutionModel(
        coord: Coord.fromJson(json["coord"]),
        listElement: List<ListElement>.from(
            json["list"].map((x) => AirPollutionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "coord": coord,
        "list": List<dynamic>.from(listElement!.map((e) => e.toJson()))
      };
}

class Coord {
  double? lon;
  double? lat;

  Coord({
    this.lon,
    this.lat,
  });

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        lon: json["lon"]?.toDouble(),
        lat: json["lat"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };
}

class ListElement {
  Main? main;
  Component? component;
  int? dt;

  ListElement({
    this.main,
    this.component,
    this.dt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        dt: json["dt"],
        main: Main.fromJson(json["main"]),
        component: Component.fromJson(json["components"]),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main,
        "component": component,
      };
}

class Main {
  int? aqi;
  Main({this.aqi});

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        aqi: json["aqi"],
      );

  Map<String, dynamic> toJson() => {"aqi": aqi};
}

class Component {
  double? co;
  double? no;
  double? no2;
  double? o3;
  double? so2;
  double? pm2_5;
  double? pm10;
  double? nh3;

  Component({
    this.co,
    this.no,
    this.no2,
    this.o3,
    this.so2,
    this.pm2_5,
    this.pm10,
    this.nh3,
  });

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        co: json["co"].toDouble(),
        no: json["no"].toDouble(),
        no2: json["no2"].toDouble(),
        o3: json["o3"].toDouble(),
        so2: json["so2"].toDouble(),
        pm2_5: json["pm2_5"].toDouble(),
        pm10: json["pm10"].toDouble(),
        nh3: json["nh3"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "co": co,
        "no": no,
        "no2": no2,
        "o3": o3,
        "so2": so2,
        "pm2_5": pm2_5,
        "pm10": pm10,
        "nh3": nh3,
      };
}
