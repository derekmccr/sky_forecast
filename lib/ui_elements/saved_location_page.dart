import 'package:flutter/material.dart';
import '../Services/weather_api.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preferences.dart';
import '../Models/location_search_model.dart';

//TODO: layout
//TODO: bottom forecast cards
//TODO: change api fetch from this page to location list page
//TODO: add favorite button to toggle if want location saved or not

//page for create contact form, data will be sent to local database
class SavedLocationPage extends StatefulWidget {
  final Places place;
  SavedLocationPage({Key key, this.place}) : super(key: key);

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
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: FutureBuilder(
            future: api.fetchWeather(hold),
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
    print(metric);
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
