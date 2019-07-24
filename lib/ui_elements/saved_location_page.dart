import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/location_database_model.dart';
import '../Models/weather_model.dart';
import '../Models/forecast_model.dart';
import '../Services/weather_api.dart';
import '../Services/forecast_api.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preferences.dart';
import 'settings.dart';

//TODO: layout
//TODO: add favorite button to toggle if want location saved or not

//page for create contact form, data will be sent to local database
class SavedLocationPage extends StatefulWidget {
  final Location location;
  SavedLocationPage({Key key, this.location});

  @override
  _SavedLocationPageState createState() => _SavedLocationPageState();
}

class _SavedLocationPageState extends State<SavedLocationPage> {
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
  Widget build(BuildContext context) {
    //want appBar to be transparent and share background of whole page, thus need for use of stack
    /*return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          //this decorations sets background of full page
          decoration: new BoxDecoration(
            color: Colors.blueGrey,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.home),
                onPressed: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
            ),
            title: Text("Weather"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: (){
                  Navigator.push(context,
                    MyCustomRoute(builder: (context) => SettingsPage()),
                  );
                },
              )
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Center(
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
      ],
    );*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xFF363640),
        leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: (){
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
        ),
        title: Text("Weather"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: (){
              Navigator.push(context,
                MyCustomRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: new Color(0xFF363640)
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
        Text(weatherData.name, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(weatherData.overalls.description, style: TextStyle(fontSize: 18.0, color: Colors.white)),
        Image.network("https://openweathermap.org/img/w/${weatherData.overalls.icon}.png"),
        Text(temp(weatherData.numbers.temp), style: TextStyle(fontSize: 18.0, color: Colors.white)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 2.5),
          child: Divider(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Temp Min", style: TextStyle(color: Colors.white)),
                  Text(temp(weatherData.numbers.tempMin), style: TextStyle(color: Colors.white)),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Temp Max", style: TextStyle(color: Colors.white)),
                  Text(temp(weatherData.numbers.tempMax), style: TextStyle(color: Colors.white)),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Sunrise", style: TextStyle(color: Colors.white)),
                  Text(DateFormat("hh:mm a").format(weatherData.systems.sunrise), style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Wind", style: TextStyle(color: Colors.white)),
                  Text("sw ${weatherData.winds.speed.toString()} M/s", style: TextStyle(color: Colors.white)),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Visibility", style: TextStyle(color: Colors.white)),
                  Text("${weatherData.visibility} Mt", style: TextStyle(color: Colors.white)),
                  Padding(padding: EdgeInsets.only(bottom: 10.0)),
                  Text("Sunset", style: TextStyle(color: Colors.white)),
                  Text(DateFormat("hh:mm a").format(weatherData.systems.sunrise), style: TextStyle(color: Colors.white))
                ],
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(Icons.refresh),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(item.overalls.main),
            Text(temp(item.numbers.temp)),
            Image.network("https://openweathermap.org/img/w/${item.overalls.icon}.png"),
            Text(DateFormat("MM-dd-yyyy").format(item.currentTime)),
            Text(DateFormat("hh:mm a").format(item.currentTime)),
          ],
        ),
      ),
    );
  }

  //Compute fahrenheit or celsius from kelvin reading in weather api depending on user preference
  String temp(double input){
    String metric = PrefService.getString("temp_metric");
    double result;
    if(metric == "f"){
      result = input * (9/5) - 459.67;
      String temp = "${result.toStringAsFixed(2)} °F";
      return temp;
    }
    else{
      result = input - 273.15;
      String temp = "${result.toStringAsFixed(2)} °C";
      return temp;
    }
  }

  loadWeather() async {
    setState(() {
      isLoading = true;
    });

    //do stuff
    final weatherResponse = await http.get("https://api.openweathermap.org/data/2.5/weather?id=${widget.location.locId.toString()}&APPID=44f9f099f38f499d40fc9ae277aabe33");
    final forecastResponse = await http.get("https://api.openweathermap.org/data/2.5/forecast?id=${widget.location.locId.toString()}&APPID=44f9f099f38f499d40fc9ae277aabe33");

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