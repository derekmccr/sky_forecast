/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/location_search_model.dart';
import '../Models/weather_model.dart';
import '../Models/forecast_model.dart';
import '../Services/weather_api.dart';
import '../Services/forecast_api.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preferences.dart';
import 'settings.dart';
import '../Models/location_database_model.dart';*/

//TODO: layout
//TODO: bottom forecast cards
//TODO: change api fetch from this page to location list page
//TODO: add favorite button to toggle if want location saved or not

//page for create contact form, data will be sent to local database
/*class SavedLocationPage extends StatefulWidget {
  final Location item;
  SavedLocationPage({Key key, this.item}) : super(key: key);

  @override
  _SavedLocationPageState createState() => _SavedLocationPageState();
}

class _SavedLocationPageState extends State<SavedLocationPage> {
  // TEMP VALUE PLEASE DELETE LATER
  final int hold = 0;

  final WeatherApi api = WeatherApi();

  @override
  Widget build(BuildContext context) {
    //want appBar to be transparent and share background of whole page, thus need for use of stack
    return Stack(
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
          body: FutureBuilder(
            future: api.fetchWeather(widget.item.locId),
            builder: _pageView,
          )
        )
      ],
    );
  }















  Widget _pageView(BuildContext context, AsyncSnapshot<dynamic> snapshot){
    if(snapshot.hasData) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _renderBody(context, snapshot),
              )
            ),
            SafeArea(
              minimum: EdgeInsets.all(8.0),
              child: Container(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _renderBody(context, snapshot),
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      );
    }
    else if(snapshot.hasError){
      return Text("${snapshot.error}");
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> _renderBody(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    var result = List<Widget>();
    result.add(Text(snapshot.data.name));
    result.add(Text(snapshot.data.overalls.main));
    result.add(Text(temp(snapshot.data.numbers.temp)));
    result.add(Image.network("https://openweathermap.org/img/w/${snapshot.data.overalls.icon}.png"));
    result.add(Text(DateFormat("MM-dd-yyyy").format(snapshot.data.currentTime)));
    result.add(Text(DateFormat("hh:mm").format(snapshot.data.currentTime)));
    /*result.add(IconButton(
        icon: Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {}
    ));*/
    return result;
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
}*/

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
    return Stack(
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
    );
  }

  Widget _currentWeatherView(BuildContext context, Weather weatherData){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _renderBody(context, weatherData),
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



  List<Widget> _renderBody(BuildContext context, Weather item) {
    var result = List<Widget>();
    result.add(Text(item.name));
    result.add(Text(item.overalls.main));
    result.add(Text(temp(item.numbers.temp)));
    result.add(Image.network("https://openweathermap.org/img/w/${item.overalls.icon}.png"));
    result.add(Text(DateFormat("MM-dd-yyyy").format(item.currentTime)));
    result.add(Text(DateFormat("hh:mm a").format(item.currentTime)));
    result.add(IconButton(
        icon: Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {}
    ));
    return result;
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