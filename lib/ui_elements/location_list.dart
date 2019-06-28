import 'package:flutter/material.dart';
import 'package:sky_forecast/Models/location_model.dart';
import 'location_page.dart';
import 'styles.dart';

class LocationList extends StatelessWidget {
  final List<Location> locations;

  LocationList(this.locations);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locations")),
      body: Container(
        // Add box decoration
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.indigo[800],
              Colors.indigo[700],
              Colors.indigo[600],
              Colors.indigo[400],
            ],
          ),
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
    /*return Container(
      color: Colors.white,
      child: Card(
          contentPadding: EdgeInsets.all(10.0),
          leading: _itemThumbnail(location),
          title: _itemTitle(location),
          onTap: () => _navigateToLocationDetail(context, location)
      )
    );*/

    return GestureDetector(
      onTap: () => _navigateToLocationDetail(context, location),
      child: _itemCard(location),
    );
  }

  void _navigateToLocationDetail(BuildContext context, Location location) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPage(),
        ));
  }

  Widget _itemCard(Location location){
    return SizedBox(
      height: 100.0,
        child: Card(
            color: Color(0xff348AA7),
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
        color: Colors.black,
      ),);
  }
}