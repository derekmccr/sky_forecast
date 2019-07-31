import 'dart:async';
import 'dart:convert';

import '../Models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherApi{

  fetchWeather(int id) async {
    final response = await http.get("https://api.openweathermap.org/data/2.5/weather?id=${id.toString()}&APPID=44f9f099f38f499d40fc9ae277aabe33");

    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

    // If the call to the server was successful, parse the JSON.
    return Weather.fromJson(json.decode(response.body));
  }

  Future<Weather> fetchHard() async {
    final response = await http.get("https://api.openweathermap.org/data/2.5/weather?id=2643743&APPID=44f9f099f38f499d40fc9ae277aabe33");

    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

    // If the call to the server was successful, parse the JSON.
    return Weather.fromJson(json.decode(response.body));
  }
}
