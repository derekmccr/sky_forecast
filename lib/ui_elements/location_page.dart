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
          body: FutureBuilder(
            future: api.fetchWeather(),
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
    result.add(Text(fahrenheit(snapshot.data.numbers.temp)));
    result.add(Image.network("https://openweathermap.org/img/w/${snapshot.data.overalls.icon}.png"));
    result.add(Text(DateFormat("MM-dd-yyyy").format(snapshot.data.currentTime)));
    result.add(Text(DateFormat("hh:mm").format(snapshot.data.currentTime)));
    result.add(IconButton(
        icon: Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {}
    ));
    return result;
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
}
