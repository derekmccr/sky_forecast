import 'package:flutter/material.dart';
import 'Mocks/location_mocks.dart';
import 'ui_elements/location_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //load mock data
  final mockLocations = MockLocation.fetchAll();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Forecast',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: LocationListView(),
      home: LocationList(mockLocations),
    );
  }
}




