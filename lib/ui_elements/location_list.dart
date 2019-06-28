import 'package:flutter/material.dart';
import '../API/location_model.dart';
import 'location_page.dart';
import 'styles.dart';

class LocationList extends StatelessWidget {
  final List<Location> locations;

  LocationList(this.locations);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locations")),
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
        onTap: () => _navigateToLocationDetail(context, location));
  }

  void _navigateToLocationDetail(BuildContext context, Location location) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPage(),
        ));
  }

  Widget _itemThumbnail(Location location) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: Image.network("https://openweathermap.org/img/w/01d.png", fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(Location location) {
    return Text('${location.name}');
  }
}