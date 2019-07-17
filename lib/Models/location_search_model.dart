import 'dart:convert';

import 'package:flutter/services.dart';

class Places{
  int id;
  String name;
  String country;

  Places({this.id, this.name, this.country});

  factory Places.fromJson(Map<String, dynamic> parsedJson) {
    return Places(
        id: parsedJson["id"],
        name: parsedJson["name"] as String,
        country: parsedJson['country'] as String
    );
  }
}

class PlayersViewModel {
  static List<Places> places;

  static Future loadPlayers() async {
    try {
      places = new List<Places>();
      String jsonString = await rootBundle.loadString('assets/players.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['players'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        places.add(new Places.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}