import 'package:flutter/material.dart';
import '../Services/database_helper.dart';
import '../Services/weather_api.dart';
import 'package:sky_forecast/Models/location_database_model.dart';
import 'saved_location_page.dart';
import 'settings.dart';
import 'search_page.dart';

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


  // TODO: items.add needs to add weather info for each location ONCE API set up, currently no weather info

  @override
  void initState() {
    super.initState();

    loadLocations();
  }

  loadLocations() async{
    setState(() {
      isLoading = true;
    });
    items = await dbHelper.getAllLocations();

    if(items.length == 0){
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
            onPressed: (){
              Navigator.push(context,
                MyCustomRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: const Color(0xFF1EB980)),
            onPressed: (){
              Navigator.push(context,
                MyCustomRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: isLoading ? CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ) : Center(
          child: items.length != 0 ? ListView.builder(
                itemCount: this.items.length,
                itemBuilder: _futureBuilder,
              ): Center(child: Column(children: <Widget>[
            Text("No Saved Locations", style: TextStyle(color: Colors.white)),
            IconButton(
                icon: Icon(Icons.refresh, color: const Color(0xFF1EB980)),
                tooltip: 'Refresh',
                onPressed: () {
                  loadLocations();
                }
            )
          ],)),
        ),
      ),
      /*body: Center(
        child: items.length != 0 ? Column(
          children: <Widget>[
            ListView.builder(
              itemCount: this.items.length,
              itemBuilder: _futureBuilder,
            ),
            IconButton(
                icon: Icon(Icons.refresh, color: const Color(0xFF1EB980)),
                tooltip: 'Refresh',
                onPressed: () {
                  loadLocations();
                }
            )
          ],
        ) : Center(child: Column(children: <Widget>[
          Text("No Saved Locations", style: TextStyle(color: Colors.white)),
          IconButton(
              icon: Icon(Icons.refresh, color: const Color(0xFF1EB980)),
              tooltip: 'Refresh',
              onPressed: () {
                loadLocations();
              }
          )
        ],)),
      )*/
    );
  }

  /*Widget _listViewItemBuilder(BuildContext context, int index) {
    var location = this.items[index];
    return ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: _itemThumbnail(location),
        title: _itemTitle(location),
        subtitle: _itemSubtitle(location),
        onTap: () {
          Navigator.push(context, MyCustomRoute(builder: (context) => SavedLocationPage()),);
        }
    );
  }*/
  
  Widget _futureBuilder(BuildContext context, int index){
    var location = this.items[index];
    return FutureBuilder(
        future: api.fetchWeather(location.locId),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListTile(
                contentPadding: EdgeInsets.all(10.0),
                leading: _itemThumbnail(snapshot),
                title: _itemTitle(snapshot),
                subtitle: _itemSubtitle(snapshot),
                onTap: () {
                  Navigator.push(context, MyCustomRoute(builder: (context) => SavedLocationPage()),);
                }
            );
          }
          else{
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        }
    );
  }

  Widget _itemThumbnail(AsyncSnapshot snapshot) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 50.0),
      child: Image.network("https://openweathermap.org/img/w/${snapshot.data.overalls.icon}.png", fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(AsyncSnapshot snapshot) {
    return Text(snapshot.data.name);
  }

  Widget _itemSubtitle(AsyncSnapshot snapshot){
    return Text(snapshot.data.numbers.temp.toString());
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
