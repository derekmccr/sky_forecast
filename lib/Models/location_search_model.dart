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

class PlacesViewModel {
  static List<Places> places;

  static Future loadPlaces() async {
    try {
      places = new List<Places>();
      String jsonString = await rootBundle.loadString("assets/city.list.json");
      var categoryJson = json.decode(jsonString);
      for (int i = 0; i < categoryJson.length; i++) {
        places.add(new Places.fromJson(categoryJson[i]));
      }
    }
    catch (e) {
      print(e);
    }
  }
}