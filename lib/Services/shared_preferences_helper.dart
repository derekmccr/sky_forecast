/*import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _userMetric = "metric";
  static final String _userTheme = "theme";

  //getter & setter for user's preferred metric reading for temp
  getUserMetric() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userMetric) ?? "fahrenheit";
  }
  setUserMetric(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userMetric, value);
  }

  getUserTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTheme) ?? "l";
  }
  setUserTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userTheme, value);
  }
}*/

import 'package:preferences/preferences.dart';

class PreferencesHelper{
  setMetric(String val) async{
    await PrefService.init(prefix: "_pref");
    PrefService.setString("temp_metric", val);
  }
}
