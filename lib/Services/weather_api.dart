import 'dart:async';
import 'dart:convert';

import '../Models/weather_model.dart';
import 'package:http/http.dart' as http;

//TODO: create a future for current weather and a future for 5-day forecast

class WeatherApi{

  Future<Weather> fetchWeather(int search) async {
    final response = await http.get("https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=44f9f099f38f499d40fc9ae277aabe33");

    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

    // If the call to the server was successful, parse the JSON.
    return Weather.fromJson(json.decode(response.body));
  }
}
