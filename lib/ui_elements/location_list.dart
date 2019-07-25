import 'package:flutter/material.dart';
import 'package:sky_forecast/Models/location_database_model.dart';
import 'saved_location_page.dart';
import 'settings.dart';
import 'search_page.dart';

//TODO: build list from saved locations to users storage
//TODO: fetch current weather for each location to show snapshot on each card

class LocationList extends StatelessWidget {
  final List<Location> locations;

  LocationList(this.locations);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                Navigator.push(context,
                  MyCustomRoute(builder: (context) => SearchPage()),
                );
              },
          ),
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
        //add box single color
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor
        ),
        child: ListView.builder(
          itemCount: this.locations.length,
          itemBuilder: _listViewItemBuilder,
        ),
      )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var location = this.locations[index];

    return GestureDetector(
      onTap: () => _navigateToLocationDetail(context, location),
      child: _itemCard(location, context),
    );
  }

  void _navigateToLocationDetail(BuildContext context, Location locationn) {
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => SavedLocationPage(location: locationn,),
        ));
  }

  Widget _itemCard(Location location, BuildContext context){
    return SizedBox(
      height: 100.0,
        child: Card(
            color: new Color(0xFF363640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(top: 15.0),
                  leading: _itemThumbnail(location),
                  title: _itemTitle(location),
                ),
              ],
            ),
            margin: EdgeInsets.all(5.0)
        )
    );
  }

  Widget _itemThumbnail(Location location) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: Image.network("https://openweathermap.org/img/w/01d.png", fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(Location location) {
    return Text(location.name,
      style: TextStyle(
        fontSize: 25.0,
        color: Colors.white
      ),
    );
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