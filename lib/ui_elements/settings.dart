import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../Services/preferences_helper.dart';

//stateful
/*class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  void _loadData() async {
      await PrefService.init(prefix: "_pref");
  }

  @override
  void initState() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: PreferencePage([
        PreferenceTitle("Temperature Metric"),
        RadioPreference(
          "fahrenheit",
          "f",
          "temp_metric",
          isDefault: true,
        ),
        RadioPreference(
          "celsius",
          "c",
          "temp_metric",
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
          onSelect: (){
            DynamicTheme.of(context).setBrightness(Brightness.light);
          },
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.dark);
          }
        ),
      ]),
    );
  }
}*/

//stateless

class SettingsPage extends StatelessWidget{
  final PreferencesHelper helper = PreferencesHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: PreferencePage([
        PreferenceTitle("Temperature Metric"),
        RadioPreference(
          "fahrenheit",
          "f",
          "temp_metric",
          isDefault: _currentMetric("f"),
          onSelect: (){
            helper.setMetric("f");
          },
        ),
        RadioPreference(
          "celsius",
          "c",
          "temp_metric",
          isDefault: _currentMetric("c"),
          onSelect: (){
            helper.setMetric("c");
          },
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: _currentTheme("light"),
          onSelect: (){
            DynamicTheme.of(context).setBrightness(Brightness.light);
            helper.setTheme("light");
          },
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
          isDefault: _currentTheme("dark"),
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.dark);
            helper.setTheme("dark");
          }
        ),
      ]),
    );
  }

  _currentTheme(String val){
    String current = PrefService.getString("ui_theme") ?? "light";
    if(current == val)
      return true;
    else
      return false;
  }

  _currentMetric(String val){
    String current = PrefService.getString("temp_metric") ?? "f";
    if(current == val)
      return true;
    else
      return false;
  }
}