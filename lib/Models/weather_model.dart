class Weather {
  final Overall overalls;
  final Number numbers;
  final int visibility;
  final Wind winds;
  final DateTime currentTime;
  final Sys systems;
  final String name;

  Weather({this.overalls, this.numbers, this.visibility, this.winds, this.currentTime, this.systems, this.name});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      overalls: Overall.fromJson(json["weather"][0]),
      numbers: Number.fromJson(json["main"]),
      visibility: json["visibility"] as int,
      winds: Wind.fromJson(json["wind"]),
      currentTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: false).toLocal(),
      systems: Sys.fromJson(json["sys"]),
      name: json["name"]
    );
  }
}

class Overall{
  final int id;
  final String main;
  final String description;
  final String icon;

  Overall({this.id, this.main, this.description, this.icon});

  factory Overall.fromJson(Map<String, dynamic> json){
    return Overall(
      id: json["id"].toInt(),
      main: json["main"],
      description: json["description"],
      icon: json["icon"],
    );
  }
}

class Number{
  final double temp;
  final double pressure;
  final int humidity;
  final double tempMin;
  final double tempMax;

  Number({this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  factory Number.fromJson(Map<String, dynamic> json){
    return Number(
      temp: json["temp"].toDouble(),
      pressure: json["pressure"].toDouble(),
      humidity: json["humidity"].toInt(),
      tempMin: json["temp_min"].toDouble(),
      tempMax: json["temp_max"].toDouble(),
    );
  }
}

class Wind{
  final double speed;
  final double degree;

  Wind({this.speed, this.degree});

  factory Wind.fromJson(Map<String, dynamic> json){
    return Wind(
        speed: json["speed"].toDouble(),
        degree: json["deg"].toDouble(),
    );
  }
}

class Sys{
  final DateTime sunrise;
  final DateTime sunset;

  Sys({this.sunrise, this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json){
    return Sys(
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sunrise'] * 1000, isUtc: false).toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sunset'] * 1000, isUtc: false).toLocal(),
    );
  }
}