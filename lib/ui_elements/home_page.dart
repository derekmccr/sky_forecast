import 'package:flutter/material.dart';
import '../Services/database_helper.dart';
import 'package:sky_forecast/Models/location_database_model.dart';
import 'saved_location_page.dart';
import 'settings.dart';

class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => new _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  List<Location> items = new List();
  DatabaseHelper db = new DatabaseHelper();

  //placeholder until api solved
  final String url = "https://openweathermap.org/img/w/01d.png";


  // TODO: items.add needs to add weather info for each location ONCE API set up, currently no weather info

  @override
  void initState() {
    super.initState();

    db.getAllLocations().then((locations) {
      setState(() {
        locations.forEach((location) {
          items.add(location);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white,),
            onPressed: (){
              Navigator.push(context,
                MyCustomRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: items != null ? ListView.builder(
        itemCount: this.items.length,
        itemBuilder: _listViewItemBuilder,
      ) : Center(child: Text("No Saved Locations"))
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
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
  }

  Widget _itemThumbnail(Location location) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 50.0),
      child: Image.network(url, fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(Location location) {
    return Text(location.name);
  }

  Widget _itemSubtitle(Location location){
    return Text("Weather");
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
