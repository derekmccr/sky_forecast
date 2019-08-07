import 'package:flutter/material.dart';
import '../Services/database_helper.dart';
import '../Services/weather_api.dart';
import '../Models/location_database_model.dart';
import 'saved_location_page.dart';
import 'settings.dart';
import 'search_page.dart';
import '../Models/weather_model.dart';
import 'package:preferences/preferences.dart';
import 'styles.dart';

//Home Page - houses list of all saved locations with brief overview for each location
class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => new _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  List<Location> items = new List();
  List<Weather> data = new List();
  final dbHelper = DatabaseHelper.instance;
  final WeatherApi api = new WeatherApi();
  bool isLoading = false;

  //placeholder until api solved
  final String url = "https://openweathermap.org/img/w/01d.png";

  // TODO: work on cards & list view

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
    if(items.length != 0){
      if(data.length != 0){
        data.clear();
      }
      for(int i = 0; i < items.length; i++){
        data.add(await api.fetchWeather(items[i].locId));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          itemBuilder: _listItemBuilder,
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

  Widget _listItemBuilder(BuildContext context, int index){
    return GestureDetector(
      onTap: () => _navigateToLocationDetail(context, items[index]),
      child: _itemCard(data[index], context),
    );
  }

  void _navigateToLocationDetail(BuildContext context, Location location) {
    Navigator.of(context)
        .push(MyCustomRoute(
        builder: (context) => SavedLocationPage(location: location,)))
        .whenComplete(loadLocations);
  }

  Widget _itemCard(Weather item, BuildContext context){
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(54, 54, 64, .7)),
        child: _makeListTile(item),
      ),
    );
  }

  Widget _makeListTile(Weather item){
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration:  BoxDecoration(
            border:  Border(
                right:  BorderSide(width: 1.0, color: const Color(0xFF1EB980)))),
        child: _itemThumbnail(item),
      ),
      title: Text(item.name, style: Styles.tileHeader),
      trailing: Text(temp(item.numbers.temp), style: Styles.tileTrailing),
    );
  }

  Widget _itemThumbnail(Weather item) {
    return Image.network(
          "https://openweathermap.org/img/w/${item.overalls.icon}.png",
          fit: BoxFit.fitWidth
    );
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
