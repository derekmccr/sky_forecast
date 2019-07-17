import 'weather_model.dart';

class Forecast{
  final List list;

  Forecast({this.list});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List list = new List();

    for (dynamic e in json['list']) {
      Weather w = new Weather(
          overalls: Overall.fromJson(e["weather"][0]),
          numbers: Number.fromJson(e["main"]),
          visibility: e["visibility"] as int,
          winds: Wind.fromJson(e["wind"]),
          currentTime: DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000, isUtc: false).toLocal(),
          systems: Sys.fromJson(e["sys"]),
          timezone: e["timezone"] as int,
          name: json["name"]);
      list.add(w);
    }

    return Forecast(
      list: list,
    );
  }

}