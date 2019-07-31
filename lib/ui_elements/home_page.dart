import 'package:flutter/material.dart';
import '../Services/database_helper.dart';
import '../Services/weather_api.dart';
import '../Models/location_database_model.dart';
import 'saved_location_page.dart';
import 'settings.dart';
import 'search_page.dart';
import '../Models/weather_model.dart';
import 'package:preferences/preferences.dart';

//Home Page - houses list of all saved locations with brief overview for each location
class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => new _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  List<Location> items = new List();
  final dbHelper = DatabaseHelper.instance;
  final WeatherApi api = new WeatherApi();
  bool isLoading = false;

  //placeholder until api solved
  final String url = "https://openweathermap.org/img/w/01d.png";

  // TODO: work on cards & listview

  @override
  void initState() {
    super.initState();

    loadLocations();
  }

  loadLocations() async {
    setState(() {
      isLoading = true;
    });
    items = await dbHelper.getAllLocations();

    if (items.length == 0) {
      print("no locations");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: const Color(0xFF1EB980)),
            onPressed: () {
              Navigator.of(context)
                  .push(MyCustomRoute(builder: (context) => SearchPage()))
                  .whenComplete(loadLocations);
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: const Color(0xFF1EB980)),
            onPressed: () {
              Navigator.push(
                context,
                MyCustomRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )
            : Center(
                child: items.length != 0
                    ? Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: ListView.builder(
                          itemCount: this.items.length,
                          itemBuilder: _futureBuilder,
                        ),
                      )
                    : Center(
                        child: Column(
                        children: <Widget>[
                          Text("No Saved Locations",
                              style: TextStyle(color: Colors.white)),
                          IconButton(
                              icon: Icon(Icons.refresh,
                                  color: const Color(0xFF1EB980)),
                              tooltip: 'Refresh',
                              onPressed: () {
                                loadLocations();
                              })
                        ],
                      )),
              ),
      ),
    );
  }

  Widget _futureBuilder(BuildContext context, int index) {
    var location = this.items[index];
    return FutureBuilder(
        future: api.fetchWeather(location.locId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Weather data = snapshot.data;
            return GestureDetector(
              onTap: () => _navigateToLocationDetail(context, location),
              child: _itemCard(data, context),
            );
          } else {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        });
  }

  void _navigateToLocationDetail(BuildContext context, Location location) {
    Navigator.of(context)
        .push(MyCustomRoute(
        builder: (context) => SavedLocationPage(location: location,)))
        .whenComplete(loadLocations);
  }

  Widget _itemCard(Weather item, BuildContext context){
    return SizedBox(
        height: 100.0,
        child: Card(
            color: Color.fromRGBO(54, 54, 64, .7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(top: 15.0),
                  leading: _itemThumbnail(item),
                  title: _itemTitle(item),
                  subtitle: _itemSubtitle(item),
                ),
              ],
            ),
            margin: EdgeInsets.all(5.0)
        )
    );
  }

  Widget _itemThumbnail(Weather item) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 50.0),
      child: Image.network(
          "https://openweathermap.org/img/w/${item.overalls.icon}.png",
          fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(Weather item) {
    return Text(item.name);
  }

  Widget _itemSubtitle(Weather item) {
    return Text(temp(item.numbers.temp));
  }
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
