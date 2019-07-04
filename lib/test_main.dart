import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/weather_model.dart';
import 'package:intl/intl.dart';

Future<Weather> fetchWeather() async {
  final response = await http.get("https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=44f9f099f38f499d40fc9ae277aabe33");

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Weather.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

void main() => runApp(MyApp(weather: fetchWeather()));

class MyApp extends StatelessWidget {
  final Future<Weather> weather;

  MyApp({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Weather>(
            future: weather,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Text(snapshot.data.name),
                    Text(snapshot.data.overalls.main),
                    Text(fahrenheit(snapshot.data.numbers.temp)),
                    Image.network("https://openweathermap.org/img/w/${snapshot.data.overalls.icon}.png"),
                    Text(utcDate(snapshot.data.currentTime)),
                    Text(utcTime(snapshot.data.currentTime)),
                  ],
                );
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  //Compute fahrenheit or celsius from kelvin reading in weather api depending on user preference
  String fahrenheit(double input){
    double result;
    result = input * (9/5) - 459.67;

    String temp = "${result.toStringAsFixed(2)} °F";
    return temp;
  }
  String celsius(double input){
    double result;
    result = input - 273.15;

    String temp = "${result.toStringAsFixed(2)} °C";
    return temp;
  }

  //get date and time string from given json value in weather api
  String utcDate(int unx){
    var result;
    unx = unx * 1000;
    result = DateTime.fromMillisecondsSinceEpoch(unx).toLocal();
    result = DateFormat("MM-dd-yyyy").format(result);
    return result.toString();
  }
  String utcTime(int unx){
    var result;
    unx = unx * 1000;
    result = DateTime.fromMillisecondsSinceEpoch(unx).toLocal();
    result = DateFormat("hh:mm").format(result);
    return result.toString();
  }

}