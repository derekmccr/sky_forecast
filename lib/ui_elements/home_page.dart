import 'package:flutter/material.dart';
import '../API/database_helper.dart';
import '../API/location_model.dart';

class LocationListView extends StatefulWidget {
  @override
  _LocationListViewState createState() => new _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  List<Location> locations = new List();
  DatabaseHelper db = new DatabaseHelper();

  //placeholder until api solved
  final String url = "https://openweathermap.org/img/w/01d.png";

  @override
  void initState() {
    super.initState();

    db.getAllLocations().then((locations) {
      setState(() {
        locations.forEach((location) {
          locations.add(Location.fromMap(location));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
      ),
      body: ListView.builder(
        itemCount: this.locations.length,
        itemBuilder: _listViewItemBuilder,
      ),
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var location = this.locations[index];
    return ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: _itemThumbnail(location),
        title: _itemTitle(location),
        subtitle: _itemSubtitle(location),
        onTap: () {
          //Navigator.push(context,new MyCustomRoute(builder: (context) => LocationPage()),);
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
