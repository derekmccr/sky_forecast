import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import '../Services/shared_preferences_helper.dart';

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
          isDefault: _matchMetric("fahrenheit"),
          onSelect: _setMetric("fahrenheit"),
        ),
        RadioPreference(
          "celsius",
          "c",
          "tempMetric",
          isDefault: _matchMetric("celsius"),
          onSelect: _setMetric("celsius"),
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: _matchTheme("l"),
          onSelect: _setTheme("l"),
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
          isDefault: _matchTheme("d"),
          onSelect: _setTheme("d"),
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