class Weather {
  List<Overall> overalls;
  Number numbers;
  int visibility;
  Wind winds;
  Sys systems;
  int timezone;
  String name;

  Weather({this.overalls, this.numbers, this.visibility, this.winds, this.systems, this.timezone, this.name});

  factory Weather.fromJson(Map<String, dynamic> json) {
    var list = json["weather"];
    List<Overall> overalls = list.map((i) => Overall.fromJson(i)).toList();

    return Weather(
      overalls: overalls,
      numbers: Number.fromJson(json["main"]),
      visibility: json["visibility"],
      winds: Wind.fromJson(json["wind"]),
      systems: Sys.fromJson(json["sys"]),
      timezone: json["timezone"],
      name: json["name"]
    );
  }
}

class Overall{
  String id;
  String main;
  String description;
  String icon;

  Overall({this.id, this.main, this.description, this.icon});

  factory Overall.fromJson(Map<String, dynamic> json){
    return Overall(
      id: json["id"],
      main: json["main"],
      description: json["description"],
      icon: json["icon"]
    );
  }
}

class Number{
  double temp;
  double pressure;
  int humidity;
  double tempMin;
  double tempMax;

  Number({this.temp, this.pressure, this.humidity, this.tempMin, this.tempMax});

  factory Number.fromJson(Map<String, dynamic> json){
    return Number(
      temp: json["temp"],
      pressure: json["pressure"],
      humidity: json["humidity"],
      tempMin: json["temp_min"],
      tempMax: json["temp_max"]
    );
  }
}

class Wind{
  double speed;
  double degree;

  Wind({this.speed, this.degree});

  factory Wind.fromJson(Map<String, dynamic> json){
    return Wind(
        speed: json["speed"],
        degree: json["deg"]
    );
  }
}

class Sys{
  int sunrise;
  int sunset;

  Sys({this.sunrise, this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json){
    return Sys(
      sunrise: json["sunrise"],
      sunset: json["sunset"]
    );
  }
}