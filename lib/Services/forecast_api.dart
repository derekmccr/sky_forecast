import 'dart:async';
import 'dart:convert';

import '../Models/forecast_model.dart';
import 'package:http/http.dart' as http;

class ForecastApi{

  Future<Forecast> fetchForecast(int search) async {
    final response = await http.get("https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=44f9f099f38f499d40fc9ae277aabe33");

    if (response.statusCode != 200) {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

    // If the call to the server was successful, parse the JSON.
    return Forecast.fromJson(json.decode(response.body));
  }
}
