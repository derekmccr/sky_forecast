import 'package:flutter/material.dart';
import 'Mocks/location_mocks.dart';
import 'ui_elements/location_list.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

main() async {
  await PrefService.init(prefix: "_pref");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //load mock data
  final mockLocations = MockLocation.fetchAll();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.indigo,
        brightness: brightness,
        fontFamily: "Muli"
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: "Sky Forecast",
          theme: theme,
          //home: LocationListView(),
          home: LocationList(mockLocations),
        );
      },
    );
  }
}




