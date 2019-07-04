import 'package:flutter/material.dart';
//import '../Models/weather_model.dart';
import '../Services/weather_api.dart';
import 'package:intl/intl.dart';

//TODO: layout
//TODO: break down the column that houses information into own function
//TODO: text needs to change to variables instead of current hard-code

//page for create contact form, data will be sent to local database
class LocationPage extends StatelessWidget {
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
            title: Text("Weather"),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  //this column will hold current weather for location
                  child: FutureBuilder(
                    future: api.fetchWeather(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(snapshot.data.name),
                            Text(snapshot.data.overalls.main),
                            Text(fahrenheit(snapshot.data.numbers.temp)),
                            Image.network("https://openweathermap.org/img/w/${snapshot.data.overalls.icon}.png"),
                            Text(utcDate(snapshot.data.currentTime)),
                            Text(utcTime(snapshot.data.currentTime)),
                            IconButton(
                                icon: Icon(Icons.refresh),
                                tooltip: 'Refresh',
                                onPressed: () {}
                            ),
                          ],
                        );
                      }
                      else if(snapshot.hasError){
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    }
                  )
                ),
                //safe area ensures bottom wont be affected by phone screen obstructions
                SafeArea(
                  minimum: EdgeInsets.all(8.0),
                  child: Container(
                    height: 200.0,
                    //TODO: these cards will be housed by list builder once api connection established
                    //cards will house future forecast for location
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Orlando"),
                            Text("Rain"),
                            Text("72°F"),
                            Image.network("https://openweathermap.org/img/w/01d.png"),
                            Text("May 14, 2019"),
                            Text("1:00 PM"),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]
            )
          )
        )
      ],
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
