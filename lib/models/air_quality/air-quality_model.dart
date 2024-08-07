class AirQualityModel {
  final String? status;
  final Data? data;

  AirQualityModel({
    this.status,
    this.data,
  });

  factory AirQualityModel.fromJson(Map<String, dynamic> json) =>
      AirQualityModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final String? city;
  final String? state;
  final String? country;
  final Location? location;
  final Current? current;

  Data({
    this.city,
    this.state,
    this.country,
    this.location,
    this.current,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        city: json["city"],
        state: json["state"],
        country: json["country"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        current:
            json["current"] == null ? null : Current.fromJson(json["current"]),
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "state": state,
        "country": country,
        "location": location?.toJson(),
        "current": current?.toJson(),
      };
}

class Current {
  final Pollution? pollution;
  final Weather? weather;

  Current({
    this.pollution,
    this.weather,
  });

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        pollution: json["pollution"] == null
            ? null
            : Pollution.fromJson(json["pollution"]),
        weather:
            json["weather"] == null ? null : Weather.fromJson(json["weather"]),
      );

  Map<String, dynamic> toJson() => {
        "pollution": pollution?.toJson(),
        "weather": weather?.toJson(),
      };
}

class Pollution {
  final DateTime? ts;
  final int? aqius;
  final String? mainus;
  final int? aqicn;
  final String? maincn;

  Pollution({
    this.ts,
    this.aqius,
    this.mainus,
    this.aqicn,
    this.maincn,
  });

  factory Pollution.fromJson(Map<String, dynamic> json) => Pollution(
        ts: json["ts"] == null ? null : DateTime.parse(json["ts"]),
        aqius: json["aqius"],
        mainus: json["mainus"],
        aqicn: json["aqicn"],
        maincn: json["maincn"],
      );

  Map<String, dynamic> toJson() => {
        "ts": ts?.toIso8601String(),
        "aqius": aqius,
        "mainus": mainus,
        "aqicn": aqicn,
        "maincn": maincn,
      };
}

class Weather {
  final DateTime? ts;
  final int? tp;
  final int? pr;
  final int? hu;
  final double? ws;
  final int? wd;
  final String? ic;

  Weather({
    this.ts,
    this.tp,
    this.pr,
    this.hu,
    this.ws,
    this.wd,
    this.ic,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        ts: json["ts"] == null ? null : DateTime.parse(json["ts"]),
        tp: json["tp"],
        pr: json["pr"],
        hu: json["hu"],
        ws: json["ws"]?.toDouble(),
        wd: json["wd"],
        ic: json["ic"],
      );

  Map<String, dynamic> toJson() => {
        "ts": ts?.toIso8601String(),
        "tp": tp,
        "pr": pr,
        "hu": hu,
        "ws": ws,
        "wd": wd,
        "ic": ic,
      };
}

class Location {
  final String? type;
  final List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}
