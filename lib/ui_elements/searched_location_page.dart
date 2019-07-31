import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/location_search_model.dart';
import '../Models/weather_model.dart';
import '../Models/forecast_model.dart';
import '../Services/weather_api.dart';
import '../Services/forecast_api.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preferences.dart';
import 'styles.dart';
import 'app_bar_for_search.dart';

//page when user chooses location from search
class SearchedLocationPage extends StatefulWidget {
  final Places place;
  SearchedLocationPage({Key key, this.place});

  @override
  _SearchedLocationPageState createState() => _SearchedLocationPageState();
}

class _SearchedLocationPageState extends State<SearchedLocationPage> {
  bool isLoading = false;
  Weather weatherData;
  Forecast forecastData;
  final WeatherApi currentWeather = WeatherApi();
  final ForecastApi forecastWeather = ForecastApi();
  String error;

  @override
  void initState() {
    super.initState();

    loadWeather();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchedAppBarWidget(item: widget.place),
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
          ),
          child: Center(
            child: isLoading ? CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ) : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: weatherData != null ? _currentWeatherView(context, weatherData) : Container(child: Text("Weather Unavailable."),)
                ),
                SafeArea(
                    minimum: EdgeInsets.all(8.0),
                    child: forecastData != null ? _forecastWeatherView(context, forecastData) : Container(child: Text("Forecast Unavailable."),)
                )
              ],
            ),
          ),
        )
    );
  }

  Widget _currentWeatherView(BuildContext context, Weather weatherData){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(weatherData.name, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: "Muli")),
        Text(temp(weatherData.numbers.temp), style: TextStyle(fontSize: 24.0, color: Colors.white, fontFamily: "Muli")),
        Text(weatherData.overalls.description, style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "Muli")),
        Image.network("https://openweathermap.org/img/w/${weatherData.overalls.icon}.png"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 2.5),
          child: Divider(color: const Color(0xFF1EB980)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Temp Min", style: Styles.infoSmall),
                  Text(temp(weatherData.numbers.tempMin), style: Styles.metricReading),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Temp Max", style: Styles.infoSmall),
                  Text(temp(weatherData.numbers.tempMax), style: Styles.metricReading),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Sunrise", style: Styles.infoSmall),
                  Text(DateFormat("hh:mm a").format(weatherData.systems.sunrise), style: Styles.metricReading),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Wind", style: Styles.infoSmall),
                  Text("${deg(weatherData.winds.degree)} ${mPh(weatherData.winds.speed)}", style: Styles.metricReading),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Visibility", style: Styles.infoSmall),
                  Text("${miles(weatherData.visibility)} mi.", style: Styles.metricReading),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Sunset", style: Styles.infoSmall),
                  Text(DateFormat("hh:mm a").format(weatherData.systems.sunset), style: Styles.metricReading)
                ],
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(Icons.refresh, color: const Color(0xFF1EB980)),
            tooltip: 'Refresh',
            onPressed: () {
              loadWeather();
            }
        )
      ],
    );
  }

  Widget _forecastWeatherView(BuildContext context, Forecast forecastData){
    return Container(
      height: 200.0,
      child: ListView.builder(
          itemCount: forecastData.list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _renderCard(context, forecastData.list.elementAt(index))),
    );
  }

  Widget _renderCard(BuildContext context, Weather item){
    return Card(
      color: Color.fromRGBO(54, 54, 64, .7),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(temp(item.numbers.temp), style: Styles.cardInfo),
            Padding(padding: const EdgeInsets.only(bottom: 5.0)),
            Text(item.overalls.main, style: Styles.cardInfo),
            Padding(padding: const EdgeInsets.only(bottom: 5.0)),
            Image.network("https://openweathermap.org/img/w/${item.overalls.icon}.png"),
            Text(DateFormat("MM-dd-yyyy").format(item.currentTime), style: Styles.cardInfo),
            Padding(padding: const EdgeInsets.only(bottom: 2.5)),
            Text(DateFormat("hh:mm a").format(item.currentTime), style: Styles.cardInfo),
          ],
        ),
      ),
    );
  }

  //Metric Conversions
  //Compute fahrenheit or celsius from kelvin reading in weather api depending on user preference
  String temp(double input){
    String metric = PrefService.getString("temp_metric");
    double result;
    if(metric == "f"){
      result = input * (9/5) - 459.67;
      String temp = "${result.toStringAsFixed(0)} °F";
      return temp;
    }
    else{
      result = input - 273.15;
      String temp = "${result.toStringAsFixed(0)} °C";
      return temp;
    }
  }

  //Meter to Miles
  String miles(int input){
    double mile;
    mile = input * 0.000621;

    String result;
    result = mile.toStringAsFixed(1);
    return result;
  }

  //degree translation
  String deg(double input){
    if((input < 25.0 && input >= 0.0) || (input >= 335.0 && input <= 360.0))
      return "n";
    else if(input >= 25.0 && input < 70.0)
      return "ne";
    else if(input >= 70.0 && input < 115.0)
      return "e";
    else if(input >= 115.0 && input < 160.0)
      return "se";
    else if(input >= 160.0 && input < 205.0)
      return "s";
    else if(input >= 205.0 && input < 250.0)
      return "sw";
    else if(input >= 250.0 && input < 290.0)
      return "w";
    else
      return "nw";
  }

  //M/s to mph
  String mPh(double input){
    double mph;
    mph = input * 2.2369;

    String result;
    result = "${mph.toStringAsFixed(1)} mph";
    return result;
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    //do stuff
    final weatherResponse = await http.get("https://api.openweathermap.org/data/2.5/weather?id=${widget.place.id.toString()}&APPID=44f9f099f38f499d40fc9ae277aabe33");
    final forecastResponse = await http.get("https://api.openweathermap.org/data/2.5/forecast?id=${widget.place.id.toString()}&APPID=44f9f099f38f499d40fc9ae277aabe33");

    if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
      return setState(() {
        weatherData = Weather.fromJson(jsonDecode(weatherResponse.body));
        forecastData = Forecast.fromJson(jsonDecode(forecastResponse.body));
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }
}

//this class ONLY controls animation between pages
//NO NEED FOR FURTHER MODIFICATION
class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}