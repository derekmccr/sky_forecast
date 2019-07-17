import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import '../Services/shared_preferences_helper.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class SettingsPage extends StatelessWidget{
  final SharedPreferencesHelper pref = SharedPreferencesHelper();

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
          "tempMetric",
          isDefault: true,
          onSelect: _setMetric("fahrenheit"),
        ),
        RadioPreference(
          "celsius",
          "c",
          "tempMetric",
          //isDefault: _matchMetric("celsius"),
          onSelect: _setMetric("celsius"),
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
          //isDefault: _matchTheme("d"),
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.dark);
          }
        ),
      ]),
    );
  }

  //functions to find default value
  bool _matchMetric(String val){
    if(pref.getUserMetric() == val)
      return true;
    else
      return false;
  }
  bool _matchTheme(String val){
    if(pref.getUserTheme() == val)
      return true;
    else
      return false;
  }

  //functions to set new value
  _setMetric(String val){
    pref.setUserMetric(val);
  }
  _setTheme(String val){
    pref.setUserTheme(val);
  }
}