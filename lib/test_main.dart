import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/weather_model.dart';

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
                    Text(snapshot.data.numbers.temp.toString()),
                    Image.network("https://openweathermap.org/img/w/'${snapshot.data.overalls.icon}'.png"),
                    Text(snapshot.data.currentTime.toLocal().toString()),
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
}