import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../Models/weather_model.dart';
import 'package:http/http.dart' as http;

Future<Weather> fetchPost() async {
  final response = await http.get("api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=44f9f099f38f499d40fc9ae277aabe33");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Weather.fromJson(json.decode(response.body));
  }
  else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}