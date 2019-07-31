import 'package:flutter/material.dart';
import 'Mocks/location_mocks.dart';
import 'ui_elements/location_list.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'ui_elements/home_page.dart';

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
      defaultBrightness: Brightness.dark,
      data: (brightness) => new ThemeData(
        primarySwatch: MaterialColor(0xFF363640, {
          50: Color.fromRGBO(54, 54, 64, 0.1),
          100: Color.fromRGBO(54, 54, 64, 0.2),
          200: Color.fromRGBO(54, 54, 64, 0.3),
          300: Color.fromRGBO(54, 54, 64, 0.4),
          400: Color.fromRGBO(54, 54, 64, 0.5),
          500: Color.fromRGBO(54, 54, 64, 0.6),
          600: Color.fromRGBO(54, 54, 64, 0.7),
          700: Color.fromRGBO(54, 54, 64, 0.8),
          800: Color.fromRGBO(54, 54, 64, 0.9),
          900: Color.fromRGBO(54, 54, 64, 1)
        }),
        brightness: brightness,
        fontFamily: "Muli"
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: "Sky Forecast",
          theme: theme,
          home: LocationListView(),
          //home: LocationList(mockLocations),
        );
      },
    );
  }
}




