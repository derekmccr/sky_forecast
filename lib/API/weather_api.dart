import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../Models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherApi{
  final http.Client httpClient;

  WeatherApi({@required this.httpClient}) : assert(httpClient != null);

  Future<Weather> fetchPost() async {
    final response = await this.httpClient.get("api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=44f9f099f38f499d40fc9ae277aabe33");

    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

    // If the call to the server was successful, parse the JSON.
    final weatherJson = json.decode(response.body);
    return Weather.fromJson(weatherJson);
  }
}
