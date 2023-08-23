class AirPollutionModel {
  Main main;
  Map<String, double> components;
  int dt;

  AirPollutionModel({
    required this.main,
    required this.components,
    required this.dt,
  });

  factory AirPollutionModel.fromJson(Map<String, dynamic> json) =>
      AirPollutionModel(
        main: Main.fromJson(json["main"]),
        components: Map.from(json["components"])
            .map((k, v) => MapEntry<String, double>(k, v?.toDouble())),
        dt: json["dt"],
      );

  Map<String, dynamic> toJson() => {
        "main": main.toJson(),
        "components":
            Map.from(components).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "dt": dt,
      };
}

class Main {
  int aqi;

  Main({
    required this.aqi,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        aqi: json["aqi"],
      );

  Map<String, dynamic> toJson() => {
        "aqi": aqi,
      };
}
